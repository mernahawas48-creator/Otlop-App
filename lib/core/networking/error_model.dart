class ErrorModel {
  final int statusCode;
  final String message;
  final List<String> errors;

  const ErrorModel({
    required this.statusCode,
    required this.message,
    required this.errors,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    final List<String> errorsList = [];
    final dynamic rawErrors = json['errors'];

    if (rawErrors is Map) {
      rawErrors.forEach((key, value) {
        if (value is List) {
          for (final item in value) {
            errorsList.add(item.toString());
          }
        } else if (value != null) {
          errorsList.add(value.toString());
        }
      });
    } else if (rawErrors is List) {
      errorsList.addAll(rawErrors.map((item) => item.toString()));
    } else if (rawErrors is String && rawErrors.isNotEmpty) {
      errorsList.add(rawErrors);
    }

    final message = json['message']?.toString() ?? 'Something went wrong.';
    if (errorsList.isEmpty && message.isNotEmpty) {
      errorsList.add(message);
    }

    return ErrorModel(
      statusCode: json['statusCode'] is int ? json['statusCode'] as int : 0,
      message: message,
      errors: errorsList,
    );
  }
}
