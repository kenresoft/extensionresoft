/// This function returns a value based on a boolean condition.
///
/// The function takes a boolean condition, a value for the true case, and a value for the false case.
/// It returns the value that corresponds to the condition.
///
/// The function returns the T value that corresponds to the condition. <br /><br />
///
/// @param condition The boolean condition. <br /><br />
/// @param trueCase The value to return if the condition is true. <br /><br />
/// @param falseCase The value to return if the condition is false. <br /><br />
///
/// @return The T value that corresponds to the condition. ///
library;

T condition<T>(bool condition, T trueCase, T falseCase) {
  // If the condition is true, return the trueCase value.
  // Otherwise, return the falseCase value.
  return condition ? trueCase : falseCase;
}

/// This function returns a value based on a boolean condition using functions.
///
/// The function takes a boolean condition, a function to be executed if the condition is true,
/// and a function to be executed if the condition is false.
/// It returns the result of the executed function. <br /><br />
///
/// @param condition The boolean condition. <br /><br />
/// @param trueCase The function to be executed if the condition is true. <br /><br />
/// @param falseCase The function to be executed if the condition is false. <br /><br />
///
/// @return The result of the executed function.
T conditionFunction<T>(bool condition, T Function() trueCase, T Function() falseCase) {
  // If the condition is true, invoke the trueCase function.
  // Otherwise, invoke the falseCase function.
  return condition ? trueCase() : falseCase();
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
