import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class AudioService  {
  AudioPlayer audioPlayer = AudioPlayer();

  // Future<String> startRecording() async {
  //   Directory appDir = await getApplicationDocumentsDirectory();
  //   String filePath = '${appDir.path}/recording.aac';
  //
  //   await audioPlayer.startRecorder(toFile: filePath, codec: Codec.aacADTS);
  //   return filePath;
  //
  //   try {
  //     await recorder
  //   } catch (error) {}
  // }

}

class RecordingManager {
   final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();


  Future<void> startRecording() async {
    await _audioRecorder.openRecorder();
    await _audioRecorder.startRecorder(toFile: 'temp_audio.aac');
  }

  Future<String?> stopRecording() async {
    String? filePath = await _audioRecorder.stopRecorder();
    // await _audioRecorder.closeRecorder();
    // if (filePath != null) {
    //   print(filePath);
    // }

    return filePath;
  }
}