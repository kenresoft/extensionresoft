///
/// This function takes a boolean condition, a T value for the true case, and a T value for the false case.
///
/// The function returns the T value that corresponds to the condition. <br /><br />
///
/// @param condition The boolean condition. <br /><br />
/// @param trueCase The value to return if the condition is true. <br /><br />
/// @param falseCase The value to return if the condition is false. <br /><br />
///
/// @return The T value that corresponds to the condition. ///

T condition<T>(bool condition, T trueCase, T falseCase) {
  // If the condition is true, return the trueCase value.
  // Otherwise, return the falseCase value.
  return condition ? trueCase : falseCase;
}

/// This function gets the value associated with the key.
/// If the key does not exist, the value is set to the default value. <br /><br />
///
/// @param key The key to get the value for. <br /><br />
/// @param value The default value to use if the key does not exist. <br /><br />
/// @return The value associated with the key. <br /><br />

T get<T>(T key, [T? value]) {
  // If the value is null, return the key.
  if (value == null) {
    return key;
  }

  // Set the key to the value.
  key = value;

  // Return the value.
  return value;
}
