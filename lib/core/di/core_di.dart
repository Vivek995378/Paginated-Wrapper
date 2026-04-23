import '../communication/api/core_communication_manager.dart';
import '../communication/api/core_dio_singleton.dart';
import 'service_locator.dart';

class CoreDI {
  CoreDI._();

  static void register() {
    sl.registerLazySingleton<CoreDioClient>(
      () => CoreDioClient(),
    );

    sl.registerLazySingleton<CoreCommunicationManager>(
      () => CoreCommunicationManager(dioClient: sl<CoreDioClient>()),
    );
  }
}
