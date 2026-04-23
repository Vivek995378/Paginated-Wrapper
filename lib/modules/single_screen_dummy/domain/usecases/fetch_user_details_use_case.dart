import '../../../../core/pagination/models/pagination_models.dart';
import '../entities/user_detail_entity.dart';
import '../repositories/user_details_repository_contract.dart';

class FetchUserDetailsUseCase {
  final UserDetailsRepository _repository;

  FetchUserDetailsUseCase({
    required UserDetailsRepository repository,
  }) : _repository = repository;

  Future<PaginationResponse<UserDetailsEntity>> call({
    required String endpoint,
    required int page,
    required int pageSize,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) {
    return _repository.fetchPage(
      endpoint: endpoint,
      page: page,
      pageSize: pageSize,
      queryParams: queryParams,
      headers: headers,
    );
  }
}
