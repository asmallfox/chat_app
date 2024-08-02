import 'package:chat_app/Helpers/local_storage.dart';
import 'package:flutter/material.dart';

class MessageText extends StatefulWidget {
  final Map item;

  const MessageText({
    super.key,
    required this.item,
  });

  @override
  State<MessageText> createState() => _MessageTextState();
}

class _MessageTextState extends State<MessageText> {
  Map userInfo = LocalStorage.getUserInfo();

  bool isSelf = false;

  @override
  void initState() {
    super.initState();
    isSelf = userInfo['id'] == widget.item['from'];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 15,
          ),
          constraints: const BoxConstraints(
            minHeight: 40,
          ),
          decoration: BoxDecoration(
            color:
                isSelf ? Theme.of(context).colorScheme.primary : Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                spreadRadius: 14,
                blurRadius: 20,
                offset: const Offset(6, 8),
              ),
            ],
          ),
          child: Text(
            widget.item['message'] ?? 'null',
            style: TextStyle(
              fontSize: 18,
              color: isSelf ? Colors.white : Colors.black,
            ),
          ),
        ),
        Positioned(
          top: 15,
          left: isSelf ? null : 0,
          right: isSelf ? 0 : null,
          child: MessageTriangle(
            isStart: isSelf,
            color:
                isSelf ? Theme.of(context).colorScheme.primary : Colors.white,
          ),
        ),
      ],
    );
  }
}

class MessageTriangle extends StatelessWidget {
  final bool isStart;
  final Color color;

  const MessageTriangle({
    super.key,
    this.isStart = true,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          top: const BorderSide(
            color: Colors.transparent,
            width: 6,
          ),
          bottom: const BorderSide(
            color: Colors.transparent,
            width: 6,
          ),
          start: BorderSide(
            color: isStart ? color : Colors.transparent,
            width: 8,
          ),
          end: BorderSide(
            color: isStart ? Colors.transparent : color,
            width: 8,
          ),
        ),
      ),
    );
  }
}
