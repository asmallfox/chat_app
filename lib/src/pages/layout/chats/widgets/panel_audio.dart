import 'dart:async';

import 'package:chat_app/src/constants/global_key.dart';
import 'package:chat_app/src/helpers/recording_helper.dart';
import 'package:chat_app/src/providers/model/chat_provider_model.dart';
import 'package:chat_app/src/widgets/painters/audio_cable_painter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef OnSend = void Function(Map?);

class PanelAudio extends StatefulWidget {
  final OnSend? onSend;
  const PanelAudio({
    super.key,
    this.onSend,
  });

  @override
  State<PanelAudio> createState() => _PanelAudioState();
}

class _PanelAudioState extends State<PanelAudio> {
  StreamSubscription? _progressSubscription;
  int duration = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _progressSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) => _handleStartRecording(context, details),
      onLongPressMoveUpdate: (details) =>
          _handleStartRecording(context, details),
      onVerticalDragUpdate: (details) =>
          _handleStartRecording(context, details),
      onHorizontalDragUpdate: (details) =>
          _handleStartRecording(context, details),
      onLongPressUp: () => _handleStopRecording(context),
      onTapUp: (_) => _handleStopRecording(context),
      onVerticalDragEnd: (_) => _handleStopRecording(context),
      onHorizontalDragEnd: (_) => _handleStopRecording(context),
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: const Text('按住 说话'),
      ),
    );
  }

  void _handleStartRecording(BuildContext context, details) {
    if (!mounted) return;
    final chatProvider = context.read<ChatProviderModel>();
    if (!chatProvider.isRecord) {
      _showRecordingPanel(context);
    }
    final recordSendBtn =
        _widgetCoincide(recordingSendBtnKey, details.globalPosition, 1);
    final recordCancelBtn =
        _widgetCoincide(recordingCancelBtnKey, details.globalPosition, 2);
    chatProvider.setIsRecord(true);
    chatProvider.setRecordCancelBtn(recordCancelBtn);
    chatProvider.setRecordSendBtn(recordSendBtn);
  }

  void _handleStopRecording(BuildContext context) {
    if (!mounted) return;
    final chatProvider = context.read<ChatProviderModel>();
    _stopRecording(chatProvider.recordSendBtn);
    chatProvider.setIsRecord(false);
    chatProvider.setRecordCancelBtn(false);
    chatProvider.setIsRecord(false);
    Navigator.pop(context);
  }

  bool _widgetCoincide(GlobalKey widgetKey, Offset position, int type) {
    if (widgetKey.currentContext == null) return type == 1;

    RenderBox renderBox =
        widgetKey.currentContext?.findRenderObject() as RenderBox;

    Offset offset = renderBox.localToGlobal(Offset.zero);
    double boxX = offset.dx;
    double boxY = offset.dy;
    double x = position.dx;
    double y = position.dy;
    double sizeW = renderBox.size.width;
    double sizeH = renderBox.size.height;

    bool coincide =
        (x > boxX && x < boxX + sizeW) && (y > boxY && y < boxY + sizeH);
    return coincide;
  }

  void _startRecording() async {
    try {
      await RecordingHelper.audioRecorder.openRecorder();
      RecordingHelper.audioRecorder
          .setSubscriptionDuration(const Duration(milliseconds: 100));

      _progressSubscription =
          RecordingHelper.audioRecorder.onProgress?.listen((e) {
        duration = (e.duration.inMilliseconds / 1000).ceil();
        context.read<ChatProviderModel>().setDecibelsList(e.decibels!);
      });

      await RecordingHelper.audioRecorder.startRecorder(
        toFile: 'test_audio.aac',
        enableVoiceProcessing: true,
      );
    } catch (e) {
      print('_startRecording: $e');
    }
  }

  void _stopRecording(bool isSend) async {
    context.read<ChatProviderModel>().setDecibelsList(0, true);
    String? filePath = await RecordingHelper.audioRecorder.stopRecorder();

    if (!isSend) {
      filePath = null;
      await RecordingHelper.audioRecorder
          .deleteRecord(fileName: 'test_audio.aac');
    }

    if (widget.onSend != null) {
      widget.onSend?.call({
        'filePath': filePath,
        'duration': duration,
      });
    }
  }

  void _showRecordingPanel(BuildContext context) async {
    _startRecording();
    await showDialog(
      barrierColor: Colors.black.withOpacity(0.68),
      context: context,
      builder: (_) {
        return Consumer<ChatProviderModel>(
          builder: (context, chatProvider, child) {
            double width = MediaQuery.of(context).size.width;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  key: recordingCancelBtnKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Align(
                          child: CustomPaint(
                            size: const Size(200, 100),
                            painter: AudioCablePainter(
                                list: chatProvider.decibelsList),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(bottom: 40),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: chatProvider.recordCancelBtn
                                  ? Colors.black26
                                  : Colors.black38,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: chatProvider.recordCancelBtn
                                  ? Colors.grey[100]
                                  : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  key: recordingSendBtnKey,
                  width: width,
                  height: 140,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          '松开 发送',
                          style: TextStyle(
                            color: Colors.white.withOpacity(
                                chatProvider.recordSendBtn ? 0.72 : 0),
                            fontSize: 16,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: -(width * 0.5 / 2),
                        child: ClipOval(
                          child: Container(
                            width: width * 1.5,
                            height: 400,
                            color: chatProvider.recordSendBtn
                                ? Colors.black26
                                : Colors.black38,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
