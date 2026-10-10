import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String? baseUrl}) = _AuthApiService;

  @POST('/api/v1/auth/otp/send')
  Future<HttpResponse<dynamic>> sendOtp(@Body() Map<String, dynamic> body);

  @POST('/api/v1/auth/register')
  Future<HttpResponse<dynamic>> register(@Body() Map<String, dynamic> body);

  @POST('/api/v1/auth/login')
  Future<HttpResponse<dynamic>> login(@Body() Map<String, dynamic> body);

  @POST('/api/v1/auth/login/otp')
  Future<HttpResponse<dynamic>> loginWithOtp(@Body() Map<String, dynamic> body);

  @POST('/api/v1/auth/refresh')
  Future<HttpResponse<dynamic>> refresh(@Body() Map<String, dynamic> body);

  @POST('/api/v1/auth/logout')
  Future<HttpResponse<dynamic>> logout(@Body() Map<String, dynamic> body);

  @GET('/api/v1/auth/me')
  Future<HttpResponse<dynamic>> me();
}
