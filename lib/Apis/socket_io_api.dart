import 'package:hive/hive.dart';

class SocketIoAPI {
  String token = Hive.box('settings').get('token');
  String baseUrl = 'http://10.0.2.2:3000';
  String apiStr = 'socket.io';

  Map<String, String> headers = {};

}
