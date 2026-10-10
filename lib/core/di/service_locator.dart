import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_api_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/home/data/datasources/home_api_service.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/catalog/data/datasources/catalog_api_service.dart';
import '../../features/catalog/data/repositories/catalog_repository_impl.dart';
import '../../features/catalog/domain/repositories/catalog_repository.dart';
import '../../features/catalog/domain/usecases/catalog_usecases.dart';
import '../../features/catalog/presentation/cubits/catalog_cubits.dart';
import '../../features/cart/data/datasources/cart_api_service.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/cart_usecases.dart';
import '../../features/cart/presentation/cubits/cart_cubit.dart';
import '../../features/orders/data/datasources/orders_api_service.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/orders_usecases.dart';
import '../../features/orders/presentation/cubits/orders_cubit.dart';
import '../network/auth_interceptor.dart';
import '../storage/session_storage.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (getIt.isRegistered<AuthCubit>()) {
    if (!getIt.isRegistered<HomeCubit>()) {
      final homeApi = HomeApiService(getIt<Dio>());
      if (!getIt.isRegistered<HomeRepository>()) {
        getIt.registerSingleton<HomeRepository>(HomeRepositoryImpl(homeApi));
      }
      getIt.registerFactory(() => HomeCubit(getIt<HomeRepository>()));
    }
    _registerCatalog();
    _registerCart();
    _registerOrders();
    return;
  }

  const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://hg-stg-api.runasp.net',
  );
  final storage = SessionStorage();
  final dio = Dio(BaseOptions(baseUrl: baseUrl));
  final refreshDio = Dio(BaseOptions(baseUrl: baseUrl));
  dio.interceptors.add(AuthInterceptor(refreshDio, storage));

  final api = AuthApiService(dio);
  final repository = AuthRepositoryImpl(api, storage);
  final homeApi = HomeApiService(dio);
  final homeRepository = HomeRepositoryImpl(homeApi);
  final catalogApi = CatalogApiService(dio);
  final catalogRepository = CatalogRepositoryImpl(catalogApi);
  final cartApi = CartApiService(dio);
  final cartRepository = CartRepositoryImpl(cartApi);
  final ordersApi = OrdersApiService(dio);
  final ordersRepository = OrdersRepositoryImpl(ordersApi);

  getIt
    ..registerSingleton<SessionStorage>(storage)
    ..registerSingleton<Dio>(dio)
    ..registerSingleton<AuthRepository>(repository)
    ..registerSingleton<HomeRepository>(homeRepository)
    ..registerSingleton<CatalogRepository>(catalogRepository)
    ..registerSingleton<CartRepository>(cartRepository)
    ..registerSingleton<OrdersRepository>(ordersRepository)
    ..registerFactory(() => HomeCubit(getIt()))
    ..registerFactory(() => SendOtpUseCase(getIt()))
    ..registerFactory(() => RegisterUseCase(getIt()))
    ..registerFactory(() => LoginUseCase(getIt()))
    ..registerFactory(() => LoginWithOtpUseCase(getIt()))
    ..registerFactory(() => CurrentUserUseCase(getIt()))
    ..registerFactory(() => LogoutUseCase(getIt()))
    ..registerFactory(() => ClearLocalSessionUseCase(getIt()))
    ..registerFactory(() => GetCategories(getIt()))
    ..registerFactory(() => GetSuppliers(getIt()))
    ..registerFactory(() => GetSupplierDetails(getIt()))
    ..registerFactory(() => GetFeaturedOffers(getIt()))
    ..registerFactory(() => GetProducts(getIt()))
    ..registerFactory(() => GetProductDetails(getIt()))
    ..registerFactory(() => CategoriesCubit(getIt()))
    ..registerFactory(() => SuppliersCubit(getIt()))
    ..registerFactory(() => FeaturedOffersCubit(getIt()))
    ..registerFactory(() => ProductsCubit(getIt()))
    ..registerFactory(() => SupplierDetailsCubit(getIt()))
    ..registerFactory(() => ProductDetailsCubit(getIt()))
    ..registerFactory(() => GetCart(getIt()))
    ..registerFactory(() => GetCartSummary(getIt()))
    ..registerFactory(() => AddCartItem(getIt()))
    ..registerFactory(() => UpdateCartItem(getIt()))
    ..registerFactory(() => RemoveCartItem(getIt()))
    ..registerFactory(() => ClearCart(getIt()))
    ..registerFactory(() => MergeCartItem(getIt()))
    ..registerFactory(() => CreateOrder(getIt()))
    ..registerFactory(() => GetOrders(getIt()))
    ..registerFactory(() => GetOrder(getIt()))
    ..registerFactory(() => GetOrderTracking(getIt()))
    ..registerFactory(() => OrdersCubit(getIt()))
    ..registerFactory(() => OrderDetailsCubit(getIt(), getIt()))
    ..registerFactory(() => CreateOrderCubit(getIt()))
    ..registerLazySingleton(
      () => CartCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt()),
    )
    ..registerLazySingleton(() => CartSummaryCubit(getIt()))
    ..registerSingleton<AuthCubit>(
      AuthCubit(
        sendOtp: getIt(),
        register: getIt(),
        login: getIt(),
        loginWithOtp: getIt(),
        currentUser: getIt(),
        logout: getIt(),
        clearLocalSession: getIt(),
      ),
    );
}

