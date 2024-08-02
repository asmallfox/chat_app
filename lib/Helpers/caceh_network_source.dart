import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:chat_app/Helpers/util.dart';
import 'package:path_provider/path_provider.dart';


Future<String?> downloadAndSaveFile(String url) async {
  try {
    String remoteUrl = getNetworkSourceUrl(url);

    http.Response res = await http.get(Uri.parse(remoteUrl));

    Directory appDucDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDucDir.path;

    String fileName = url.split("/").last;
    String filePath = "$appDocPath/$fileName";

    File file = File(filePath);
    await file.writeAsBytes(res.bodyBytes, flush: true);

    return filePath;
  } catch (error) {
    print('[Error] [downloadAndSaveFile] $error');
  }
}