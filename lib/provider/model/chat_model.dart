import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Helpers/util.dart';
import 'package:chat_app/socket/socket_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hive/hive.dart';

class ChatMessage {
  final int? id;
  final int type;
  final String message;
  final int to;
  final int from;
  final int? is_read;
  final int? created_at;
  final int? updated_at;

  ChatMessage({
    this.id,
    required this.type,
    required this.message,
    required this.to,
    required this.from,
    this.is_read,
    this.created_at,
    this.updated_at,
  });

  factory ChatMessage.fromMap(Map<dynamic, dynamic> item) {
    return ChatMessage(
      id: item['id'],
      type: item['type'],
      message: item['message'],
      to: item['to'],
      from: item['from'],
      is_read: item['is_read'],
      created_at: item['created_at'],
      updated_at: item['updated_at'],
    );
  }
}

class ChatModelType {
  final int id;
  final int user1_id;
  final int user2_id;
  final int promoter_id;
  final int status;
  final int last_operator;
  final int updated_at;
  final int created_at;
  final int friendId;
  final String avatar;
  final String username;
  final bool isDelete;
  final int newMessageCount;
  final List<dynamic>? messages;

  ChatModelType({
    required this.id,
    required this.user1_id,
    required this.user2_id,
    required this.promoter_id,
    required this.status,
    required this.last_operator,
    required this.updated_at,
    required this.created_at,
    required this.friendId,
    required this.avatar,
    required this.username,
    required this.isDelete,
    required this.newMessageCount,
    this.messages,
  });

  factory ChatModelType.fromMap(Map<dynamic, dynamic> item) {
    return ChatModelType(
      id: item['id'],
      user1_id: item['user1_id'],
      user2_id: item['user2_id'],
      promoter_id: item['promoter_id'],
      status: item['status'],
      last_operator: item['last_operator'],
      updated_at: item['updated_at'],
      created_at: item['created_at'],
      friendId: item['friendId'],
      avatar: item['avatar'],
      username: item['username'],
      isDelete: item['isDelete'],
      newMessageCount: item['newMessageCount'],
      messages: item['messages'],
    );
  }
}

class ChatModelProvider extends ChangeNotifier {
  static final ChatModelProvider _instance = ChatModelProvider._internal();

  ChatModelProvider._internal();

  factory ChatModelProvider() => _instance;

  Map<dynamic, dynamic>? _chat;
  Map<dynamic, dynamic>? _communicate;
  bool _isCommunicate = false;

  Map<dynamic, dynamic>? get chat => _chat;
  Map? get communicate => _communicate;
  bool get isCommunicate => _isCommunicate;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  void setChat(Map<dynamic, dynamic> chat) {
    _chat = chat;
    notifyListeners();
  }

  void setCommunicate(Map<dynamic, dynamic> communicate) {
    if (_communicate == null) {
      List friends = LocalStorage.getUserBox().get('friends', defaultValue: []);
      int userId = LocalStorage.getUserInfo()['id'];

      int? friendId = userId == communicate['from']
          ? communicate['to']
          : communicate['from'];
      final chatItem = listFind(
        friends,
        (item) => item['friendId'] == friendId,
      );
      _communicate = chatItem;
      print('xxxxxxxxxxxxx $chatItem $friendId $userId ${communicate['from']}');
    }

    _communicate?['offer'] = communicate['offer'];
    _communicate?['answer'] = communicate['answer'];
    notifyListeners();
  }

  void sendCallAudio(Map<dynamic, dynamic> communicateChat) async {
    setCommunicate(communicateChat);
    _peerConnection = await createPeerConnection({});

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
    });

    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    _peerConnection?.onTrack = (event) {
      if (event.track.kind == 'audio') {
        _remoteStream = event.streams[0];
      }
    };

    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection?.setLocalDescription(offer);

    _peerConnection?.onIceCandidate =
        (candidate) => _peerConnection?.addCandidate(candidate);

    final user = LocalStorage.getUserInfo();

    SocketIOClient.emit('offer', {
      'from': user['id'],
      'to': _chat?['friendId'],
      'type': 3,
      'offer': {
        'sdp': offer.sdp,
        'type': offer.type,
      },
    });

    notifyListeners();
  }

  Future<void> setAnswer(Map<dynamic, dynamic> communicate) async {
    print('setAnswer');
    setCommunicate(communicate);
    // RTCSessionDescription answer = communicate['answer']['sdp'];
    print('${communicate['answer']}');
    await _peerConnection?.setRemoteDescription(communicate['answer']);
    _isCommunicate = true;
  }

  void putThrough() async {
    await communicateOfferSocket();
    notifyListeners();
  }

  Future<void> communicateOfferSocket() async {
    _peerConnection = await createPeerConnection({});

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
    });

    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    _peerConnection?.onTrack = (event) {
      if (event.track.kind == 'audio') {
        _remoteStream = event.streams[0];
      }
    };

    RTCSessionDescription description = RTCSessionDescription(
        _communicate?['offer']['sdp'], _communicate?['offer']['type']);

    await _peerConnection?.setRemoteDescription(description);

    RTCSessionDescription answer = await _peerConnection!.createAnswer();
    await _peerConnection?.setLocalDescription(answer);

    _peerConnection?.onIceCandidate =
        (candidate) => _peerConnection?.addCandidate(candidate);

    final user = LocalStorage.getUserInfo();

    _isCommunicate = true;

    SocketIOClient.emit('answer', {
      'from': user['id'],
      'to': _communicate?['from'],
      'type': 3,
      'answer': {
        'sdp': answer.sdp,
        'type': answer.type,
      }
    });
  }

  void clearChat() {
    _chat = null;
    notifyListeners();
  }

  Future<void> stopPeerConnection() async {
    _localStream?.dispose();
    _remoteStream?.dispose();

    await _peerConnection?.close();

    _peerConnection = null;
    _localStream = null;
    _remoteStream = null;

    _isCommunicate = false;
    _communicate = null;

    notifyListeners();
  }
}
