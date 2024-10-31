import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  static Future<bool> microphone() async {
    PermissionStatus status = await Permission.microphone.status;
    print('已授权 ${status.isGranted}');
    // 如果未授权，请求麦克风录音权限
    if (!status.isGranted) {
      if (await Permission.microphone.request().isGranted) {
        return true;
      } else {
        print('PermissionsHelper.microphone 麦克风授权失败');
        throw Exception('PermissionsHelper.microphone 麦克风授权失败');
      }
    }
    return true;
  }
}
