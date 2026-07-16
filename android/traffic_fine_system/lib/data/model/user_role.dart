enum UserRole {
  admin('ADMIN'),
  officer('OFFICER'),
  user('USER');

  final String value;
  const UserRole(this.value);

  static UserRole? fromString(String? value) {
    if (value == null) return null;
    final upperValue = value.toUpperCase();
    return UserRole.values.firstWhere(
      (role) => role.value == upperValue,
      orElse: () => UserRole.user,
    );
  }
}
