import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../utils/constants.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _controller = PageController();
  final List<String> _banners = [
    'https://www.arabnews.com/sites/default/files/styles/n_670_395/public/main-image/2024/11/23/4547877-165662866.jpg?itok=MnvPnKjb',
    'https://www.alyaum.com/uploads/images/2024/11/21/2448011.jpg',
    'https://m.media-amazon.com/images/I/71C5EvAjtBL._AC_UF894%2C1000_QL80_.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  color: AppColors.primaryLight,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  child: Image.network(
                    _banners[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hive, size: 64, color: AppColors.primary),
                          const SizedBox(height: 8),
                          Text('Asir Honey', style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SmoothPageIndicator(
          controller: _controller,
          count: _banners.length,
          effect: WormEffect(
            dotColor: AppColors.divider,
            activeDotColor: AppColors.primary,
            dotHeight: 8,
            dotWidth: 8,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
