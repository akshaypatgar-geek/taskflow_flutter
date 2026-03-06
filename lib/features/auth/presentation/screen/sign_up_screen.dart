import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/utils/snackbar_helper.dart';
import 'package:taskflowapp/features/auth/presentation/bloc/auth/auth_bloc.dart';

import '../widget/log_in_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Create account"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .center,
          children: [
            Text("Enter your email and password to set up"),
            const SizedBox(height: 14,),
            LogInInput(emailController:  emailController,passwordController: passwordController),
            const SizedBox(height: 14,),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(InitiateSignUpEvent(email: emailController.text.toLowerCase().trim(), password: passwordController.text.trim()));
              },
              child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if(state is SignUpFailed) {
                  SnackbarHelper.showErrorMessage(context: context, message: state.errorMessage);
                }
                else if(state is SignUpSuccess) {
                  context.goNamed('logIn');
                }
              },
              
              builder: (context, state) {
                return state is AuthLoggingIn? CircularProgressIndicator():Text("Sign up");
              },
            ),)
            
          ],
        ),
      ),
    );
  }
}