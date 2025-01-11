import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTC {
  static final WebRTC _instance = WebRTC._internal();
  factory WebRTC() => _instance;
  WebRTC._internal();

  static bool _isInitialized = false;
  // 本地
  static RTCVideoRenderer? _localRenderer;
  static RTCPeerConnection? _peerConnection;
  static MediaStream? _localStream;
  static MediaStream? _remoteStream;

  static WebRTC getInstance() {
    if (!_isInitialized) {
      _initialize();
    }
    return _instance;
  }

  static _initialize() {
    _localRenderer = RTCVideoRenderer();
    _isInitialized = true;
  }

  RTCVideoRenderer? get localRenderer => _localRenderer;
  RTCPeerConnection? get peerConnection => _peerConnection;
  MediaStream? get localStream => _localStream;
  MediaStream? get remoteStream => _remoteStream;
}
