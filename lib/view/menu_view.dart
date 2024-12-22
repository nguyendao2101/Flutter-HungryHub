// ignore_for_file: prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view_model/menu_view_model.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/food_view/burger_view.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/food_view/chicken_view.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/food_view/combo_view.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/food_view/drinks_and_desserts_view.dart';
import 'package:get/get.dart';

import '../view_model/get_data_viewmodel.dart';
import '../widgets/common_widget/card/product_list_view_veri.dart';
import '../widgets/common_widget/food_view/snacks_view.dart';
import '../widgets/common_widget/text/title_see_more.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final controller = Get.put(MenuViewModel());
  final controllerTestView = Get.put(GetDataViewModel());

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _stores = [];
  String? _selectedProductId;
  String? _selectedStoreId;
  bool _isLoadingProducts = true;
  bool _isLoadingStores = false;
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    // _loadStores();
  }

  Future<void> _loadProducts() async {
    await controllerTestView.fetchProducts();
    setState(() {
      _products = controllerTestView.products;
      _isLoadingProducts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff32343E),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      TextSpan(text: 'Delicious Food '),
                      TextSpan(
                        text: 'For You',
                        style: TextStyle(color: Color(0xffF44336)),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComboView(
                            listDS: controllerTestView.products,
                          ),
                        ),
                      );
                    },
                    child: const TitleSeeMore(title: 'Combo 1 Person')),
                _buildProductList('Combo 1 Người'),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComboView(
                            listDS: controllerTestView.products,
                          ),
                        ),
                      );
                    },
                    child: const TitleSeeMore(title: 'Group Combo')),
                _buildProductList('Combo Nhóm'),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChickenView(
                            listDS: controllerTestView.products,
                          ),
                        ),
                      );
                    },
                    child: const TitleSeeMore(
                        title: 'Fried Chicken - Roast Chicken')),
                _buildProductList('Gà Rán - Gà Quay'),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BurgerView(
                            listDS: controllerTestView.products,
                          ),
                        ),
                      );
                    },
                    child:
                        const TitleSeeMore(title: 'Burger - Rice - Spaghetti')),
                _buildProductList('Burger - Cơm - Mì Ý'),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SnacksView(
                            listDS: controllerTestView.products,
                          ),
                        ),
                      );
                    },
                    child: const TitleSeeMore(title: 'Snacks')),
                _buildProductList('Thức ăn nhẹ'),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DrinksAndDessertsView(
                            listDS: controllerTestView.products,
                          ),
                        ),
                      );
                    },
                    child:
                        const TitleSeeMore(title: 'Drinks And DessertsView')),
                _buildProductList('Thức uống & tráng miệng'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(String category) {
    // Lọc các sản phẩm theo danh mục
    final filteredProducts =
        _products.where((p) => ((p['Category'] == category) && (p['Show'] == 1))).toList();

    return SizedBox(
      height: 1425, // Điều chỉnh chiều cao phù hợp nếu cần
      child: _isLoadingProducts
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredProducts.length
                  .clamp(0, 5), // Hiển thị tối đa 5 sản phẩm
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ProductCardVeri(product: product),
                );
              },
            ),
    );
  }
}
