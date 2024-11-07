import 'package:flutter_sound/flutter_sound.dart';

class RecordingHelper {
  static final RecordingHelper _instance = RecordingHelper._internal();

  RecordingHelper._();

  factory RecordingHelper() => _instance;

  RecordingHelper._internal();

  static FlutterSoundRecorder? _audioRecorder;
  // 音频播放
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
    // await _audioPlayer?.openPlayer();

    _isInitialized = true;
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
}
