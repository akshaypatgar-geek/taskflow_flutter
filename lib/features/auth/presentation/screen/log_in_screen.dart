

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/snackbar_helper.dart';
import '../bloc/auth/auth_bloc.dart';
import '../widget/log_in_input.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
   
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .center,
          children: [
            Text("Welcome Back!"),
            Text("Please log in to your account"),
            const SizedBox(height: 14,),
            LogInInput(emailController: emailController, passwordController: passwordController),
            const SizedBox(height: 14,),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthInitiateLogInEvent(email: emailController.text.toLowerCase().trim(), password: passwordController.text.trim()));
              }, child: 
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if(state is AuthAuthenticated) {
                    context.goNamed('tasks');
                  } else if(state is AuthLoginFailed) {
                   SnackbarHelper.showErrorMessage(context: context, message: state.errorMessage);
                  }
                },
                builder: (context, state) {
                  return state is AuthLoggingIn? CircularProgressIndicator.adaptive():Text("Log in");
                },)),
                const SizedBox(height: 14,),
                TextButton(onPressed: () {
                  
                  context.pushNamed('signUp');
                }, child: Text("Sign Up instead"))
          ],
        ),
      ),
    );
  }
}