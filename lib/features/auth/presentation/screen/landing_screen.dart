import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth/auth_bloc.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {



@override
  void initState() {
    // clearSession();
    super.initState();
  }

  void clearSession() async {
    final storage =  FlutterSecureStorage();
    await storage.delete(key: "access_token");
    await storage.delete(key: 'refresh_token');
    
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
       
        if (state is AuthUnauthenticated) {
          
          context.go("/login");
        } else if(state is AuthAuthenticated) {
          
          context.go("/tasks");
        }
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      
    ),
        );
  }
}