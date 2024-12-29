import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view_model/get_data_viewmodel.dart';
import 'package:flutter_hungry_hub/view_model/home_view_model.dart';
import 'package:flutter_hungry_hub/view_model/orders_view_model.dart';
import 'package:flutter_hungry_hub/widgets/common/image_extention.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/button/bassic_button.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/order/select_payment.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';

import '../../../view/test.dart';
import '../evaluate/evaluate.dart';
import '../profile/order_tracking.dart';

class Pay extends StatefulWidget {
  List<Map<String, dynamic>> product;
  Pay({super.key, required this.product});

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  final controller = Get.put(OrdersViewModel());
  final controllerHome = Get.put(HomeViewModel());
  final controllerGetData = Get.put(GetDataViewModel());
  TextEditingController couponController = TextEditingController();
  double coupon = 0;  // Khai báo coupon là biến trạng thái
  double delivery = 30000;  // Khai báo coupon là biến trạng thái

  //
  List<Map<String, dynamic>> _stores = [];
  String? _selectedStoreId;
  bool _isLoadingStores = false;
  String? selectedLocation; // Lưu địa chỉ được chọn
  String? selectedLocationName ; // Lưu địa chỉ được chọn
  var selectedPaymentMethod = Rxn<Map<String, String>>();

  final List<Map<String, String>> paymentMethods = [
    {'id': '1', 'name': 'Cash on Delivery'},
    {'id': '2', 'name': 'Payment via VNPay'},
    {'id': '3', 'name': 'Payment via Stripe'},
  ];
  String responseCode = '00';
  String imageURL = '';
  String imageFace = '';
  List<int> quantities = [];
  List<String> nameProduct = []; // Sửa kiểu dữ liệu của nameProduct thành List<String>

  @override
  void initState() {
    super.initState();
    controller.fetchStores();

    // Sửa việc chuyển đổi `Name` sang kiểu String
    quantities = widget.product.map<int>((item) => item['Quantity'] ?? 0).toList();
    nameProduct = widget.product.map<String>((item) => item['Name'] ?? '').toList(); // Sửa kiểu dữ liệu thành String
    imageURL = widget.product.isNotEmpty
        ? (widget.product[0]['ImageUrl'] ?? '') // Lấy giá trị đầu tiên hoặc rỗng
        : '';
    imageFace = widget.product.isNotEmpty
        ? (widget.product[0]['ImageUrlFacebook'] ?? '') // Lấy giá trị đầu tiên hoặc rỗng
        : '';
  }




