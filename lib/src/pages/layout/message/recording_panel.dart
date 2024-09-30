import 'package:chat_app/src/constants/global_key.dart';
import 'package:flutter/material.dart';

class RecordingPanel extends StatefulWidget {
  final bool closeButtonCoincide;
  final bool sendButtonCoincide;
  const RecordingPanel({
    super.key,
    this.closeButtonCoincide = false,
    this.sendButtonCoincide = false,
  });

  @override
  State<RecordingPanel> createState() => _RecordingPanelState();
}

class _RecordingPanelState extends State<RecordingPanel> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  key: voiceCancelKey,
                  color: Colors.transparent,
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '松开 取消',
                            style: TextStyle(
                              color: Colors.white.withOpacity(
                                  widget.closeButtonCoincide ? 0.72 : 0),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 60,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: widget.closeButtonCoincide
                                  ? Colors.black26
                                  : Colors.black38,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: widget.closeButtonCoincide
                                  ? Colors.grey[100]
                                  : Colors.grey[500],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                key: voiceSendKey,
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
                              widget.sendButtonCoincide ? 0.72 : 0),
                          fontSize: 16,
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
                          color: widget.sendButtonCoincide
                              ? Colors.black26
                              : Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: Container(
            width: 200,
            height: 200,
            color: Colors.pink,
          )
        )
      ],
    );
  }
}
