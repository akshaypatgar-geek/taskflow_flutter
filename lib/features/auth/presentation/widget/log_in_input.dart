import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/core/theme/app_tokens.dart';

class LogInInput extends StatefulWidget {
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  const LogInInput({
    required this.emailController,
    required this.passwordController,
    super.key,
  });

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
          decoration: const InputDecoration(labelText: AppStrings.emailLabel),
          validator: (value) {
            if (value == null || value.trim() == '') {
              return AppStrings.emailRequired;
            }
            if (!EmailValidator.validate(value)) {
              return AppStrings.invalidEmailFormat;
            }
            return null;
          },
        ),
        const SizedBox(height: AppTokens.sXl),
        TextFormField(
          controller: widget.passwordController,
          decoration: const InputDecoration(
            labelText: AppStrings.passwordLabel,
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.trim() == '') {
              return AppStrings.passwordRequired;
            }
            if (value.length < 5) {
              return AppStrings.passwordTooShort;
            }
            return null;
          },
        ),
      ],
    );
  }
}
