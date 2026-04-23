import '../../../../core/pagination/models/pagination_models.dart';
import '../entities/user_detail_entity.dart';

abstract class UserDetailsRepository {
  Future<PaginationResponse<UserDetailsEntity>> fetchPage({
    required String endpoint,
    required int page,
    required int pageSize,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  });
}
