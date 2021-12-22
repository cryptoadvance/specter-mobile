import 'package:get/get.dart';

import '../../../../../utils.dart';

class PinCodeInputController extends GetxController {
  final RxList<int> _pinCode = [
    0, 0, 0, 0
  ].obs;

  int _currentInputIdx = 0;

  late List<int> _codes;

  List<int> get pinCode => _pinCode;

  List<int> get codes => _codes;

  @override
  void onInit() {
    List<int> symbols = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    _codes = Utils.shuffleSecure(symbols);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  int pinCodeLength() {
    return _pinCode.length;
  }

  List<int> getCodes() {
    return _codes;
  }

  bool addCode(int num) {
    if (_currentInputIdx >= _pinCode.length) {
      return false;
    }
    _pinCode[_currentInputIdx++] = num;
    if (_currentInputIdx >= _pinCode.length) {
      return false;
    }
    return true;
  }

  void clean() {
    for (int i = 0; i < _pinCode.length; i++) {
      _pinCode[i] = 0;
    }
    _currentInputIdx = 0;
  }

  String getValue() {
    String ret = '';
    _pinCode.forEach((code) {
      ret += code.toString();
    });
    return ret;
  }

  int getCurrentInputIndex() {
    return _currentInputIdx;
  }

  bool isFilled() {
    return _currentInputIdx >= _pinCode.length;
  }
}