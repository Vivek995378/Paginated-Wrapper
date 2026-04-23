import '../../domain/entities/user_detail_entity.dart';
import '../dtos/user_details_dto.dart';

class UserDetailsDtoToEntity {
  UserDetailsEntity map(UserDetailsDto dto) {
    return UserDetailsEntity(
      id: dto.id,
      title: dto.title,
    );
  }
}
