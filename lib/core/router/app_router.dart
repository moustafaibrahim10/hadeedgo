import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../di/service_locator.dart' as di;
import '../network/auth_interceptor.dart';
import '../storage/session_storage.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/data/datasources/home_api_service.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/catalog/presentation/cubits/catalog_cubits.dart';
import '../../features/catalog/presentation/screens/catalog_screens.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/orders/presentation/screens/order_details_screen.dart';
import '../../features/orders/presentation/cubits/orders_cubit.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/cart/presentation/cubits/cart_cubit.dart';

// Profile Feature
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/addresses_screen.dart';
import '../../features/profile/presentation/screens/wallet_screen.dart';
import '../../features/profile/presentation/screens/support_screen.dart';

// Checkout Feature
import '../../features/checkout/presentation/screens/delivery_method_screen.dart';
import '../../features/checkout/presentation/screens/secure_payment_screen.dart';
import '../../features/checkout/presentation/screens/checkout_confirmation_screen.dart';
import '../../features/checkout/presentation/screens/pickup_time_screen.dart';
import '../../features/checkout/presentation/screens/delivery_location_screen.dart';
import '../../features/checkout/presentation/screens/tax_invoice_screen.dart';

// Market Feature
import '../../features/market/presentation/screens/price_alert_screen.dart';
import '../../features/market/presentation/screens/supplier_alternatives_screen.dart';

