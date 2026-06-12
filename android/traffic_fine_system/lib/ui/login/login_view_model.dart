// lib/ui/login/login_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/repository/auth_repository.dart';
import '../../utils/providers.dart';
import '../../utils/network_utils.dart';

part 'login_view_model.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.success(String officerName) = _Success;
  const factory LoginState.error(String message) = _Error;
}

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository) : super(const LoginState.initial());

  Future<void> login(String username, String password) async {
    state = const LoginState.loading();
    try {
      final response = await _authRepository.login(username, password);
      state = LoginState.success(response.officerName);
    } catch (e) {
      state = LoginState.error(NetworkUtils.getErrorMessage(e));
    }
  }

  void reset() => state = const LoginState.initial();
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(ref.watch(authRepositoryProvider)),
);
