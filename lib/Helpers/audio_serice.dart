import 'package:flutter_sound/flutter_sound.dart';

class RecordingManager {
  static final RecordingManager _instance = RecordingManager._internal();

  RecordingManager._();

  factory RecordingManager() => _instance;

  RecordingManager._internal();

  // 录音
  static FlutterSoundRecorder? _audioRecorder;
  // 音频播放
  static FlutterSoundPlayer? _audioPlayer;

  static bool _isInitialized = false;

  static Future<RecordingManager> getInstance() async {
    if (!_isInitialized) {
      await _initialize();
    }

    return _instance;
  }

  static FlutterSoundPlayer get audioPlayer => _audioPlayer!;

  static Future<void> _initialize() async {
    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();

    await _audioPlayer?.openPlayer();

    _isInitialized = true;
  }

  static Future<void> startRecording() async {
    await _audioRecorder?.openRecorder();
    await _audioRecorder?.startRecorder(toFile: 'temp_audio.aac');
  }

  static Future<String?> stopRecording() async {
    String? filePath = await _audioRecorder?.stopRecorder();
    return filePath;
  }
}
