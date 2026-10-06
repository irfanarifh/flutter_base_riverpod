class ApiResponse<T> {
  const ApiResponse({
    required this.code,
    this.message,
    this.data,
  });

  static const String successCode = '1';
  static const String errorCode = '-1';
  static const String unauthenticatedCode = '-99';

  final String code;
  final String? message;
  final T? data;

  bool get isSuccess => code == successCode;
  bool get isError => code == errorCode;
  bool get isUnauthenticated => code == unauthenticatedCode;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final rawCode = json['code']?.toString() ?? errorCode;
    final rawData = json['data'];

    return ApiResponse<T>(
      code: rawCode,
      message: json['message'] as String?,
      data: rawData != null ? fromJsonT(rawData) : null,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T? value) toJsonT) {
    return <String, dynamic>{
      'code': code,
      'message': message,
      'data': toJsonT(data),
    };
  }

  @override
  String toString() => 'ApiResponse(code: $code, message: $message, data: $data)';
}
