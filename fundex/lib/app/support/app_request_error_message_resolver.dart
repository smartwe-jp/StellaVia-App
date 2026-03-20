String resolveAppRequestErrorMessage(Object error, String fallbackMessage) {
  if (error is StateError) {
    final dynamic raw = error.message;
    final String text = raw?.toString().trim() ?? '';
    if (text.isNotEmpty) {
      return text;
    }
  }
  return fallbackMessage;
}