class AppRouter {
  static HomeCubit _homeCubit() {
    if (di.getIt.isRegistered<HomeCubit>()) return di.getIt<HomeCubit>();
    if (!di.getIt.isRegistered<Dio>()) {
      const baseUrl = String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://hg-stg-api.runasp.net',
      );
      final storage = di.getIt.isRegistered<SessionStorage>()
          ? di.getIt<SessionStorage>()
          : const SessionStorage();
      final dio = Dio(BaseOptions(baseUrl: baseUrl));
      final refreshDio = Dio(BaseOptions(baseUrl: baseUrl));
      dio.interceptors.add(AuthInterceptor(refreshDio, storage));
      if (!di.getIt.isRegistered<SessionStorage>()) {
        di.getIt.registerSingleton<SessionStorage>(storage);
      }
      di.getIt.registerSingleton<Dio>(dio);
    }
    if (!di.getIt.isRegistered<HomeRepository>()) {
      final homeApi = HomeApiService(di.getIt());
      di.getIt.registerSingleton<HomeRepository>(HomeRepositoryImpl(homeApi));
    }
    return HomeCubit(di.getIt<HomeRepository>());
  }

  static GoRouter create(AuthCubit authCubit) {
    final refreshNotifier = _AuthRefreshNotifier(authCubit.stream);
    return GoRouter(
      initialLocation: '/',
      refreshListenable: refreshNotifier,
      redirect: (context, state) {
        final status = authCubit.state.status;
        final isPublic =
            state.uri.path == '/' ||
            state.uri.path == '/onboarding' ||
            state.uri.path == '/login' ||
            state.uri.path == '/register' ||
            state.uri.path == '/otp';
        if (status == AuthStatus.authenticated && isPublic) return '/home';
        if (status == AuthStatus.unauthenticated && !isPublic) return '/login';
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) {
            final extra = state.extra;
            final values = extra is Map ? extra : const {};
            return RegisterScreen(
              initialPhone: values['phone']?.toString(),
              initialOtpCode: values['otpCode']?.toString(),
            );
          },
        ),
        GoRoute(
          path: '/otp',
          name: 'otp',
          builder: (context, state) => const OtpScreen(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => AppRouter._homeCubit()..loadHome()),
              BlocProvider.value(value: di.getIt<CartCubit>()..load()),
              BlocProvider.value(
                value: di.getIt<CartSummaryCubit>()..load(),
              ),
            ],
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/categories',
          name: 'categories',
          builder: (context, state) => BlocProvider(
            create: (_) => di.getIt<CategoriesCubit>()..load(),
            child: const CategoriesScreen(),
          ),
        ),
        GoRoute(
          path: '/suppliers',
          name: 'suppliers',
          builder: (context, state) => BlocProvider(
            create: (_) => di.getIt<SuppliersCubit>()..load(),
            child: const SuppliersScreen(),
          ),
        ),
        GoRoute(
          path: '/suppliers/:id',
          name: 'supplier-details',
          builder: (context, state) => BlocProvider(
            create: (_) =>
                di.getIt<SupplierDetailsCubit>()
                  ..load(state.pathParameters['id']!),
            child: SupplierDetailsScreen(id: state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/products',
          name: 'products',
          builder: (context, state) {
            final categoryId = state.uri.queryParameters['categoryId'];
            final supplierId = state.uri.queryParameters['supplierId'];
            return BlocProvider(
              create: (_) =>
                  di.getIt<ProductsCubit>()
                    ..load(categoryId: categoryId, supplierId: supplierId),
              child: ProductsScreen(
                categoryId: categoryId,
                supplierId: supplierId,
              ),
            );
          },
        ),
        GoRoute(
          path: '/products/:id',
          name: 'product-details',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    di.getIt<ProductDetailsCubit>()
                      ..load(state.pathParameters['id']!),
              ),
              BlocProvider.value(value: di.getIt<CartCubit>()),
            ],
            child: ProductDetailsScreen(id: state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/orders',
          name: 'orders',
          builder: (context, state) => BlocProvider(
            create: (_) => di.getIt<OrdersCubit>()..load(),
            child: const OrdersScreen(),
          ),
        ),
        GoRoute(
          path: '/orders/:id',
          name: 'order-details',
          builder: (context, state) => BlocProvider(
            create: (_) => di.getIt<OrderDetailsCubit>()..load(state.pathParameters['id']!),
            child: OrderDetailsScreen(id: state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/orders/:id/tracking',
          name: 'order-tracking',
          builder: (context, state) => BlocProvider(
            create: (_) => di.getIt<OrderDetailsCubit>()..load(state.pathParameters['id']!),
            child: OrderDetailsScreen(id: state.pathParameters['id']!, trackingOnly: true),
          ),
        ),
        GoRoute(
          path: '/cart',
          name: 'cart',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: di.getIt<CartCubit>()..load()),
              BlocProvider.value(
                value: di.getIt<CartSummaryCubit>()..load(),
              ),
            ],
            child: const CartScreen(),
          ),
        ),

        // --- Profile Routes ---
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/edit-profile',
          name: 'edit-profile',
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: '/addresses',
          name: 'addresses',
          builder: (context, state) => const AddressesScreen(),
        ),
        GoRoute(
          path: '/wallet',
          name: 'wallet',
          builder: (context, state) => const WalletScreen(),
        ),
        GoRoute(
          path: '/support',
          name: 'support',
          builder: (context, state) => const SupportScreen(),
        ),

        // --- Checkout Routes ---
        GoRoute(
          path: '/delivery-method',
          name: 'delivery-method',
          builder: (context, state) => const DeliveryMethodScreen(),
        ),
        GoRoute(
          path: '/secure-payment',
          name: 'secure-payment',
          builder: (context, state) => const SecurePaymentScreen(),
        ),
        GoRoute(
          path: '/checkout-confirmation',
          name: 'checkout-confirmation',
          builder: (context, state) => BlocProvider(
            create: (_) => di.getIt<CreateOrderCubit>(),
            child: const CheckoutConfirmationScreen(),
          ),
        ),
        GoRoute(
          path: '/pickup-time',
          name: 'pickup-time',
          builder: (context, state) => const PickupTimeScreen(),
        ),
        GoRoute(
          path: '/delivery-location',
          name: 'delivery-location',
          builder: (context, state) => const DeliveryLocationScreen(),
        ),
        GoRoute(
          path: '/tax-invoice',
          name: 'tax-invoice',
          builder: (context, state) => const TaxInvoiceScreen(),
        ),

        // --- Market Routes ---
        GoRoute(
          path: '/price-alert',
          name: 'price-alert',
          builder: (context, state) => const PriceAlertScreen(),
        ),
        GoRoute(
          path: '/supplier-alternatives',
          name: 'supplier-alternatives',
          builder: (context, state) => const SupplierAlternativesScreen(),
        ),
      ],
    );
  }
}

class _AuthRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;

  _AuthRefreshNotifier(Stream<AuthState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
