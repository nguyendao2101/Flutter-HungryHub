import 'package:flutter/material.dart';
import '../../common/image_extention.dart';
import '../text/truncated_text.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
              width: 201,
              height: 170,
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
                  maxWidth: 190,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Row(
              children: [
                Container(
                  height: 24,
                  width: 71,
                  decoration: BoxDecoration(
                    color: const Color(0xffEF5350),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(ImageAsset.starRating),
                        const Text(
                          '4.2',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Text(
                  ' • 32 min',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    // Thêm sản phẩm vào giỏ hàng
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
