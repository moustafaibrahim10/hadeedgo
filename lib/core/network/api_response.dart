/// Generic API error field mapping — mirrors the backend error schema.
class ApiFieldError {
  final String field;
  final String code;
  final String message;

  const ApiFieldError({
    required this.field,
    required this.code,
    required this.message,
  });

  factory ApiFieldError.fromJson(Map<String, dynamic> json) {
    return ApiFieldError(
      field: json['field']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}

/// Generic API response wrapper — mirrors backend { success, message, data, errors[] }.
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final List<ApiFieldError> errors;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors = const [],
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromDataJson,
  ) {
    final rawErrors = json['errors'];
    final fieldErrors = <ApiFieldError>[];
    if (rawErrors is List) {
      for (final e in rawErrors) {
        if (e is Map<String, dynamic>) {
          fieldErrors.add(ApiFieldError.fromJson(e));
        }
      }
    }

    return ApiResponse<T>(
      success: json['success'] == true,
      message: json['message']?.toString(),
      data: fromDataJson != null ? fromDataJson(json['data']) : null,
      errors: fieldErrors,
    );
  }

  bool get hasFieldErrors => errors.isNotEmpty;

  /// Returns the error message for a specific field, or null if not found.
  String? errorForField(String field) {
    try {
      return errors.firstWhere((e) => e.field == field).message;
    } catch (_) {
      return null;
    }
  }
}
