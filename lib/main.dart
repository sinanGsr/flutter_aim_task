import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aim_task/presentation/login_screen.dart';
import 'package:flutter_aim_task/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth/auth_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Make sure Firebase is initialized before accessing Firebase services
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final AuthRepository authRepository = AuthRepository();

  runApp(
    BlocProvider(
      create: (context) => AuthCubit(authRepository: authRepository),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
