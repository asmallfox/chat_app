// const String serverBaseUrl = 'http://192.168.1.8:3000';
// const String baseUrl = 'http://192.168.31.22:3000';
const String serverBaseUrl = 'http://10.0.2.2:3000';

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

enum AddFriendButtonStatus {
  add(1, '添加'),
  refuse(2, '已拒绝'),
  added(3, '已添加'),
  delete(4, '删除');

  final int value;
  final String text;

  const AddFriendButtonStatus(this.value, this.text);

  static String getText(int status) {
    return AddFriendButtonStatus.values
        .firstWhere((e) => e.value == status,
            orElse: () => AddFriendButtonStatus.add)
        .text;
  }
}

enum ReadStatus {
  no(1, '未读'),
  yes(2, '已读');

  final int value;
  final String text;

  const ReadStatus(this.value, this.text);

  static String getText(int status) {
    return ReadStatus.values
        .firstWhere((e) => e.value == status, orElse: () => ReadStatus.no)
        .text;
  }
}

enum MsgStatus {
  sending(1, '发送中'),
  sent(2, '已发送'),
  failed(3, '发送失败');

  final int value;
  final String text;

  const MsgStatus(this.value, this.text);

  static String getText(int status) {
    return MsgStatus.values
        .firstWhere((e) => e.value == status, orElse: () => MsgStatus.sending)
        .text;
  }
}
