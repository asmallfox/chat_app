class MessageType {
  final String label;
  final int value;

  const MessageType._(this.label, this.value);

  static const text = MessageType._('文本', 1);
  static const image = MessageType._('图片', 2);
  static const voice = MessageType._('语音', 3);
  static const video = MessageType._('视频', 4);
  static const file = MessageType._('文件', 5);
}
