import 'package:hive/hive.dart';

class UserHiveModel extends HiveObject {
  final String id;
  final String name;
  final String account;
  final String avatar;
  final Map<String, dynamic> setting;

  final List<dynamic> friends;
  final List<dynamic> messages;
  final List<dynamic> chatList;

  UserHiveModel({
    required this.id,
    required this.name,
    required this.account,
    required this.avatar,
    Map<String, dynamic>? setting,
    List<dynamic>? friends,
    List<dynamic>? messages,
    List<dynamic>? chatList,
  })  : setting = setting ?? {},
        friends = friends ?? [],
        messages = messages ?? [],
        chatList = chatList ?? [];
}

class UserAdapter extends TypeAdapter<UserHiveModel> {
  @override
  final typeId = 2;

  @override
  UserHiveModel read(BinaryReader reader) {
    return UserHiveModel(
      id: reader.readString(),
      name: reader.readString(),
      account: reader.readString(),
      avatar: reader.readString(),
      setting: reader.readMap().cast<String, dynamic>(),
      friends: reader.readList(),
      messages: reader.readList(),
      chatList: reader.readList(),
    );
  }

  @override
  void write(BinaryWriter writer, UserHiveModel obj) {
    // .. 表示连续调用，可以省略前面的对象
    // writer.writeString(obj.id)
    // writer.writeString(obj.account)
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeString(obj.account)
      ..writeString(obj.avatar)
      ..writeMap(obj.setting)
      ..writeList(obj.friends)
      ..writeList(obj.messages)
      ..writeList(obj.chatList);
  }
}

//  var box = await Hive.openBox<User>('users');
//   // 创建用户
//   User user = User(id: '1', account: 'example', username: 'User1');
//   // 添加朋友及聊天记录
//   user.friends.addAll(['Friend1: Hello', 'Friend2: Hi']);
//   // 修改聊天记录
//   user.friends[0] = 'Friend1: Updated message'; // 修改索引为 0 的记录
//   // 保存更新到 Hive
//   await box.put(user.id, user);
//   // 读取用户并输出朋友列表
//   User? retrievedUser = box.get(user.id);
//   print(retrievedUser?.friends); // 输出: [Friend1: Updated message, Friend2: Hi]

// class UserAdapter extends TypeAdapter<User> {
//   @override
//   final typeId = 0;

//   @override
//   User read(BinaryReader reader) {
//     // 从 BinaryReader 中读取数据
//     String id = reader.readString();
//     String account = reader.readString();
//     String username = reader.readString();
//     Map<String, dynamic> setting = reader.readMap().cast<String, dynamic>();
//     List<dynamic> friends = reader.readList();
//     List<dynamic> messages = reader.readList();
//     List<dynamic> chatList = reader.readList();

//     // 返回新的 User 对象
//     return User(
//       id: id,
//       account: account,
//       username: username,
//       setting: setting,
//       friends: friends,
//       messages: messages,
//       chatList: chatList,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, User obj) {
//     // 向 BinaryWriter 写入数据
//     writer.writeString(obj.id);
//     writer.writeString(obj.account);
//     writer.writeString(obj.username);
//     writer.writeMap(obj.setting);
//     writer.writeList(obj.friends);
//     writer.writeList(obj.messages);
//     writer.writeList(obj.chatList);
//   }
// }

