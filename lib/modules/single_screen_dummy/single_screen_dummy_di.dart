import '../../core/communication/api/core_communication_manager.dart';
import '../../core/di/service_locator.dart';
import 'data/mappers/user_details_dto_to_entity.dart';
import 'data/repo_impl/user_details_repository.dart';
import 'domain/repositories/user_details_repository_contract.dart';
import 'domain/usecases/fetch_user_details_use_case.dart';

class SingleScreenDummyDI {
  SingleScreenDummyDI._();

  static void register() {
    sl.registerLazySingleton<UserDetailsDtoToEntity>(
      () => UserDetailsDtoToEntity(),
    );

    sl.registerLazySingleton<UserDetailsRepository>(
      () => UserDetailsRepositoryImpl(
        mapper: sl<UserDetailsDtoToEntity>(),
        communicationManager: sl<CoreCommunicationManager>(),
      ),
    );

    sl.registerLazySingleton<FetchUserDetailsUseCase>(
      () => FetchUserDetailsUseCase(
        repository: sl<UserDetailsRepository>(),
      ),
    );
  }
}
