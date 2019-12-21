import 'dart:collection';

import 'package:rxdart/rxdart.dart';

class VendorStreamId {
  final _shopIds = BehaviorSubject<UnmodifiableListView<String>>();

  Stream<List<String>> get shopStream => _shopIds.stream;

  VendorStreamId(List<String> _shopStream){
    _shopIds.add(UnmodifiableListView(_shopStream));
  }
}