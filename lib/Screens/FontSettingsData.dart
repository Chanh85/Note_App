import 'package:flutter/material.dart';

class FontSettingsData extends ChangeNotifier {
  String _selectedFont = 'Roboto';
  double _selectedFontSize = 16.0;

  String get selectedFont => _selectedFont;
  double get selectedFontSize => _selectedFontSize;
  double _fontSize = 16.0;

  double get fontSize => _fontSize;

  void setFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }

  void updateFont(String newFont) {
    _selectedFont = newFont;
    notifyListeners();
  }

  void updateFontSize(double newFontSize) {
    _selectedFontSize = newFontSize;
    notifyListeners();
  }

  void updateFontFamily(String newFontFamily) {
    _selectedFont = newFontFamily;
    notifyListeners();
  }
}
