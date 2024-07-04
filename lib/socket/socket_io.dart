import 'package:chat_app/socket/address_book_socket.dart';
import 'package:chat_app/socket/chat_message_socket.dart';
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIOClient {
  static final SocketIOClient _instance = SocketIOClient._internal();
  static const String baseUrl = 'http://192.168.31.22:3000';
  // static const String baseUrl = 'http://10.0.2.2:3000';

  factory SocketIOClient() => _instance;

  SocketIOClient._internal();

  static IO.Socket? _socket;
  static bool _isInitialized = false;

  static Future<SocketIOClient> getInstance() async {
    if (!_isInitialized) {
      await _initialize();
      _isInitialized = true;
    }
    return _instance;
  }

  static Future<void> _initialize() async {
    await _connect();

    _socket!.onConnect((_) {
      print("已连接 socket");
      // 在连接成功后处理业务逻辑
      _setupSocketListeners();
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

  static void _setupSocketListeners() {
    chatMessageSocket(_socket!);
    addressBookSocket(_socket!);
    // 添加其他需要监听的事件
  }

  static IO.Socket? getSocketInstance() {
    return _socket;
  }

  static void emitWithAck(
    String eventName,
    dynamic data, {
    Function? ack,
    bool binary = false,
  }) {
    _socket!.emitWithAck(eventName, data, ack: ack, binary: binary);
  }

  static void emit(String eventName, [data]) {
    _socket!.emit(eventName, data);
  }

  static void on(String eventName, Function(dynamic) callback) {
    _socket!.on(eventName, (data) {
      callback(data);
    });
  }

  static void off(String eventName) {
    _socket!.off(eventName);
  }

  static Future<void> updateHeaders(Map<String, String> headers) async {
    if (_socket != null) {
      await _connect(headers);
    }
  }

  static Future<void> reConnect(Map<String, String>? headers) async {
    if (_socket != null) {
      await _connect(headers);
    }
  }

  static Future<void> _connect([Map<String, String>? headers]) async {
    String token = await Hive.box('settings').get('token', defaultValue: "");
    Map<String, String> defaultHeaders = {"authorization": token};
    defaultHeaders.addAll(headers ?? {});

    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setPath("/socket.io")
          .disableAutoConnect()
          .setExtraHeaders(defaultHeaders)
          .build(),
    );

    _socket!.connect();
  }
}
