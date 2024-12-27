// const String serverBaseUrl = 'http://192.168.1.8:3000';
// const String baseUrl = 'http://192.168.31.22:3000';
const String serverBaseUrl = 'http://10.0.2.2:3001';

enum MessageType {
  text(1, '文本'),
  image(2, '图片'),
  audio(3, '语音'),
  video(4, '视频'),
  file(5, '文件');

  final int value;
  final String label;

  const MessageType(this.value, this.label);

  static String getText(int type) {
    return MessageType.values
        .firstWhere((e) => e.value == type, orElse: () => MessageType.text)
        .label;
  }
}


enum AddFriendButtonStatus {
  add(1, '添加'),
  refuse(2, '已拒绝'),
  added(3, '已添加'),
  delete(4, '删除');

  final int value;
  final String label;

  const AddFriendButtonStatus(this.value, this.label);

  static String getText(int status) {
    return AddFriendButtonStatus.values
        .firstWhere((e) => e.value == status,
            orElse: () => AddFriendButtonStatus.add)
        .label;
  }
}

enum ReadStatus {
  no(1, '未读'),
  yes(2, '已读');

  final int value;
  final String label;

  const ReadStatus(this.value, this.label);

  static String getText(int status) {
    return ReadStatus.values
        .firstWhere((e) => e.value == status, orElse: () => ReadStatus.no)
        .label;
  }
}

enum MsgStatus {
  sending(1, '发送中'),
  sent(2, '已发送'),
  failed(3, '发送失败');

  final int value;
  final String label;

  const MsgStatus(this.value, this.label);

  static String getText(int status) {
    return MsgStatus.values
        .firstWhere((e) => e.value == status, orElse: () => MsgStatus.sending)
        .label;
  }
}
