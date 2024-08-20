abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

class AuthInvalidEmail extends AuthState {
  final String error;
  AuthInvalidEmail(this.error);
}

class AuthInvalidPassword extends AuthState {
  final String error;
  AuthInvalidPassword(this.error);
}

class AuthEmptyFields extends AuthState {
  final String error;
  AuthEmptyFields(this.error);
}
