import 'package:get_it/get_it.dart';

import '../helper/router/routing_helper.dart';
import 'cloud_storage_service.dart';
import 'database_service.dart';
import 'media_service.dart';

final getIt = GetIt.instance;

void registerServices()  {
  getIt.registerSingleton<RoutingHelper>(RoutingHelper());
  getIt.registerSingleton<MediaService>(MediaService());
  getIt.registerSingleton<CloudStorageService>(CloudStorageService());
  getIt.registerSingleton<DatabaseService>(DatabaseService());

}
