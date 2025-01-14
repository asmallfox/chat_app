import 'dart:async';

import 'package:chat_app/src/socket/socket_api.dart';
import 'package:chat_app/src/utils/hive_util.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRtc {
  static final WebRtc _instance = WebRtc._internal();
  factory WebRtc() => _instance;
  WebRtc._internal();

  static bool _isInitialized = false;
  // 本地
  static final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  static final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  static RTCPeerConnection? _peerConnection;
  static MediaStream? _localStream;
  static MediaStream? _remoteStream;

  static final _configuration = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'}
    ]
  };

  static Future<WebRtc> getInstance() async {
    if (!_isInitialized) {
      await _initialize();
    }
    return _instance;
  }

  static Future<void> _initialize() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    _isInitialized = true;
  }

  static RTCVideoRenderer get localRenderer => _localRenderer;
  static RTCVideoRenderer get remoteRenderer => _remoteRenderer;
  static RTCPeerConnection? get peerConnection => _peerConnection;
  static MediaStream? get localStream => _localStream;
  static MediaStream? get remoteStream => _remoteStream;

  static Future<MediaStream> _getMediaStream(bool isAudio, bool isVideo) async {
    MediaStream mediaStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });

    return mediaStream;
  }

  // 创建提议（offer）
  static Future<RTCSessionDescription> createOffer() async {
    _peerConnection = await createPeerConnection(_configuration);
    _localStream = await _getMediaStream(false, true);

    // 设置本地音视频流
    _localRenderer.srcObject = _localStream!;

    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    _peerConnection?.onTrack = (event) {
      _remoteStream = event.streams[0];
      _remoteRenderer.srcObject = _remoteStream;
    };

    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    _peerConnection?.onIceCandidate = (candidate) {
      _sendIceCandidate(candidate, 2);
    };

    return offer;
  }

  // 创建应答（answer）
  static Future<RTCSessionDescription> createAnswer(Map offer) async {
    _peerConnection = await createPeerConnection(_configuration);
    _localStream = await _getMediaStream(true, false);
    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    // 设置本地音视频流
    _localRenderer.srcObject = _localStream!;

    _peerConnection?.onTrack = (event) {
      _remoteStream = event.streams[0];
      _remoteRenderer.srcObject = _remoteStream;
    };

    RTCSessionDescription description =
        RTCSessionDescription(offer['sdp'], offer['type']);
    await _peerConnection!.setRemoteDescription(description);

    RTCSessionDescription answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    _peerConnection?.onIceCandidate = (candidate) {
      // _peerConnection?.addCandidate(candidate);
      _sendIceCandidate(candidate, 3);
    };

    return answer;
  }

// 发送 ICE Candidate
  static void _sendIceCandidate(RTCIceCandidate candidate, int to) {
    SocketApi.sendICESocketApi({
      'from': UserHive.userInfo['id'],
      'to': to,
      'candidateData': {
        'type': 'candidate',
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex
      },
    });
  }

  // 设置ICE
  static Future<void> setCandidate(Map candidate) async {
    print('交换ICE');
    _peerConnection?.addCandidate(RTCIceCandidate(
      candidate['candidate'],
      candidate['sdpMid'],
      candidate['sdpMLineIndex'],
    ));
  }

  // 设置应答
  static Future<void> setAnswer(Map answer) async {
    RTCSessionDescription description =
        RTCSessionDescription(answer['sdp'], answer['type']);
    await _peerConnection?.setRemoteDescription(description);
  }

  // 关闭连接
  static Future<void> closeConnection() async {
    // 关闭本地媒体流
    _localStream?.getTracks().forEach((track) {
      track.stop();
    });
    _remoteStream?.getTracks().forEach((track) {
      track.stop();
    });

    // 关闭PeerConnection
    await _peerConnection?.close();

    // 清理变量
    _peerConnection = null;
    _localStream = null;
    _remoteStream = null;

    _localRenderer.srcObject?.dispose();
    _remoteRenderer.srcObject?.dispose();
  }
}