void _registerOrders() {
  if (!getIt.isRegistered<OrdersRepository>()) {
    getIt.registerSingleton<OrdersRepository>(
      OrdersRepositoryImpl(OrdersApiService(getIt<Dio>())),
    );
  }
  if (!getIt.isRegistered<CreateOrder>()) {
    getIt.registerFactory(() => CreateOrder(getIt()));
  }
  if (!getIt.isRegistered<GetOrders>()) {
    getIt.registerFactory(() => GetOrders(getIt()));
  }
  if (!getIt.isRegistered<GetOrder>()) {
    getIt.registerFactory(() => GetOrder(getIt()));
  }
  if (!getIt.isRegistered<GetOrderTracking>()) {
    getIt.registerFactory(() => GetOrderTracking(getIt()));
  }
  if (!getIt.isRegistered<OrdersCubit>()) {
    getIt.registerFactory(() => OrdersCubit(getIt()));
  }
  if (!getIt.isRegistered<OrderDetailsCubit>()) {
    getIt.registerFactory(() => OrderDetailsCubit(getIt(), getIt()));
  }
  if (!getIt.isRegistered<CreateOrderCubit>()) {
    getIt.registerFactory(() => CreateOrderCubit(getIt()));
  }
}

void _registerCatalog() {
  if (getIt.isRegistered<CatalogRepository>()) return;
  final repository = CatalogRepositoryImpl(CatalogApiService(getIt<Dio>()));
  getIt
    ..registerSingleton<CatalogRepository>(repository)
    ..registerFactory(() => GetCategories(getIt()))
    ..registerFactory(() => GetSuppliers(getIt()))
    ..registerFactory(() => GetSupplierDetails(getIt()))
    ..registerFactory(() => GetFeaturedOffers(getIt()))
    ..registerFactory(() => GetProducts(getIt()))
    ..registerFactory(() => GetProductDetails(getIt()))
    ..registerFactory(() => CategoriesCubit(getIt()))
    ..registerFactory(() => SuppliersCubit(getIt()))
    ..registerFactory(() => FeaturedOffersCubit(getIt()))
    ..registerFactory(() => ProductsCubit(getIt()))
    ..registerFactory(() => SupplierDetailsCubit(getIt()))
    ..registerFactory(() => ProductDetailsCubit(getIt()));
}

void _registerCart() {
  if (getIt.isRegistered<CartRepository>()) return;
  getIt.registerSingleton<CartRepository>(
    CartRepositoryImpl(CartApiService(getIt<Dio>())),
  );
  getIt
    ..registerFactory(() => GetCart(getIt()))
    ..registerFactory(() => GetCartSummary(getIt()))
    ..registerFactory(() => AddCartItem(getIt()))
    ..registerFactory(() => UpdateCartItem(getIt()))
    ..registerFactory(() => RemoveCartItem(getIt()))
    ..registerFactory(() => ClearCart(getIt()))
    ..registerFactory(() => MergeCartItem(getIt()))
    ..registerLazySingleton(
      () => CartCubit(getIt(), getIt(), getIt(), getIt(), getIt(), getIt()),
    )
    ..registerLazySingleton(() => CartSummaryCubit(getIt()));
}
