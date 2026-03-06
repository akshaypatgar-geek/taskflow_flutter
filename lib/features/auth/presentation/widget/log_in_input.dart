import 'package:flutter/material.dart';

class LogInInput extends StatefulWidget {
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  const LogInInput({ required this.emailController, required this.passwordController, super.key});

  @override
  State<LogInInput> createState() => _LogInInputState();
}

class _LogInInputState extends State<LogInInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.emailController,
          decoration: InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: widget.passwordController,
          decoration: InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
      ],
    );
  }
}