import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/extensions/async_value_extension.dart';
import 'package:flutter_template/core/extensions/context_extension.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/core/utils/validators.dart';
import 'package:flutter_template/features/auth/controller/login_controller.dart';
import 'package:flutter_template/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_template/shared/widgets/inputs/app_text_field.dart';
import 'package:flutter_template/shared/widgets/inputs/password_field.dart';

/// Interactive login form with validation and Riverpod submission handling.
class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(loginControllerProvider.notifier).submit(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final l10n = context.l10n;

    // Listen for errors and show themed snackbar
    ref.listen(loginControllerProvider, (_, next) {
      next.showSnackBarOnError(context);
    });

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _emailController,
            label: l10n.email,
            hintText: 'user@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: AppValidators.email,
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          const SizedBox(height: AppSpacing.md),
          PasswordField(
            controller: _passwordController,
            label: l10n.password,
            textInputAction: TextInputAction.done,
            validator: AppValidators.password,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: l10n.login,
            isLoading: loginState.isLoadingState,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
