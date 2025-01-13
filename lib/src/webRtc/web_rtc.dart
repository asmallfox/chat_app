import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRtc {
  static final WebRtc _instance = WebRtc._internal();
  factory WebRtc() => _instance;
  WebRtc._internal();

  static bool _isInitialized = false;
  // 本地
  static RTCVideoRenderer? _localRenderer;
  static RTCPeerConnection? _peerConnection;
  static MediaStream? _localStream;
  static MediaStream? _remoteStream;

  static Future<WebRtc> getInstance() async {
    if (!_isInitialized) {
      _initialize();
    }
    return _instance;
  }

  static _initialize() {
    // _localRenderer = RTCVideoRenderer();
    _isInitialized = true;
  }

  static RTCVideoRenderer? get localRenderer => _localRenderer;
  static RTCPeerConnection? get peerConnection => _peerConnection;
  static MediaStream? get localStream => _localStream;
  static MediaStream? get remoteStream => _remoteStream;

  static Future<MediaStream> _getMediaStream(bool isAudio, bool isVideo) async {
    late MediaStream mediaStream;

    if (isAudio) {
      mediaStream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': false,
      });
    } else {
      mediaStream = await navigator.mediaDevices.getUserMedia({
        'audio': false,
        'video': {'width': 100, 'height': 100},
      });
    }
    // await navigator.mediaDevices.getUserMedia({
    //   'audio': true,
    //   'video': {'width': 100, 'height': 100}
    // });

    return mediaStream;
  }

  // 创建提议（offer）
  static Future<RTCSessionDescription> createOffer() async {
    _peerConnection = await createPeerConnection({});
    _localStream = await _getMediaStream(false, true);
    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    _peerConnection?.onTrack = (event) {
      print('远程数据流offer ${event.track.kind}');

      if (event.track.kind == 'audio') {
        _remoteStream = event.streams[0];
      }
    };

    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    _peerConnection?.onIceCandidate = (candidate) {
      print('交换IEC候补');
      _peerConnection?.addCandidate(candidate);
    };

    return offer;
  }

  // 创建应答（answer）
  static Future<RTCSessionDescription> createAnswer(Map offer) async {
    _peerConnection = await createPeerConnection({});

    _localStream = await _getMediaStream(true, false);
    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    _peerConnection?.onTrack = (event) {
      print('远程数据流answer ${event.track.kind}');

      if (event.track.kind == 'audio') {
        _remoteStream = event.streams[0];
      }
    };

    RTCSessionDescription description =
        RTCSessionDescription(offer['sdp'], offer['type']);
    await _peerConnection!.setRemoteDescription(description);

    RTCSessionDescription answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    _peerConnection?.onIceCandidate = (candidate) {
      _peerConnection?.addCandidate(candidate);
    };

    return answer;
  }

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
  }
}
