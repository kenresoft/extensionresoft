extension ListExtension<T> on List<T> {
  List<T> plus(List<T> list, {bool sort = false}) {
    List<T> cacheList = this + list;
    if (sort) {
      cacheList.sort();
    }

    return cacheList;
  }

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
      throw ArgumentError.value(times, "times", "Unable to perform List operation: argument must be greater than 0");
    }
  }

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

  Map<int, String> get ids => _ids();
}

extension ListExtension2 on List<int> {
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