  @override
  Widget build(BuildContext context) {
    double total1 = controller.calculateTotal(widget.product);  // Cập nhật tổng tiền với coupon
    double total = controller.calculateTotal(widget.product) - coupon + delivery;  // Cập nhật tổng tiền với coupon
    final selectedStore = Rx<Map<String, dynamic>?>(null); // Lưu cửa hàng được chọn
    final selectedAddress = Rx<Map<String, dynamic>?>(null); // Lưu cửa hàng được chọn
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffD9D9D9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      ImageAsset.backButton,
                      height: 5,
                      width: 6,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'Pay Your Order',
                style: TextStyle(
                  fontSize: 24,
                  color: const Color(0xff32343E),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        body: SingleChildScrollView(

          child: Column(
            children: [
              // ListView.builder
              ListView.builder(
                itemCount: widget.product.length,
                shrinkWrap: true,  // Đảm bảo ListView không chiếm quá nhiều không gian
                physics: const NeverScrollableScrollPhysics(), // Tắt cuộn trong ListView
                itemBuilder: (context, index) {
                  final item = widget.product[index];
                  return Container(
                    height: 120,
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item['ImageUrl'],
                          fit: BoxFit.fill,
                          width: 80,
                          height: 200,
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item['Name'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff32343E),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item['Price'].toString()} VND',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffA02334),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Evaluate(height: 24, width: 71, productDetail: item ?? {},),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Quantity: ${item['Quantity'].toString()}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xff32343E),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // Chọn cửa hàng
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: couponController,
                        decoration: InputDecoration(
                          hintText: 'Add Promo code',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff32343E),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                          border: InputBorder.none, // Bỏ viền
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Điều chỉnh padding để căn chỉnh nội dung
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none, // Bỏ viền khi không focus
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none, // Bỏ viền khi có focus
                          ),
                        ),
                      ),

                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        String enteredCode = couponController.text.trim(); // Lấy giá trị từ TextField
                        var matchingCoupon = controller.coupons.firstWhere(
                              (coupon) => coupon['id'] == enteredCode,
                          orElse: () => {}, // Trả về một map rỗng khi không tìm thấy
                        );

                        if (matchingCoupon.isNotEmpty) {
                          // Nếu tìm thấy mã giảm giá
                          print('Coupon found: ${matchingCoupon['coupon']} VND');
                          setState(() {
                            coupon = matchingCoupon['coupon'].toDouble();  // Cập nhật coupon khi tìm thấy
                          });
                        } else {
                          // Nếu không tìm thấy mã giảm giá
                          print('Invalid coupon code');
                          setState(() {
                            coupon = 0;  // Đặt lại coupon nếu không tìm thấy
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xffFBFBFB),
                        backgroundColor: const Color(0xffEF5350), // Màu chữ khi button được nhấn
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4), // Bo góc với bán kính 12
                        ),
                      ),
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ),
              _moneyToTal('Total', total1, const Color(0xff5B645F)),
              _moneyToTal('Delivery fees', delivery, const Color(0xff5B645F)),
              _moneyToTal('Promo', coupon, const Color(0xff5B645F)),
              _moneyToTal('Total', total, const Color(0xff0D0D0D)),
              const SizedBox(height: 20,),
              FutureBuilder<Map<String, String>>(
                future: controller.fetchLocationsFromFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Lỗi khi tải dữ liệu: ${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final Map<String, String> locations = snapshot.data!;

                    // Tạo danh sách DropdownMenuItem từ dữ liệu
                    final dropdownItems = locations.entries
                        .map((entry) => DropdownMenuItem<String>(
                      value: entry.key, // ID địa chỉ làm giá trị
                      child: Text(
                        entry.value, // Tên địa chỉ hiển thị
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ))
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              labelText: 'Select Address',  // Thay 'Select Store' bằng 'Chọn địa chỉ'
                              labelStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.blue),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedLocation,
                                hint: const Text(
                                  'Select Address',  // Thay 'Select a store' bằng 'Chọn địa chỉ'
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff32343E),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                isExpanded: true,  // Đảm bảo nút dropdown chiếm toàn bộ chiều ngang
                                items: dropdownItems,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedLocation = newValue;
                                    selectedLocationName = locations[selectedLocation];
                                  });

                                  // In ra giá trị được chọn
                                  print('Địa chỉ được chọn: $selectedLocationName');
                                },
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff32343E),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                ),
                                icon: Image.asset(ImageAsset.downArrow, height: 18,),
                              ),
                            ),
                          )

                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text('Không có địa chỉ nào.'));
                  }
                },
              ),
              Obx(() {
                if (controller.stores.isEmpty) {
                  return const Center(child: Text('No stores available.', style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff32343E),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),));
                }
                final List<DropdownMenuItem<Map<String, dynamic>>> dropdownItems = controller.stores
                    .where((store) {
                  final List<dynamic> products = store['ListProducts'] ?? [];
                  return widget.product.any((productSelect) =>
                      products.any((product) => product['id'] == productSelect['id']));
                })
                    .map((store) => DropdownMenuItem<Map<String, dynamic>>(
                  value: store,
                  child: Text(store['Name'] ?? 'No Name', style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff32343E),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),),
                ))
                    .toList();

                if (dropdownItems.isEmpty) {
                  return const Center(child: Text('No stores match the selected products.'));
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          labelText: 'Select Store',
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Map<String, dynamic>>(
                            value: selectedStore.value,
                            items: dropdownItems,
                            onChanged: (store) {
                              selectedStore.value = store;
                              print('Selected store: ${selectedStore.value}');
                            },
                            hint: const Text(
                              'Select a store',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff32343E),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            isExpanded: true,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff32343E),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                            ),
                            dropdownColor: Colors.white,
                            icon: Image.asset(ImageAsset.downArrow, height: 18,),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      // const SizedBox(height: 16.0),
                      // if (selectedStore.value != null)
                      //   Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text('Store Name: ${selectedStore.value!['Name'] ?? 'No Name'}', style: const TextStyle(
                      //         fontSize: 16,
                      //         color: Color(0xff32343E),
                      //         fontWeight: FontWeight.w400,
                      //         fontFamily: 'Poppins',
                      //       ),),
                      //       Text('Address: ${selectedStore.value!['Address'] ?? 'No Address'}', style: const TextStyle(
                      //         fontSize: 16,
                      //         color: Color(0xff32343E),
                      //         fontWeight: FontWeight.w400,
                      //         fontFamily: 'Poppins',
                      //       ),),
                      //       // const Text('Products:'),
                      //       // ...?selectedStore.value!['ListProducts']?.map<Widget>((product) {
                      //       //   return Text('- ${product['Name'] ?? 'No Name'}');
                      //       // }).toList(),
                      //     ],
                      //   )
                      // else
                      //   const Text('No store selected.', style: TextStyle(
                      //     fontSize: 16,
                      //     color: Color(0xff32343E),
                      //     fontWeight: FontWeight.w400,
                      //     fontFamily: 'Poppins',
                      //   ),),
                    ],
                  ),
                );
              }),
              Obx(() {
                // Tạo danh sách các mục Dropdown
                final List<DropdownMenuItem<Map<String, String>>> dropdownItems = paymentMethods
                    .map((method) => DropdownMenuItem<Map<String, String>>(
                  value: method,
                  child: Text(
                    method['name']!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff32343E),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ))
                    .toList();

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputDecorator(
                        decoration: InputDecoration(
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          labelText: 'Select Payment Method',
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Map<String, String>>(
                            value: selectedPaymentMethod.value,
                            items: dropdownItems,
                            onChanged: (method) {
                              selectedPaymentMethod.value = method;
                              print('Selected payment method: ${method!['name']}');
                            },
                            hint: const Text(
                              'Select Payment Method',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff32343E),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            isExpanded: true,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff32343E),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                            ),
                            dropdownColor: Colors.white,
                            icon: selectedPaymentMethod.value?['id'] == '1'
                                ? Image.asset(ImageAsset.money) // Thanh toán khi nhận hàng
                                : selectedPaymentMethod.value?['id'] == '2'
                                ? SvgPicture.asset(ImageAsset.vnpay, height: 48,) // Thanh toán VNPay
                                : selectedPaymentMethod.value?['id'] == '3'
                                ? Image.asset(ImageAsset.stripe, height: 48,) // Thanh toán Stripe
                                : const Icon(Icons.payment, color: Colors.grey), // Mặc định
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16.0),
                    ],
                  ),
                );
              }),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: BasicAppButton(
                  onPressed: () async {
                    // Debug giá trị trước khi xử lý
                    print('Selected Payment Method: ${selectedPaymentMethod.value}');
                    print('Response Code before payment: $responseCode');

                    if (selectedPaymentMethod.value?['id'] == '2') {
                      await onPayment(total);
                      if (responseCode == '00') {
                        _showPaymentMethod(context, selectedPaymentMethod);
                        await controllerGetData.addOrderToFirestore(
                          storeId: selectedStore.value!['id'],
                          userId: controller.userId.toString(),
                          deliveryAddress: selectedLocationName,
                          placeOfPurchase: selectedStore.value!['Name'],
                          paymentMethod: selectedPaymentMethod.value?['name'],
                          listProducts: [
                            for (int i = 0; i < quantities.length; i++)
                              {
                                "nameProduct": nameProduct[i],
                                "quantities": quantities[i],
                                "imageURL": imageURL,
                                "imageFace": imageFace
                              },
                          ],
                          total: total,
                        );
                      } else {
                        _showPaymentMethodFail(context, selectedPaymentMethod);
                      }
                    } else if (selectedPaymentMethod.value?['id'] == '3') {
                      _showPaymentMethod(context, selectedPaymentMethod);
                      await controllerGetData.addOrderToFirestore(
                        storeId: selectedStore.value!['id'],
                        userId: controller.userId.toString(),
                        deliveryAddress: selectedLocationName,
                        placeOfPurchase: selectedStore.value!['Name'],
                        paymentMethod: selectedPaymentMethod.value?['name'],
                        listProducts: [
                          for (int i = 0; i < quantities.length; i++)
                            {
                              "nameProduct": nameProduct[i],
                              "quantities": quantities[i],
                              "imageURL": imageURL,
                              "imageFace": imageFace
                            },
                        ],
                        total: total,
                      );
                    } else {
                      _showPaymentMethod(context, selectedPaymentMethod);
                      await controllerGetData.addOrderToFirestore(
                        storeId: selectedStore.value!['id'],
                        userId: controller.userId.toString(),
                        deliveryAddress: selectedLocationName,
                        placeOfPurchase: selectedStore.value!['Name'],
                        paymentMethod: selectedPaymentMethod.value?['name'],
                        listProducts: [
                          for (int i = 0; i < quantities.length; i++)
                            {
                              "nameProduct": nameProduct[i],
                              "quantities": quantities[i],
                              "imageURL": imageURL,
                              "imageFace": imageFace
                            },
                        ],
                        total: total,
                      );
                      controllerHome.addAllToPurchasedCart(widget.product);
                    }

                    // Debug sau khi xử lý
                    print('Response Code after payment: $responseCode');
                  },
                  title: 'Continue to payment',
                  sizeTitle: 16,
                  height: 62,
                  radius: 12,
                  colorButton: const Color(0xffFF7622),
                  fontW: FontWeight.w500,
                ),

              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget _moneyToTal(String title, double number, Color colorTitle){
    return Padding(
      padding:  const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(
            fontSize: 16,
            color: colorTitle,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),),
          Row(
            children: [
              Text(number.toString(), style: const TextStyle(
                fontSize: 16,
                color: Color(0xffA02334),
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),),
              const SizedBox( width: 8,),
              const Text('VND', style: TextStyle(
                fontSize: 16,
                color: Color(0xff1C1B1F),
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),),
            ],
          ),

        ],
      ),
    );
  }
  void _showPaymentMethodFail(BuildContext context, Rxn<Map<String, String>> selectedPaymentMethod) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.grey.withOpacity(0.8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Payment Confirmation',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xff32343E),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // if (selectedPaymentMethod.value?['id'] == '1')
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        // Add a check icon for visual confirmation
                        const SizedBox(height: 24),
                        Image.asset(ImageAsset.remove, height: 128,),
                        const SizedBox(height: 64),

                        const Text(
                          'Your order has been confirmed by HungryHub.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        // Button to go to Order Tracking
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xffE03137),
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  void _showPaymentMethod(BuildContext context, Rxn<Map<String, String>> selectedPaymentMethod) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.grey.withOpacity(0.8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Payment Confirmation',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xff32343E),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // if (selectedPaymentMethod.value?['id'] == '1')
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          // Add a check icon for visual confirmation
                          const SizedBox(height: 24),
                          Image.asset(ImageAsset.check, height: 128,),
                          const SizedBox(height: 64),

                          const Text(
                            'Your order has been confirmed by HungryHub.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48),
                          // Button to go to Order Tracking
                          TextButton(
                            onPressed: () {
                              Get.to(() => const OrderTracking(initialIndex: 0,));
                            },
                            child: const Text(
                              'Order Tracking',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xffE03137),
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // if (selectedPaymentMethod.value?['id'] == '2')
                  //   Align(
                  //     alignment: Alignment.center,
                  //     child: Column(
                  //       children: [
                  //         // Add a check icon for visual confirmation
                  //         const SizedBox(height: 24),
                  //         Image.asset(responseCode == '00' ? ImageAsset.check : ImageAsset.remove, height: 125,),
                  //         const SizedBox(height: 64),
                  //
                  //         const Text(
                  //           'Your order has been confirmed by HungruHub.',
                  //           style: TextStyle(
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.w500,
                  //             fontFamily: 'Poppins',
                  //             color: Colors.black87,
                  //           ),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //         const SizedBox(height: 48),
                  //         // Button to go to Order Tracking
                  //         TextButton(
                  //           onPressed: () {
                  //             // Get.to(() => const OrderTracking());
                  //             setState(() {
                  //               responseCode == '00';
                  //             });
                  //           },
                  //           child: const Text(
                  //             'Order Tracking',
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w500,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //           style: TextButton.styleFrom(
                  //             backgroundColor: const Color(0xffE03137),
                  //             padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(8),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Future<void> onPayment(double amount) async {
    final paymentUrl = VNPAYFlutter.instance.generatePaymentUrl(
      url: 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
      version: '2.0.1',
      tmnCode: 'YLLVXBWY',
      txnRef: DateTime.now().millisecondsSinceEpoch.toString(),
      orderInfo: 'Pay $amount VND',
      amount: amount,
      returnUrl: 'https://sandbox.vnpayment.vn/merchant_webapi/api/transaction',
      ipAdress: '192.168.10.10',
      vnpayHashKey: '1J9MHQHA5NK9C4J3D26CZO1HAPO02IJY',
      vnPayHashType: VNPayHashType.HMACSHA512,
      vnpayExpireDate: DateTime.now().add(const Duration(hours: 1)),
    );

    await VNPAYFlutter.instance.show(
      paymentUrl: paymentUrl,
      onPaymentSuccess: (params) {
        print('Params on success: $params');
        responseCode = params.containsKey('vnp_ResponseCode')
            ? params['vnp_ResponseCode']
            : 'No Response Code';
        print('Response Code on success: $responseCode');
      },
      onPaymentError: (params) {
        print('Params on error: $params');
        responseCode = 'Error';
        print('Response Code on error: $responseCode');
      },
    );
  }

}
