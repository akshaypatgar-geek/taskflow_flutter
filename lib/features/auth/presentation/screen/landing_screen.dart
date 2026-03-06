import 'dart:developer';

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
    log("keys deleted");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        log("Auth State Changed: $state");
        if (state is AuthUnauthenticated) {
          log("User is unauthenticated, navigating to login screen");
          context.go("/login");
        } else if(state is AuthAuthenticated) {
          log("User is authenticated, navigating to tasks screen");
          context.go("/tasks");
        }
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      
    ),
        );
  }
}