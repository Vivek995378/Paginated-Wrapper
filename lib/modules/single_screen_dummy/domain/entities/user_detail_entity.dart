import '../../../../core/pagination/models/pagination_models.dart';

class UserDetailsEntity extends PaginatedItem {
  @override
  final int id;
  final String title;
  final String body;

  UserDetailsEntity({
    required this.id,
    required this.title,
    required this.body,
  });
}
