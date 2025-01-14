import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';

class RecordingHelper {
  static final RecordingHelper _instance = RecordingHelper._internal();

  factory RecordingHelper() => _instance;

  RecordingHelper._internal();

  static FlutterSoundRecorder? _audioRecorder;
  static FlutterSoundPlayer? _audioPlayer;

  static bool _isInitialized = false;

  static Future<RecordingHelper> getInstance() async {
    if (!_isInitialized) {
      await _initialize();
    }

    return _instance;
  }

  static Future<void> _initialize() async {
    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();

    // await _audioRecorder?.openRecorder();
    await _audioPlayer?.openPlayer();

    _isInitialized = true;
  }

  static FlutterSoundRecorder get audioRecorder {
    if (_audioRecorder == null) {
      throw Exception('录音插件未初始化！');
    }
    return _audioRecorder!;
  }

  static FlutterSoundPlayer get audioPlayer {
    if (_audioPlayer == null) {
      throw Exception('音频插件未初始化！');
    }
    return _audioPlayer!;
  }

  static Future<void> startRecording() async {
    try {
      if (_audioRecorder == null) {
        throw Exception('AudioRecorder is null');
      }
      await _audioRecorder?.openRecorder();
      await _audioRecorder?.startRecorder(toFile: 'temp_audio.aac');
    } catch (error) {
      print('录音失败：$error');
    }
  }

  static Future<String?> stopRecording() async {
    String? filePath = await _audioRecorder?.stopRecorder();
    return filePath;
  }

  // 播放音频
  static Future<void> play(
    String url, {
    bool assets = false,
    Codec? codec,
    TWhenFinished? whenFinished,
    bool loop = false,
  }) async {
    // 定义一个回调函数来处理播放完成后的逻辑
    Future<void> onFinished() async {
      if (loop) {
        // 如果设置了循环播放，则重新调用 play 方法
        await play(
          url,
          assets: assets,
          codec: codec,
          whenFinished: whenFinished,
          loop: loop,
        );
      } else {
        // 如果没有循环播放，执行 whenFinished 回调
        whenFinished?.call();
      }
    }

    if (assets) {
      final byteData = await rootBundle.load(url);
      final buffer = byteData.buffer.asUint8List();

      // 启动播放器，设置当播放完成时的回调逻辑
      RecordingHelper.audioPlayer.startPlayer(
        fromDataBuffer: buffer,
        codec: codec ?? Codec.mp3,
        whenFinished: onFinished,
      );
    } else {
      RecordingHelper.audioPlayer.startPlayer(
        fromURI: url,
        codec: codec ?? Codec.aacADTS,
        whenFinished: onFinished,
      );
    }
  }
}
