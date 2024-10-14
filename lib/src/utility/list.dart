// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

extension ListExtension<T> on List<T> {
  /// Combines the current list with another list and optionally sorts the result.
  ///
  /// This extension concatenates the current list with another list and optionally sorts the result.
  ///
  /// Parameters:
  ///   - list: The list to concatenate with the current list.
  ///   - sort: Whether to sort the resulting list. Defaults to false.
  ///
  /// Returns:
  ///   A new list containing elements from both lists, optionally sorted.
  ///
  /// Example:
  /// ```dart
  /// final combinedList = [1, 2, 3].plus([4, 5, 6], sort: true);
  /// ```
  List<T> plus(List<T> list, {bool sort = false}) {
    List<T> cacheList = this + list;
    if (sort) {
      cacheList.sort();
    }

    return cacheList;
  }

  /// Creates a new list by repeating the elements of the current list a specified number of times.
  ///
  /// This extension creates a new list by repeating the elements of the current list a specified number of times.
  ///
  /// Parameters:
  ///   - times: The number of times to repeat the elements of the current list. Must be greater than 0.
  ///   - sort: Whether to sort the resulting list. Defaults to false.
  ///
  /// Returns:
  ///   A new list containing elements repeated as specified, optionally sorted.
  ///
  /// Throws:
  ///   ArgumentError: If `times` is less than or equal to 0.
  ///
  /// Example:
  /// ```dart
  /// final repeatedList = [1, 2, 3].multiply(times: 3, sort: true);
  /// ```
  List<T> multiply({required int times, bool sort = false}) {
    assert(times > -1);
    if (times > 0) {
      List<T> newList = [];
      for (var i = 1; i < times + 1; ++i) {
        newList.addAll(this);
      }
      if (sort) {
        newList.sort();
      }
      return newList;
    } else {
      throw ArgumentError.value(times, "times",
          "Unable to perform List operation: argument must be greater than 0");
    }
  }

  /// Private method to extract unique starting characters and their indices from a list of strings.
  ///
  /// Returns a map where the key is the index of the unique starting character in the list, and the value is the character itself.
  ///
  /// This method is used internally to implement the 'ids' property.
  ///
  /// Returns:
  ///   A map containing unique starting characters and their indices.
  ///
  /// Example:
  /// ```dart
  /// final idsMap = ['apple', 'banana', 'cherry'].ids;
  /// ```
  Map<int, String> _ids() {
    List<int> ind = [];
    Map<int, String> mp = {};
    var alp = 'a';
    if (this is List<String>) {
      for (var i = 0; i < length; ++i) {
        var o = this[i].toString().toUpperCase();
        if (o[0] != alp) {
          ind.add(i);
          alp = o[0];
          mp.update(i, (value) => value, ifAbsent: () => alp);
        }
      }
      return mp;
    } else {
      return mp;
    }
  }

  /// Property to extract unique starting characters and their indices from a list of strings.
  ///
  /// Returns a map where the key is the index of the unique starting character in the list, and the value is the character itself.
  ///
  /// Example:
  /// ```dart
  /// final idsMap = ['apple', 'banana', 'cherry'].ids;
  /// ```
  Map<int, String> get ids => _ids();
}

extension ListExtension2 on List<int> {
  /// Converts a list of integers into a map where the keys are the indices of the list elements.
  ///
  /// This extension converts a list of integers into a map where the keys are the indices of the list elements.
  ///
  /// Returns:
  ///   A map where the keys are the indices of the list elements and the values are the elements themselves.
  ///
  /// Example:
  /// ```dart
  /// final intList = [10, 20, 30];
  /// final map = intList.mapFromList();
  /// ```
  Map<int, int> mapFromList() {
    Map<int, int> mp = {};
    int num = 0;
    for (var i = 0; i < length; ++i) {
      var o = this[i];
      mp.update(num, (value) => value, ifAbsent: () => o);
      num++;
    }

    return mp;
  }
}
