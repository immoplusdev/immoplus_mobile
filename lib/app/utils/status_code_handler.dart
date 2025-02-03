class StatusCodeHandler {
  /// Determines if the provided [statusCode] represents a success.
  static bool isSuccess(int? statusCode) {
    if (statusCode == null) {
      return false; // Null status code is treated as an error.
    }
    return statusCode >= 200 && statusCode < 300;
  }

  /// Determines if the provided [statusCode] represents an error.
  static bool isError(int? statusCode) {
    return !isSuccess(statusCode);
  }
}
