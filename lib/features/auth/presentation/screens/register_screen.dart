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
  bool _otpSent = false;

  @override
  void initState() {
    super.initState();
    _phone.text = widget.initialPhone ?? '';
    _otp.text = widget.initialOtpCode ?? '';
    _otpSent = (widget.initialOtpCode?.isNotEmpty ?? false);
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

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/login');
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false) || !_acceptTerms) return;
    if (_otp.text.trim().isEmpty) {
      AppFeedback.showError(
        context,
        AppLocalizations.of(context).requiredOtp,
      );
      return;
    }
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
            state.operation == AuthOperation.none &&
            state.otpChallenge == null) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/login');
          }
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
        final otpVisible = _otpSent || state.otpChallenge != null;
        return Scaffold(
          backgroundColor: const Color(0xFFF1F5F9),
          body: Stack(
            children: [
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.90),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 40,
                            spreadRadius: 0,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Back to login
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: IconButton(
                                onPressed: busy ? null : _goBack,
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                tooltip: l10n.loginTitle,
                              ),
                            ),
                            // Logo
                            Image.asset(
                              'assets/photos/png/logo.png',
                              width: 96,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            // Title
                            Text(
                              l10n.registerTitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF161C22),
                                fontFamily: 'Tajawal',
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Subtitle
                            Text(
                              l10n.registerSubtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF5A4136),
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            SizedBox(height: 24.h),
                            // Full name
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
                            SizedBox(height: 14.h),
                            // Email
                            AuthFormField(
                              label: l10n.email,
                              controller: _email,
                              hint: l10n.emailHint,
                              prefixIcon: Icons.mail_outline,
                              keyboardType: TextInputType.emailAddress,
                              textDirection: TextDirection.ltr,
                              errorText: state.fieldErrors['email'],
                            ),
                            SizedBox(height: 14.h),
                            // Password
                            AuthFormField(
                              label: l10n.registerPassword,
                              controller: _password,
                              hint: l10n.passwordHint,
                              prefixIcon: Icons.lock_outline,
                              obscureText: _obscurePassword,
                              textDirection: TextDirection.ltr,
                              errorText: state.fieldErrors['password'],
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF565E74),
                                  size: 20,
                                ),
                              ),
                              validator: (v) => v == null || v.length < 6
                                  ? l10n.shortPassword
                                  : null,
                            ),
                            SizedBox(height: 14.h),
                            // Company name (optional)
                            AuthFormField(
                              label: l10n.companyNameOptional,
                              controller: _company,
                              hint: l10n.companyNameHint,
                              prefixIcon: Icons.business_outlined,
                              errorText: state.fieldErrors['companyName'],
                            ),
                            SizedBox(height: 14.h),
                            // Phone
                            AuthFormField(
                              label: l10n.phoneNumber,
                              controller: _phone,
                              hint: l10n.phoneHint,
                              prefixIcon: Icons.phone_iphone_outlined,
                              keyboardType: TextInputType.phone,
                              textDirection: TextDirection.ltr,
                              errorText: state.fieldErrors['phone'],
                              validator: (v) =>
                                  v == null || v.trim().isEmpty
                                  ? l10n.requiredPhone
                                  : null,
                            ),
                            SizedBox(height: 12.h),
                            // Send verification code
                            SizedBox(
                              width: double.infinity,
                              height: 50.h,
                              child: OutlinedButton.icon(
                                onPressed: busy ? null : _sendOtp,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                  foregroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                icon: busy &&
                                        state.operation ==
                                            AuthOperation.sendingOtp
                                    ? SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.w,
                                          color: AppColors.primary,
                                        ),
                                      )
                                    : const Icon(Icons.sms_outlined),
                                label: Text(l10n.sendOtp),
                              ),
                            ),
                            // Verification code (appears inline after sending)
                            if (otpVisible) ...[
                              SizedBox(height: 16.h),
                              AuthFormField(
                                label: l10n.otpCode,
                                controller: _otp,
                                hint: l10n.otpHint,
                                prefixIcon: Icons.lock_clock_outlined,
                                keyboardType: TextInputType.number,
                                textDirection: TextDirection.ltr,
                                errorText: state.fieldErrors['otpCode'],
                                validator: (v) =>
                                    v == null || v.trim().isEmpty
                                    ? l10n.requiredOtp
                                    : null,
                              ),
                            ],
                            // Terms
                            CheckboxListTile(
                              value: _acceptTerms,
                              onChanged: busy
                                  ? null
                                  : (v) => setState(
                                      () => _acceptTerms = v ?? false,
                                    ),
                              title: Text(
                                l10n.acceptTerms,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Tajawal',
                                  color: Color(0xFF5A4136),
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                            SizedBox(height: 8.h),
                            // Register
                            SizedBox(
                              width: double.infinity,
                              height: 52.h,
                              child: ElevatedButton(
                                onPressed:
                                    busy || !_acceptTerms ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryContainer,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: busy
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        l10n.register,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                              ),
                            ),
                            // Back to login link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.hasAccount,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF5A4136),
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: busy ? null : _goBack,
                                  child: Text(
                                    l10n.loginNow,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
