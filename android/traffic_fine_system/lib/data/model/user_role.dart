enum UserRole {
  officer('OFFICER'),
  user('USER');

  final String value;
  const UserRole(this.value);

  static UserRole? fromString(String? value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.user,
    );
  }
}
