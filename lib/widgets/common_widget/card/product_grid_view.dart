import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view_model/home_view_model.dart';
import 'package:get/get.dart';

import '../../common/image_extention.dart';
import '../evaluate/evaluate.dart';
import '../food_detail/food_detail.dart';
import '../text/truncated_text.dart';

class ProductGridView extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductGridView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeViewModel());
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetail(productDetail: product,),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  product['ImageUrl'] ?? '',
                  width: double.infinity,
                  height: 95,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TruncatedText(
                      text: product['Name'],
                      maxWidth: 180,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff32343E),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Giá: ${product['Price']} VND',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff32343E),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Evaluate(height: 24, width: 71),
                      Text(
                        ' • 32 min',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      controller.addToShoppingCart(product);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
