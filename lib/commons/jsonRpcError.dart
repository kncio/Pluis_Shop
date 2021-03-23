class JsonRPCError extends Error {
  /// Message describing the JsonRPC error. */
  final Object message;

  JsonRPCError([this.message]);

  String toString() {
    if (message != null) {
      return "JsonRPC failed: ${Error.safeToString(message)}";
    }
    return "JsonRPC failed";
  }
}
