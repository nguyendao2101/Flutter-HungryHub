import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view_model/get_data_viewmodel.dart';
import '../../../view_model/orders_view_model.dart';
import '../evaluate/evaluate.dart';

class ConfimOrder extends StatefulWidget {
  const ConfimOrder({super.key});

  @override
  State<ConfimOrder> createState() => _ConfimOrderState();
}

class _ConfimOrderState extends State<ConfimOrder> {
  final getDataViewModel = Get.put(GetDataViewModel());
  final ordersViewModel = Get.put(OrdersViewModel());

  List<Map<String, dynamic>> _orderTracking = [];
  bool _isLoadingOrderTracking = true;

  @override
  void initState() {
    super.initState();
    _loadOrderTracking();
  }

  Future<void> _loadOrderTracking() async {
    await getDataViewModel.fetchProducts(); // Fetch products or orders data
    setState(() {
      _orderTracking = getDataViewModel.orderTracking;
      _isLoadingOrderTracking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoadingOrderTracking
          ? const Center(child: CircularProgressIndicator())
          : (_orderTracking.isEmpty
          ? const Center(child: Text("Your Confirm Cart is empty."))
          : SingleChildScrollView(
        child: Column(
          children: [
            // Loop through the order tracking data and display
            for (var order in _orderTracking) ...[
              // Wrap the order details and products inside a Container
              if((order['userId'].toString() == ordersViewModel.userId.toString()) && (order['status'].toString() == 'Confirm'))
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display Order ID
                    Text(
                      'Order ID: ${order['orderId']}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xff1C1B1F),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    // Loop through the list of products and display each product
                    if (order['listProducts'] is List)
                      for (var product in order['listProducts'])
                        Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12,
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product['imageURL'] ?? '',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              product['nameProduct'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xff1C1B1F),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            subtitle: Text(
                              "Quantity: ${product['quantities']}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xff1C1B1F),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 4,),
                    const Divider(),
                    const SizedBox(height: 4,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address: ${order['deliveryAddress']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff1C1B1F),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          // Display Payment Method
                          Text(
                            'Payment Method: ${order['paymentMethod']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff1C1B1F),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          // Display Place of Purchase
                          Text(
                            'Place of Purchase: ${order['placeOfPurchase']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff1C1B1F),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          // Display Purchase Date
                          const SizedBox(height: 4.0),
                          // Display Total
                          Text(
                            'Total: ${order['total']} VND',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xffA02334),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ],
        ),
      )),
    );
  }
}
