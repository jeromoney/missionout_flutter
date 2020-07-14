import 'package:flutter/material.dart';

class ResponseSheetController extends ChangeNotifier {
  bool get showResponseSheet => _showResponseSheet;
  bool _showResponseSheet = false;

  set showResponseSheet(bool showSheet) {
    _showResponseSheet = showSheet;
    notifyListeners();
  }
}
