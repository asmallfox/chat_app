import 'dart:math';
import 'package:chat_app/src/constants/const_data.dart';

bool isNetSource(String url) {
  return url.startsWith(r'http');
}

String getSourceUrl(String url) {
  if (url.startsWith(RegExp(r'https'))) {
    return url;
  } else if (url.startsWith(RegExp(r'http://localhost'))) {
    return url.replaceAll(RegExp(r'http://localhost'), 'http://10.0.2.2');
  } else {
    return '$serverBaseUrl/$url';
    // return 'http://192.168.31.22:3000/$url';
  }
}

String formattedDuration(int second) {
  print(second);
  int h = second ~/ 3600;
  int m = (second % 3600) ~/ 60;
  int s = second % 60;
  
  String str = '';

  if (h>0) str += "$h'";
  if (m>0) str += "$m\"";
  if (s>0) str += "$s\"";
  
  return str;
}
