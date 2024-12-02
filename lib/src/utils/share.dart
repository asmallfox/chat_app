import 'dart:async';
import 'dart:io';
import 'package:chat_app/src/constants/const_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

bool isNetSource(String url) {
  // 正则表达式匹配 http 或 https 或 uploads
  RegExp regExp = RegExp(r'^(https?|uploads)');
  return regExp.hasMatch(url);
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
  int h = second ~/ 3600;
  int m = (second % 3600) ~/ 60;
  int s = second % 60;

  String str = '';

  if (h > 0) str += "$h'";
  if (m > 0) str += "$m\"";
  if (s > 0) str += "$s\"";

  return str;
}

Future<File> pathTransformFile(String path, [String? suffix]) async {
  try {
    suffix ??= path.split('.').last;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath =
        '${appDocDir.path}/local-${DateTime.now().millisecondsSinceEpoch}.$suffix';
    File file = File(filePath);
    File localFile = File(path);
    // 缓存文件到本地
    await file.writeAsBytes(localFile.readAsBytesSync());

    return file;
  } catch (error) {
    throw Exception('路径转文件错误');
  }
}

Future<String?> downloadAndSaveFile(String url) async {
  try {
    String remoteUrl = getSourceUrl(url);

    http.Response res = await http.get(Uri.parse(remoteUrl));

    Directory appDucDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDucDir.path;

    String fileName = url.split("/").last;
    String filePath = "$appDocPath/$fileName";

    File file = File(filePath);
    await file.writeAsBytes(res.bodyBytes, flush: true);

    return filePath;
  } catch (error) {
    print('[Error downloadAndSaveFile] $error');
    rethrow;
  }
}
