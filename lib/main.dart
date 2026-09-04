import 'package:auction_app/routes/app_pages.dart';
import 'package:auction_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'bindings/initial_binding.dart';

void main() {
  runApp(const AuctionApp());
}

class AuctionApp extends StatelessWidget {
  const AuctionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Live Auction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.feed,
      getPages: AppPages.pages,
    );
  }
}
