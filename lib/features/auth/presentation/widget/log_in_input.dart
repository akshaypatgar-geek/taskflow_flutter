import 'package:email_validator/email_validator.dart';
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
          validator: (value) {
            if(value == null || value.trim()=="") {
              return "Email required";
            }
            if(!EmailValidator.validate(value)) {
              return "Invalid email fromat";
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: widget.passwordController,
          decoration: InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          validator: (value) {
            if(value == null || value.trim()=="") {
              return "Password cannot be empty";
            }
            if(value.length<5) {
              return "Password too short";
            }
            return null;
          },
        ),
      ],
    );
  }
}