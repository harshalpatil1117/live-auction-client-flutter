import 'package:get/get.dart';

import '../bindings/detail_binding.dart';
import '../bindings/feed_binding.dart';
import '../bindings/search_binding.dart';
import '../views/detail_screen.dart';
import '../views/feed_screen.dart';
import '../views/search_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.feed,
      page: () => const FeedScreen(),
      binding: FeedBinding(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => const DetailScreen(),
      binding: DetailBinding(),
    ),
  ];
}
