import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_form_field.dart';

class RegisterScreen extends StatefulWidget {
  final String? initialPhone;
  final String? initialOtpCode;

  const RegisterScreen({this.initialPhone, this.initialOtpCode, super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _company = TextEditingController();
  final _password = TextEditingController();
  bool _obscurePassword = true;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _phone.text = widget.initialPhone ?? '';
    _otp.text = widget.initialOtpCode ?? '';
  }

  @override
  void dispose() {
    _phone.dispose();
    _otp.dispose();
    _name.dispose();
    _email.dispose();
    _company.dispose();
    _password.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_phone.text.trim().isEmpty) {
      _formKey.currentState?.validate();
      return;
    }
    context.read<AuthCubit>().sendOtp(
      phone: _phone.text.trim(),
      purpose: 'Register',
      channel: 'Sms',
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false) || !_acceptTerms) return;
    context.read<AuthCubit>().register(
      phone: _phone.text.trim(),
      otpCode: _otp.text.trim(),
      fullName: _name.text.trim(),
      password: _password.text,
      acceptTerms: _acceptTerms,
      email: _email.text.trim().isEmpty ? null : _email.text.trim(),
      companyName: _company.text.trim().isEmpty ? null : _company.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) context.go('/home');
        if (state.status == AuthStatus.unauthenticated &&
            state.operation == AuthOperation.none) {
          context.go('/login');
        }
        if (state.status == AuthStatus.failure && state.errorMessage != null) {
          AppFeedback.showError(context, state.errorMessage!);
        }
        if (state.otpChallenge != null &&
            state.operation == AuthOperation.none) {
          AppFeedback.showInfo(context, l10n.otpSent);
        }
      },
      builder: (context, state) {
        final busy = state.isBusy;
        return Scaffold(
          backgroundColor: const Color(0xFFF1F5F9),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  SizedBox(height: 18.h),
                  Image.asset('assets/photos/png/logo.png', height: 80.h),
                  SizedBox(height: 12.h),
                  Text(
                    l10n.registerTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  AuthFormField(
                    label: l10n.phoneNumber,
                    controller: _phone,
                    hint: l10n.phoneHint,
                    prefixIcon: Icons.phone_iphone_outlined,
                    keyboardType: TextInputType.phone,
                    textDirection: TextDirection.ltr,
                    errorText: state.fieldErrors['phone'],
                    validator: (v) => v == null || v.trim().isEmpty
                        ? l10n.requiredPhone
                        : null,
                  ),
                  SizedBox(height: 12.h),
                  OutlinedButton.icon(
                    onPressed: busy ? null : _sendOtp,
                    icon: const Icon(Icons.sms_outlined),
                    label: Text(l10n.sendOtp),
                  ),
                  SizedBox(height: 12.h),
                  AuthFormField(
                    label: l10n.otpCode,
                    controller: _otp,
                    hint: l10n.otpHint,
                    prefixIcon: Icons.lock_clock_outlined,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    errorText: state.fieldErrors['otpCode'],
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? l10n.requiredOtp : null,
                  ),
                  SizedBox(height: 12.h),
                  AuthFormField(
                    label: l10n.fullName,
                    controller: _name,
                    hint: l10n.fullNameHint,
                    prefixIcon: Icons.person_outline,
                    errorText: state.fieldErrors['fullName'],
                    validator: (v) => v == null || v.trim().isEmpty
                        ? l10n.requiredFullName
                        : null,
                  ),
                  SizedBox(height: 12.h),
                  AuthFormField(
                    label: l10n.email,
                    controller: _email,
                    hint: l10n.emailHint,
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    errorText: state.fieldErrors['email'],
                  ),
                  SizedBox(height: 12.h),
                  AuthFormField(
                    label: l10n.companyNameOptional,
                    controller: _company,
                    hint: l10n.companyNameHint,
                    prefixIcon: Icons.business_outlined,
                    errorText: state.fieldErrors['companyName'],
                  ),
                  SizedBox(height: 12.h),
                  AuthFormField(
                    label: l10n.registerPassword,
                    controller: _password,
                    hint: l10n.passwordHint,
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    textDirection: TextDirection.ltr,
                    errorText: state.fieldErrors['password'],
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.length < 6 ? l10n.shortPassword : null,
                  ),
                  CheckboxListTile(
                    value: _acceptTerms,
                    onChanged: busy
                        ? null
                        : (v) => setState(() => _acceptTerms = v ?? false),
                    title: Text(l10n.acceptTerms),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: busy || !_acceptTerms ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                      ),
                      child: busy
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(l10n.register),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(l10n.loginNow),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
