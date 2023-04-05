T condition<T>(bool condition, T trueCase, T falseCase) {
  return condition ? trueCase : falseCase;
}

T get<T>(T key, [T? value]) {
  if (value == null) return key;
  key = value;
  return value;
}
