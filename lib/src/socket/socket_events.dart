import 'package:chat_app/src/utils/hive_util.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void socketEvents(IO.Socket socket) {
  socket.on('friend_verify', (data) {
    final friendVerify = UserHive.verifyList;

    List newFriendVerify = data is List ? data : [data];

    for (int i = 0; i < newFriendVerify.length; i++) {
      int index = friendVerify['data']
          .indexWhere((element) => element['id'] == newFriendVerify[i]['id']);
      if (index != -1) {
        friendVerify['data'].removeAt(index);
      }
    }

    friendVerify['newCount'] =
        friendVerify['newCount'] + newFriendVerify.length;
    friendVerify['data'].insertAll(0, newFriendVerify);

    UserHive.box.put('verifyList', friendVerify);
    

    print('======== ${UserHive.verifyList}');
  });
}
