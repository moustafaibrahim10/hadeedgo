import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/localization/app_localizations.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_form_field.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.failure && state.errorMessage != null) {
          AppFeedback.showError(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.otpTitle)),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(l10n.otpSubtitle, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              AuthFormField(
                label: l10n.otpCode,
                controller: _otpController,
                hint: l10n.otpHint,
                prefixIcon: Icons.lock_clock_outlined,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.requiredOtp
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: context.watch<AuthCubit>().state.isBusy
                    ? null
                    : () {
                        final authCubit = context.read<AuthCubit>();
                        final phone = authCubit.state.otpChallenge?.phone;
                        authCubit.consumeOtpChallenge();
                        context.go(
                          '/register',
                          extra: {
                            'phone': phone,
                            'otpCode': _otpController.text.trim(),
                          },
                        );
                      },
                child: Text(l10n.continueRegistration),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
