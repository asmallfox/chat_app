import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIO {
  static final SocketIO _instance = SocketIO.internal();

  factory SocketIO() => _instance;

  SocketIO.internal();

  static bool _isInitialized = false;
  static IO.Socket? _socket;

  static Future<SocketIO> getInstance() async {
    if (!_isInitialized) {
      await _initialize();
      _isInitialized = true;
    }

    return _instance;
  }

  static Future<void> _initialize() async {
    const String baseUrl = 'http://10.0.2.2:3000';

    _socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setPath("/socket.io")
            .setExtraHeaders({})
            .build());

    // 监听 'connect' 事件
    _socket!.onConnect((_) {
      print("已连接 socket");
    });

    _socket!.on("conn success", (data) {
      print("[接收socket信息] $data");
    });

    _socket!.on("connect_error", (data) {
      print("socket连接失败 $data");
    });

    _socket!.on('timeout', (data) {
      print("[socket 连接超时] $data");
    });
  }

}
