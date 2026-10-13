import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadeedgo/core/error/failure_exception.dart';
import 'package:hadeedgo/core/error/failures.dart';
import 'package:hadeedgo/core/storage/session_storage.dart';
import 'package:hadeedgo/features/auth/data/datasources/auth_api_service.dart';
import 'package:hadeedgo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:retrofit/retrofit.dart' show HttpResponse;

/// Fake API service used to drive the repository's error handling paths.
class _FakeAuthApi implements AuthApiService {
  final DioException errorToThrow;

  _FakeAuthApi(this.errorToThrow);

  @override
  Future<HttpResponse<dynamic>> register(Map<String, dynamic> body) async {
    throw errorToThrow;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

DioException _badRequest(Object body) => DioException(
  requestOptions: RequestOptions(path: '/api/v1/auth/register'),
  response: Response<dynamic>(
    requestOptions: RequestOptions(path: '/api/v1/auth/register'),
    statusCode: 400,
    statusMessage: 'Bad Request',
    data: body,
  ),
  type: DioExceptionType.badResponse,
);

void main() {
  AuthRepositoryImpl buildRepo(DioException error) =>
      AuthRepositoryImpl(_FakeAuthApi(error), const SessionStorage());

  Future<Failure> captureRegisterFailure(Object body) async {
    final repo = buildRepo(_badRequest(body));
    try {
      await repo.register(
        phone: '+201001234567',
        otpCode: '1234',
        fullName: 'أحمد',
        password: 'secret',
        acceptTerms: true,
      );
      fail('expected a FailureException');
    } on FailureException catch (e) {
      return e.failure;
    }
  }

  group('auth 400 handling surfaces the real backend error', () {
    test(
      'reads the message body instead of the generic "Bad Request"',
      () async {
        final failure = await captureRegisterFailure({
          'success': false,
          'message': 'Phone already exists',
        });

        expect(failure, isA<ServerFailure>());
        expect(failure.message, 'Phone already exists');
        expect(failure.message, isNot('Bad Request'));
      },
    );

    test('maps the app contract errors[] array to field validation', () async {
      final failure = await captureRegisterFailure({
        'success': false,
        'errors': [
          {
            'field': 'phone',
            'code': 'AlreadyExists',
            'message': 'Phone already exists',
          },
        ],
      });

      expect(failure, isA<FieldValidationFailure>());
      expect(
        (failure as FieldValidationFailure).fieldErrors['phone'],
        'Phone already exists',
      );
    });

    test(
      'maps ASP.NET ValidationProblemDetails errors{} map to fields',
      () async {
        final failure = await captureRegisterFailure({
          'title': 'One or more validation errors occurred.',
          'errors': {
            'Phone': ['The phone number is invalid.'],
          },
        });

        expect(failure, isA<FieldValidationFailure>());
        expect(
          (failure as FieldValidationFailure).fieldErrors['Phone'],
          'The phone number is invalid.',
        );
      },
    );

    test(
      'falls back to the HTTP status message when body has no detail',
      () async {
        final failure = await captureRegisterFailure(<String, dynamic>{});

        expect(failure, isA<ServerFailure>());
        expect(failure.message, 'Bad Request');
      },
    );
  });
}
