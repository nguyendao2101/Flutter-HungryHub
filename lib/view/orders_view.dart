import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view_model/orders_view_model.dart';
import 'package:flutter_hungry_hub/widgets/common/image_extention.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../widgets/common_widget/evaluate/evaluate.dart';
import '../widgets/common_widget/order/pay.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final controller = Get.put(OrdersViewModel());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Shopping Cart", style: TextStyle(
            fontSize: 24,
            color: Color(0xff32343E),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),),
        ),
        body: Obx(() {
          if (controller.ordersList.isEmpty) {
            return const Center(child: Text("Your Shopping Cart is empty."));
          }

          return ListView.builder(
            itemCount: controller.ordersList.length,
            itemBuilder: (context, index) {
              final item = controller.ordersList[index];
              final isSelected = controller.selectedItems.contains(index); // Kiểm tra item có được chọn

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12), // Cách lề cho container// Padding bên trong container
                decoration: BoxDecoration(
                  color: Colors.white, // Màu nền của container
                  borderRadius: BorderRadius.circular(10), // Để bo tròn góc của container
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Đổ bóng
                    ),
                  ],
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        8),
                    child: Image.network(
                      item['ImageUrl'], // Hiển thị hình ảnh sản phẩm
                      fit: BoxFit.fill,
                      width: 80,
                      height: 200,
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['Name'], style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff32343E),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item['Price'].toString()} VND', style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xffA02334),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),),
                          const Evaluate(height: 24, width: 71),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          controller.decreaseQuantity(index);
                        },
                        icon: Container(
                          height: 22,
                          width: 22,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle, // Hình tròn
                            color: Color(0xffD9D9D9), // Màu nền
                          ),
                          child: const Icon(Icons.remove, color: Colors.black, size: 16,),
                        ),
                      ),
                      Text('${item['Quantity'] ?? 1}'),
                      IconButton(
                        onPressed: () {
                          controller.increaseQuantity(index);
                        },
                        icon: Container(
                          height: 22,
                          width: 22,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle, // Hình tròn
                            color: Color(0xffD9D9D9), // Màu nền
                          ),
                          child: const Icon(Icons.add, color: Colors.black, size: 16,),
                        ),
                      ),
                    ],
                  ),
                  trailing: Obx(() => Checkbox(
                    value: controller.selectedItems.contains(index),
                    onChanged: (bool? value) {
                      controller.toggleItemSelection(index); // Cập nhật trạng thái chọn
                    },
                    activeColor: const Color(0xffD42323), // Màu khi checkbox được chọn
                    checkColor: Colors.white,
                  )),
                ),
              );

            },
          );
        }),
        floatingActionButton: Obx(() {
          if (controller.selectedItems.isEmpty) {
            return const SizedBox.shrink(); // Ẩn nút nếu không có sản phẩm nào được chọn
          }
          return FloatingActionButton.extended(
            onPressed: () {
              Get.to(() => Pay(product: controller.checkoutSelectedItems(),));
              // controller.checkoutSelectedItems(); // Xử lý thanh toán
            },
            label: const Text('Buy', style: TextStyle(
              fontSize: 14,
              color: Color(0xffFFFFFF),
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),),
            backgroundColor: const Color(0xffEF5350),
            icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white,),
          );
        }),
      ),
    );
  }
}
