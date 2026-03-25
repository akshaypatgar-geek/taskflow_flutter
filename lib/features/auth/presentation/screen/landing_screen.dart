import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/routes/router.dart';

import '../../../../core/widgets/app_loading_indicator.dart';
import '../bloc/auth/auth_bloc.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {



@override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
      
        if (state is AuthUnauthenticated) {
          
          context.goNamed(ScreenPaths.login.name);
        } else if(state is AuthAuthenticated) {
         
          context.goNamed(ScreenPaths.tasks.name);
        }
      },
      child: const Scaffold(
        body: AppLoadingIndicator(),
      ),
        );
  }
}