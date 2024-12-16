import 'package:chat_app/constants/app_settings.dart';

dynamic listFind(List list, bool Function(dynamic) fn) {
  if (list.isEmpty) return null;

  return list.firstWhere(
    fn,
    orElse: () => null,
  );
}

String getNetworkSourceUrl(String url) {
  if (url.startsWith(RegExp(r'https'))) {
    return url;
  } else if (url.startsWith(RegExp(r'http://localhost'))) {
    return url.replaceAll(RegExp(r'http://localhost'), 'http://10.0.2.2');
  } else if (url.startsWith(RegExp(r'uploads/'))) {
    return '$serverBaseUrl/$url';
  } else {
    return url;
  }
  // return 'http://192.168.31.22:3000/$url';
}
