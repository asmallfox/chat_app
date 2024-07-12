import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/constants/app_settings.dart';
import 'package:chat_app/socket/address_book_socket.dart';
import 'package:chat_app/socket/chat_message_socket.dart';
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIOClient {
  static final SocketIOClient _instance = SocketIOClient._internal();

  SocketIOClient._();

  factory SocketIOClient() => _instance;

  SocketIOClient._internal();

  static IO.Socket? _socket;
  static bool _isInitialized = false;

  static Future<SocketIOClient> getInstance() async {
    if (!_isInitialized) {
      await _initialize();
    }
    return _instance;
  }

  static Future<void> _initialize() async {
    try {
      await connect();
    } catch (error) {
      print(error);
      print('_initialize: socket初始化失败！');
    }
  }

  static Future<void> reConnect() async {
    if (_socket == null && !_isInitialized) {
      print('reConnect: socket未初始化~');
      return;
    }
    await connect();
  }

  static Future<void> removeSocket() async {
    if (_socket == null && !_isInitialized) {
      print('removeSocket: socket未初始化~');
      return;
    }
    _socket?.disconnect();
    _socket = null;
    _isInitialized = false;
  }

  static Future<void> connect({Map<String, String>? headers}) async {
    try {
      String? token = await LocalStorage.getStorageData('settings', 'token');
      if (token == null) {
        throw Exception('用户未登录，发起socket连接请求错误~');
      }

      Map<String, String> defaultHeaders = {"authorization": token};
      defaultHeaders.addAll(headers ?? {});

      _socket = IO.io(
        serverBaseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setPath("/socket.io")
            .enableForceNew()
            .setExtraHeaders(defaultHeaders)
            .build(),
      );

      _handleConnect(_socket!);
    } catch (error) {
      print('Error during socket connection: $error');
      rethrow; // 重新抛出异常以便外部处理
    }
  }

  static void _handleConnect(IO.Socket socket) {
    print('_handleConnect');
    socket.onConnect((data) {
      print("[socket] 连接成功~");
      _setupAppSocketEvent();
    });

    socket.onDisconnect((_) {
      print("[socket] 断开连接~");
    });

    socket.onConnectTimeout((data) {
      print("[socket] 连接超时~");
    });

    socket.onConnectError((data) {
      print("[socket] 连接失败~");
    });
  }

  static void _setupAppSocketEvent() {
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
}
