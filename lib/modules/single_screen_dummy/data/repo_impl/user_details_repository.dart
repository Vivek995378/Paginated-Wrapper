import '../../../../core/communication/api/core_communication_manager.dart';
import '../../../../core/pagination/models/pagination_models.dart';
import '../../../../core/pagination/repositories/pagination_repository.dart';
import '../../domain/entities/user_detail_entity.dart';
import '../../domain/repositories/user_details_repository_contract.dart';
import '../dtos/user_details_dto.dart';
import '../mappers/user_details_dto_to_entity.dart';

class UserDetailsRepositoryImpl implements UserDetailsRepository {
  final UserDetailsDtoToEntity _mapper;
  final PaginationRepositoryImpl<_UserDetailsPaginatedWrapper> _delegate;

  UserDetailsRepositoryImpl({
    required UserDetailsDtoToEntity mapper,
    required CoreCommunicationManager communicationManager,
  })  : _mapper = mapper,
        _delegate = PaginationRepositoryImpl<_UserDetailsPaginatedWrapper>(
          communicationManager: communicationManager,
          itemFromJson: (json) =>
              _UserDetailsPaginatedWrapper(UserDetailsDto.fromJson(json)),
        );

  @override
  Future<PaginationResponse<UserDetailsEntity>> fetchPage({
    required String endpoint,
    required int page,
    required int pageSize,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    final response = await _delegate.fetchPage(
      endpoint: endpoint,
      page: page,
      pageSize: pageSize,
      queryParams: queryParams,
      headers: headers,
    );

    final entities =
        response.items.map((wrapper) => _mapper.map(wrapper.dto)).toList();

    return PaginationResponse<UserDetailsEntity>(
      items: entities,
      currentPage: response.currentPage,
      totalPages: response.totalPages,
      totalItems: response.totalItems,
      hasMore: response.hasMore,
    );
  }
}

class _UserDetailsPaginatedWrapper extends PaginatedItem {
  final UserDetailsDto dto;

  _UserDetailsPaginatedWrapper(this.dto);

  @override
  int get id => dto.id;
}
