import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial());

  Future<void> signIn(String email, String password) async {
    if (email.isEmpty && password.isEmpty) {
      emit(AuthEmptyFields('Email and password must not be empty.'));
      return;
    }

    if (email.isEmpty) {
      emit(AuthEmptyFields('Email is required.'));
      return;
    }

    if (password.isEmpty) {
      emit(AuthEmptyFields('Password is required.'));
      return;
    }

    if (!_isValidEmail(email)) {
      emit(AuthInvalidEmail('Invalid email format.'));
      return;
    }

    if (!_isValidPassword(password)) {
      emit(AuthInvalidPassword('Password must be at least 6 characters.'));
      return;
    }

    emit(AuthLoading());
    try {
      await _authRepository.signIn(email, password);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.code}');
      if (e.code == 'invalid-credential') {
        emit(AuthInvalidEmail('Invalid credentials.'));
      } else if (e.code == 'wrong-password') {
        emit(AuthInvalidPassword('Incorrect password.'));
      } else if (e.code == 'user-not-found') {
        emit(AuthInvalidEmail('No user found with this email.'));
      } else {
        emit(AuthFailure('Authentication failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthFailure('An unexpected error occurred. Please try again.'));
    }
  }

  Future<void> signUp(String email, String password) async {
    if (email.isEmpty && password.isEmpty) {
      emit(AuthEmptyFields('Email and password must not be empty.'));
      return;
    }

    if (email.isEmpty) {
      emit(AuthEmptyFields('Email is required.'));
      return;
    }

    if (password.isEmpty) {
      emit(AuthEmptyFields('Password is required.'));
      return;
    }

    if (!_isValidEmail(email)) {
      emit(AuthInvalidEmail('Invalid email format.'));
      return;
    }

    if (!_isValidPassword(password)) {
      emit(AuthInvalidPassword('Password must be at least 6 characters.'));
      return;
    }

    emit(AuthLoading());
    try {
      await _authRepository.signUp(email, password);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(AuthInvalidEmail('The email is already in use.'));
      } else {
        emit(AuthFailure('Sign up failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthFailure('An unexpected error occurred. Please try again.'));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthInitial()); // Navigate to the initial state after sign out
    } catch (e) {
      emit(AuthFailure('Sign out failed. Please try again.'));
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }
}
