import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class AudioService  {
  AudioPlayer audioPlayer = AudioPlayer();

  Future<String> startRecording() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDir.path}/recording.aac';

    await audioPlayer.startRecorder(toFile: filePath, codec: Codec.aacADTS);
    return filePath;

    try {
      await recorder
    } catch (error) {}
  }

}