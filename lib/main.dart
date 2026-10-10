import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/service_locator.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'core/localization/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  getIt<AuthCubit>().restoreSession();
  runApp(const HadeedGoApp());
}

class HadeedGoApp extends StatelessWidget {
  const HadeedGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => BlocProvider.value(
        value: getIt<AuthCubit>(),
        child: MaterialApp.router(
          onGenerateTitle: (context) => AppLocalizations.of(context).appName,
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.create(getIt<AuthCubit>()),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ar', 'AE'), Locale('en', 'US')],
          locale: const Locale('ar', 'AE'),
        ),
      ),
    );
  }
}
