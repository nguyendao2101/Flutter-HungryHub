import 'package:flutter/material.dart';
import 'package:flutter_hungry_hub/view/login_view.dart';
import 'package:flutter_hungry_hub/widgets/common/image_extention.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/button/bassic_button.dart';
import 'package:get/get.dart';

class LoadImagePannerView extends StatefulWidget {
  const LoadImagePannerView({super.key});

  @override
  _LoadImagePannerViewState createState() => _LoadImagePannerViewState();
}

class _LoadImagePannerViewState extends State<LoadImagePannerView> {
  // Khai báo PageController riêng cho từng PageView
  final PageController _pageController1 = PageController();
  final PageController _pageController2 = PageController();
  final PageController _pageController3 = PageController();

  @override
  void dispose() {
    // Giải phóng tài nguyên của các controller khi widget bị hủy
    _pageController1.dispose();
    _pageController2.dispose();
    _pageController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> imagesPanner = [
      ImageAsset.panner1,
      ImageAsset.panner2,
      ImageAsset.panner3,
    ];
    List<String> imagesLocationPanner = [
      ImageAsset.locationPanner1,
      ImageAsset.locationPanner2,
      ImageAsset.locationPanner3,
    ];
    List<String> tiltlePanner = [
      'All your favorites',
      'Order from choosen chef',
      'Free delivery offers'
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('  '), automaticallyImplyLeading: false),
      body: Stack(
        children: [
          // 1. PageView cho imagesPanner
          Positioned(
            top: 20, // Đặt cách trên cùng 20px
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4, // Chiếm 40% chiều cao
              child: PageView.builder(
                controller: _pageController1,
                itemCount: imagesPanner.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      imagesPanner[index],
                      height: 480, // Chiều cao của hình ảnh
                      width: 339, // Để ảnh rộng ra hết chiều ngang màn hình
                    ),
                  );
                },
                onPageChanged: (index) {
                  // Khi trang của PageView 1 thay đổi, thay đổi luôn trang của PageView 2 và 3
                  _pageController2.jumpToPage(index);
                  _pageController3.jumpToPage(index);
                },
              ),
            ),
          ),

          // 2. PageView cho tiêu đề (titlePanner)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4 + 40, // Đặt cách dưới PageView đầu tiên
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2, // Chiếm 20% chiều cao
              child: PageView.builder(
                controller: _pageController3,
                itemCount: tiltlePanner.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      tiltlePanner[index],
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'
                      ),
                    ),
                  );
                },
                onPageChanged: (index) {
                  // Khi trang của PageView 3 thay đổi, thay đổi luôn trang của PageView 1 và 2
                  _pageController2.jumpToPage(index);
                  _pageController1.jumpToPage(index);
                },
              ),
            ),
          ),

          // 3. Đoạn text miêu tả
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5, // Vị trí của đoạn văn bản
            left: 0,
            right: 0,
            child:  const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Get all your loved foods in one once place,',
                    style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'you just place the order we do the rest',
                    style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),

          // 4. PageView cho imagesLocationPanner
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5, // Đặt cách dưới text description
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3, // Chiếm 30% chiều cao
              child: PageView.builder(
                controller: _pageController2,
                itemCount: imagesLocationPanner.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      imagesLocationPanner[index],
                      height: 480, // Điều chỉnh chiều cao cho hình ảnh
                      width: 339, // Để ảnh rộng ra hết chiều ngang màn hình
                    ),
                  );
                },
                onPageChanged: (index) {
                  // Khi trang của PageView 2 thay đổi, thay đổi luôn trang của PageView 1 và 3
                  _pageController1.jumpToPage(index);
                  _pageController3.jumpToPage(index);
                },
              ),
            ),
          ),

          // 5. Container NEXT
          Positioned(
            top: MediaQuery.of(context).size.height * 0.7, // Đặt cách dưới text description
            left: (MediaQuery.of(context).size.width - 300) / 2.5,
            right: (MediaQuery.of(context).size.width - 300) / 2.5,
            child: BasicAppButton(
              onPressed: (){
              // Lấy trang hiện tại của _pageController1 và thay đổi trang của tất cả PageView
              int currentPage = _pageController1.page?.toInt() ?? 0;
              _pageController1.jumpToPage(currentPage + 1);
              _pageController2.jumpToPage(currentPage + 1);
              _pageController3.jumpToPage(currentPage + 1);
              if(currentPage==2){
                Get.to(() => const LoginView());
              }
            }, title: 'NEXT', sizeTitle: 16, colorButton: const Color(0xffFFCA28), height: 66, radius: 12,),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.78, // Vị trí của đoạn văn bản
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                onTap: (){
                  Get.to(() => const LoginView());
                },
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Skip',
                      style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Poppins', fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
