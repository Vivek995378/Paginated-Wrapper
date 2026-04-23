class UserDetailsDto {
  final int userId;
  final int id;
  final String title;
  final String body;

  const UserDetailsDto({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory UserDetailsDto.fromJson(Map<String, dynamic> json) {
    return UserDetailsDto(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
