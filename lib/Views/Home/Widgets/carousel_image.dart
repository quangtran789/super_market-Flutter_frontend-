import 'package:app_supermarket/utils/global.colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Đảm bảo slider chiếm toàn bộ chiều rộng
      child: CarouselSlider(
        items: GlobalVariables.carouselImages.map(
          (imageUrl) {
            return Builder(
              builder: (BuildContext context) => Container(
                width: MediaQuery.of(context)
                    .size
                    .width, // Chiều rộng toàn màn hình
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Bo góc 12px
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover, // Ảnh bao phủ theo tỷ lệ
                    height: 200, // Chiều cao ảnh 200px
                  ),
                ),
              ),
            );
          },
        ).toList(),
        options: CarouselOptions(
          height: 200, // Chiều cao slider
          viewportFraction: 1.0, // Hiển thị một ảnh toàn màn hình
          autoPlay: true, // Kích hoạt tự động xoay ảnh
          autoPlayInterval:
              const Duration(seconds: 3), // Thời gian giữa mỗi lần chuyển
          autoPlayAnimationDuration:
              const Duration(milliseconds: 800), // Hiệu ứng chuyển
          autoPlayCurve: Curves.fastOutSlowIn, // Đường cong hiệu ứng xoay
        ),
      ),
    );
  }
}
