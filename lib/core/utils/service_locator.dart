import 'package:get_it/get_it.dart';
import 'package:otlopapp/core/networking/api_consumer.dart';

final getIt = GetIt.instance;

void locateDependencies() {
  getIt.registerLazySingleton<ApiConsumer>(() => ApiConsumer());
}
