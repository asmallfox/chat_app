import 'package:flutter/cupertino.dart';

class SystemUtils {
  static hideSoftKeyBoard(BuildContext context) {
    FocusNode blankNode = FocusNode(); // 空白焦点，不赋值给任何输入框的focusNode
    FocusScope.of(context).requestFocus(blankNode);
  }
}