import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/auth_cubit.dart';
import 'login_screen.dart'; // Import the login screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          TextButton(
            onPressed: () async {
              await context.read<AuthCubit>().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  LoginScreen()),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for a profile picture
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
              child: Icon(
                Icons.person,
                size: 80,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await context.read<AuthCubit>().signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>  LoginScreen()),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
