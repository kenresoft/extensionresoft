import 'package:flutter/foundation.dart';

class ValidationKey {
  final ValueNotifier<String> _notifier;

  ValidationKey() : _notifier = ValueNotifier('');

  String get value => _notifier.value;

  set value(String newValue) => _notifier.value = newValue;

  void addListener(VoidCallback listener) => _notifier.addListener(listener);

  void removeListener(VoidCallback listener) => _notifier.removeListener(listener);

  void dispose() => _notifier.dispose();
}
