import '../../../../core/pagination/models/pagination_models.dart';

class UserDetailsEntity extends PaginatedItem {
  @override
  final int id;
  final String title;

  UserDetailsEntity({
    required this.id,
    required this.title,
  });
}
