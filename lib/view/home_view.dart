// ignore_for_file: prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view_model/home_view_model.dart';
import 'package:flutter_hungry_hub/view_model/get_data_viewmodel.dart';
import 'package:flutter_hungry_hub/widgets/common/image_extention.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/food_view/burger_view.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/food_view/chicken_view.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/food_view/combo_view.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/food_view/snacks_view.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/text/title_see_more.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../widgets/common_widget/card/product_list_view_hori.dart';
import '../widgets/common_widget/inwell/home_in_well.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(HomeViewModel());
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(ImageAsset.locationRed),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DELIVER TO',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffF44336),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.userData['address'].toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
                child: ClipOval(
                  child: Image.asset(
                    ImageAsset.users,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff32343E),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                  children: [
                    TextSpan(
                      text:
                          'Hey ${controller.userData['fullName']?.toString() ?? 'User'} ,',
                    ),
                    const TextSpan(
                      text: ' Have a good Day!',
                      style: TextStyle(
                        color: Color(0xffF44336),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, // Chiều rộng cụ thể
                height: 52, // Chiều cao cụ thể
                child: TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search dishes, restaurants',
                    hintStyle: const TextStyle(
                        color: Color(0xff32343E),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    prefixIcon: SizedBox(
                      height: 16, // Chiều cao mới
                      width: 16, // Chiều rộng mới
                      child: Image.asset(
                        ImageAsset.searchHome,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Image.asset(
                        controller.isListening
                            ? ImageAsset
                                .microphone // Hiển thị hình ảnh micro khi đang nghe
                            : ImageAsset
                                .microphoneUn, // Hiển thị hình ảnh micro khi không nghe
                        height:
                            24, // Đặt chiều cao của hình ảnh (tuỳ chỉnh theo nhu cầu)
                        width:
                            24, // Đặt chiều rộng của hình ảnh (tuỳ chỉnh theo nhu cầu)
                      ),
                      onPressed: () {
                        controller
                            .toggleListening(); // Chuyển đổi trạng thái của micro
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xffB2EBF2),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    debugPrint('Từ khóa tìm kiếm: $value');
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 4,
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
                      child: HomeInWell(
                        image: ImageAsset.combo,
                        text: 'Combo',
                      )),
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
                      child: HomeInWell(
                        image: ImageAsset.chicken,
                        text: 'Chicken',
                      )),
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
                      child: HomeInWell(
                        image: ImageAsset.burger,
                        text: 'Burger',
                      )),
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
                      child: HomeInWell(
                        image: ImageAsset.snack,
                        text: 'Snacks',
                      )),
                  const SizedBox(
                    width: 4,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 211,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // Chỉnh góc bo tròn
                  border: Border.all(
                      color: Colors.white,
                      width: 2), // Đường viền của container
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      20), // Đảm bảo ảnh cũng có góc bo tròn như container
                  child: Image.asset(
                    ImageAsset.homeChicken,
                    fit: BoxFit.cover, // Làm ảnh fill toàn bộ container
                  ),
                ),
              ),
              InkWell(
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
                  child: const TitleSeeMore(title: 'Combo')),
              SizedBox(
                height: 285, // Chiều cao cố định cho danh sách ngang
                child: _isLoadingProducts
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          if ((product['Category'] == 'Combo 1 Người' ||
                              product['Category'] == 'Combo Nhóm') && (product['Show'] == 1)) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ProductCard(product: product),
                            );
                          }
                          return const SizedBox
                              .shrink(); // Ẩn các sản phẩm không phù hợp
                        },
                      ),
              ),
              InkWell(
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
                  child: const TitleSeeMore(title: 'Chicken')),
              SizedBox(
                height: 285, // Chiều cao cố định cho danh sách ngang
                child: _isLoadingProducts
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          if ((product['Category'] == 'Gà Rán - Gà Quay') && (product['Show'] == 1)) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ProductCard(product: product),
                            );
                          }
                          return const SizedBox
                              .shrink(); // Ẩn các sản phẩm không phù hợp
                        },
                      ),
              ),
              InkWell(
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
              SizedBox(
                height: 285, // Chiều cao cố định cho danh sách ngang
                child: _isLoadingProducts
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          if ((product['Category'] == 'Burger - Cơm - Mì Ý')&& (product['Show'] == 1)) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ProductCard(product: product),
                            );
                          }
                          return const SizedBox
                              .shrink(); // Ẩn các sản phẩm không phù hợp
                        },
                      ),
              ),
              InkWell(
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
              SizedBox(
                height: 285, // Chiều cao cố định cho danh sách ngang
                child: _isLoadingProducts
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          if ((product['Category'] == 'Thức ăn nhẹ') && (product['Show'] == 1)) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ProductCard(product: product),
                            );
                          }
                          return const SizedBox
                              .shrink(); // Ẩn các sản phẩm không phù hợp
                        },
                      ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
