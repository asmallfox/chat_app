// 好友验证
const verifyStatus = {
  'not_verified': {
    'label': '未验证',
    'value': 1,
  },
  'agreed': {
    'label': '已同意',
    'value': 2,
  },
  'rejected': {
    'label': '已拒绝',
    'value': 3,
  },
  'deleted': {
    'label': '已删除',
    'value': 4,
  },
};

// const messageStatus = {
//   'sending': {
//     'label': '正在发送',
//     'value': 1,
//   },
//   'success': {
//     'label': '发送成功',
//     'value': 2,
//   },
//   'fail': {
//     'label': '发送失败',
//     'value': 3,
//   }
// };

class MessageStatus {
  static int sending = 1;
  static int success = 2;
  static int fail = 3;
}

const messageType = {
  'text': {
    'label': '文本',
    'value': 1,
  },
  'image': {
    'label': '图片',
    'value': 2,
  },
  'voice': {
    'label': '语音',
    'value': 3,
  },
  'video': {
    'label': '视频',
    'value': 4,
  },
  'file': {
    'label': '文件',
    'value': 5,
  },
};
