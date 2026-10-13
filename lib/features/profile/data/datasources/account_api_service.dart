import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'account_api_service.g.dart';

@RestApi()
abstract class AccountApiService {
  factory AccountApiService(Dio dio, {String? baseUrl}) = _AccountApiService;

  /// ملخص صفحة حسابي
  @GET('/api/v1/account')
  Future<HttpResponse<dynamic>> getAccountSummary();

  /// الملف الشخصي
  @GET('/api/v1/account/profile')
  Future<HttpResponse<dynamic>> getProfile();

  /// تعديل الملف الشخصي
  @PUT('/api/v1/account/profile')
  Future<HttpResponse<dynamic>> updateProfile(
    @Body() Map<String, dynamic> body,
  );

  /// العناوين المحفوظة
  @GET('/api/v1/account/addresses')
  Future<HttpResponse<dynamic>> getAddresses();

  /// إضافة عنوان
  @POST('/api/v1/account/addresses')
  Future<HttpResponse<dynamic>> createAddress(
    @Body() Map<String, dynamic> body,
  );

  /// تعديل عنوان
  @PUT('/api/v1/account/addresses/{addressId}')
  Future<HttpResponse<dynamic>> updateAddress(
    @Path('addressId') String addressId,
    @Body() Map<String, dynamic> body,
  );

  /// حذف عنوان
  @DELETE('/api/v1/account/addresses/{addressId}')
  Future<HttpResponse<dynamic>> deleteAddress(
    @Path('addressId') String addressId,
  );

  /// الفواتير الضريبية
  @GET('/api/v1/account/invoices')
  Future<HttpResponse<dynamic>> getInvoices({
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  });

  /// تفاصيل فاتورة ضريبية
  @GET('/api/v1/account/invoices/{orderId}')
  Future<HttpResponse<dynamic>> getInvoiceDetails(
    @Path('orderId') String orderId,
  );

  /// الدعم الفني
  @GET('/api/v1/account/support')
  Future<HttpResponse<dynamic>> getSupport();
}
