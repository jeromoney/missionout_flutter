import 'package:flutter/foundation.dart';

class IsLoadingNotifier extends ChangeNotifier {
  bool _isLoading = false;

  set isLoading(bool isLoading) {
    if (_isLoading != isLoading) {
      _isLoading = isLoading;
      notifyListeners();
    }
  }

  bool get isLoading => _isLoading;
}
