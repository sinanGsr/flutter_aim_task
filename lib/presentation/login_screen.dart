import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../auth/auth_cubit.dart';
import '../auth/auth_state.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        },
        builder: (context, state) {
          String? emailError;
          String? passwordError;
          if (state is AuthEmptyFields) {
            if (state.error.toString() == 'Email and password must not be empty.') {
              emailError = 'Please enter an email';
              passwordError = 'Please enter a password';
            } else if (state.error.toString() == 'Email is required.') {
              emailError = 'Please enter an email';
            } else if (state.error.toString() == 'Password is required.') {
              passwordError = 'Please enter a password';
            }
          } else if (state is AuthInvalidEmail) {
            emailError = state.error;
          } else if (state is AuthInvalidPassword) {
            passwordError = state.error;
          }

          return SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff28263d),
                    Color(0xff302842),
                    Color(0xff1b2236),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Log In!',
                      style: TextStyle(
                          color: Color(0xffCD5B97),
                          fontSize: 41,
                          fontWeight: FontWeight.w600),
                    ),
                    _buildEmailField(context, emailError),
                    _buildPasswordField(context, passwordError),
                    const SizedBox(height: 62),
                    _buildLoginButton(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmailField(BuildContext context, String? emailError) {
    return TextField(
      controller: _emailController,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SvgPicture.asset(
            'assets/svg/email.svg',
            width: 24,
            height: 24,
          ),
        ),
        labelText: 'Email',
        prefixIconConstraints: const BoxConstraints(
          minHeight: 30,
          minWidth: 30,
        ),
        labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400),
        errorText: emailError,
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context, String? passwordError) {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        prefixIconConstraints: const BoxConstraints(
          minHeight: 30,
          minWidth: 30,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SvgPicture.asset('assets/svg/lock.svg'),
        ),
        labelText: 'Password',
        labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400),
        errorText: passwordError,
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final email = _emailController.text.trim();
          final password = _passwordController.text.trim();
          context.read<AuthCubit>().signIn(email, password);
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 10),
          child: Text(
            'Login',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }


}

