import 'package:chat_app/src/constants/const_data.dart';
import 'package:chat_app/src/socket/socket_events.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIOClient {
  // 私有构造函数
  SocketIOClient._();

  // 静态实例，懒加载单例
  static final SocketIOClient _instance = SocketIOClient._();

  // 工厂构造函数返回同一个实例
  factory SocketIOClient() => _instance;

  static IO.Socket? _socket;
  static bool _isInitialized = false;

  // 提供对外访问 Socket 实例的方法
  static IO.Socket get socket {
    if (_socket == null) {
      throw Exception('Socket 未初始化');
    }
    return _socket!;
  }

  // 获取 SocketIOClient 实例，并确保初始化
  static Future<SocketIOClient> getInstance() async {
    if (!_isInitialized) {
      await _initialize();
    }
    return _instance;
  }

  // 初始化 Socket
  static Future<void> _initialize() async {
    try {
      if (_isInitialized) return;
      await connect(); // 初始化连接
      _isInitialized = true;
    } catch (error) {
      print('Socket 初始化失败: $error');
    }
  }

  // 连接 Socket
  static Future<void> connect({Map<String, String>? headers}) async {
    try {
      String? token = AppHive.token;
      if (token == null) {
        throw Exception('用户未登录，无法建立 Socket 连接');
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
            .setTimeout(15000)
            .build(),
      );

      // 处理连接后的逻辑
      _handleConnect(_socket!);
    } catch (error) {
      print('Socket 连接失败: $error');
      rethrow; // 重新抛出异常
    }
  }

  // 处理连接成功、断开、超时等情况
  static void _handleConnect(IO.Socket socket) {
    socket.onConnect((data) {
      print("[socket] 连接成功");
      _setupAppSocketEvent();
    });

    socket.onDisconnect((_) {
      print("[socket] 断开连接");
    });

    socket.onConnectTimeout((_) {
      print("[socket] 连接超时");
    });

    socket.onConnectError((data) {
      print("[socket] 连接错误: $data");
    });
  }

  // 设置应用需要监听的 Socket 事件
  static void _setupAppSocketEvent() {
    // 这里可以根据需要添加 socket 事件处理逻辑
    // 例如： chatMessageSocket(_socket!);
    // addressBookSocket(_socket!);
    // 你可以在这里订阅不同的事件
    socketEvents(socket);
  }

  // 断开连接并清理资源
  static void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null; // 清理资源
    }
  }

  static void emitWithAck(
    String eventName,
    dynamic data, {
    Function? ack,
    bool binary = false,
  }) {
    socket.emitWithAck(eventName, data, ack: ack, binary: binary);
  }

  static void emit(String eventName, [data]) {
    socket.emit(eventName, data);
  }

  static void on(
    String eventName,
    Function(dynamic) event, [
    Function(dynamic, Function)? callback,
  ]) {
    socket.on(eventName, (data) {
      final ack = data is List ? data.last : data;
      if (ack is Function) {
        data.removeLast();
        if (callback == null) {
          ack();
        } else {
          callback(data, ack);
        }
      }
      event(data);
    });
  }

  static void off(String eventName) {
    socket.off(eventName);
  }
}
