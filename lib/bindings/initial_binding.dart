import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../core/database/database_helper.dart';
import '../core/network/connectivity_service.dart';
import '../core/network/dio_client.dart';
import '../data/datasources/product_local_datasource.dart';
import '../data/datasources/product_remote_datasource.dart';
import '../data/repositories/product_repository_impl.dart';
import '../domain/repositories/product_repository.dart';

/// Registers app-wide singletons once, at startup. Per-screen controllers
/// are registered in their own route-level Bindings (see FeedBinding etc.)
/// so they're created/disposed alongside their screen instead of living
/// for the app's whole lifetime.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProductRemoteDataSource>(
      ProductRemoteDataSourceImpl(DioClient.instance),
      permanent: true,
    );
    Get.put<ProductLocalDataSource>(
      ProductLocalDataSourceImpl(DatabaseHelper.instance),
      permanent: true,
    );
    Get.put<ConnectivityService>(
      ConnectivityServiceImpl(Connectivity()),
      permanent: true,
    );
    Get.put<ProductRepository>(
      ProductRepositoryImpl(
        Get.find<ProductRemoteDataSource>(),
        Get.find<ProductLocalDataSource>(),
        Get.find<ConnectivityService>(),
      ),
      permanent: true,
    );
  }
}
