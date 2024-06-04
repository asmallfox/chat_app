import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIO {
  static final SocketIO _instance = SocketIO.internal();

  factory SocketIO() => _instance;

  SocketIO.internal();

  static bool _isInitialized = false;
  static IO.Socket? _socket;
  static const String baseUrl = 'http://10.0.2.2:3000';

  static Future<SocketIO> getInstance() async {
    if (!_isInitialized) {
      await _initialize();
      _isInitialized = true;
    }

    return _instance;
  }

  static Future<void> _initialize() async {
    await _connect({});

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

  static void emit(String eventName, [data]) {
    _socket!.emit(eventName, data);
  }

  static void on(String eventName, callback) {
    _socket!.on(eventName, ([data]) {
      final dataList = data as List;
      final ack = dataList.last as Function;
      ack(null);
      if (callback != null) {
        callback(data);
      }
    });
  }

  static Future<void> updateHeaders(Map<String, String> headers) async {
    if (_socket != null) {
      _connect(headers);
    }
  }

  static Future<void> reConnect(Map<String, String>? headers) async {
    if (_socket != null) {
      _connect(headers);
    }
  }

  static Future<void> _connect(Map<String, String>? headers) async {
    String token = await Hive.box('settings').get('token', defaultValue: "");

    Map<String, String> defaultHeaders = {"authorization": token};

    defaultHeaders.addAll(headers ?? {});

    _socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setPath("/socket.io")
            .setExtraHeaders(headers ?? {})
            .build());
  }
}
