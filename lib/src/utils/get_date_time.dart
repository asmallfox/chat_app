import 'package:intl/intl.dart';

String getDateTime(int date) {
  DateTime dataTime = DateTime.fromMillisecondsSinceEpoch(date * 1000);
  DateTime nowTime = DateTime.now();
  bool isYear = dataTime.year == nowTime.year;
  bool isMonth = isYear && dataTime.month == nowTime.month;

  int differDay = nowTime.day - dataTime.day;

  String time;

  if (isMonth) {
    switch (differDay) {
      case 0:
        time =  DateFormat('HH:mm').format(dataTime.toLocal());
        break;
      case 1:
        time = '昨天';
        break;
      case 2:
        time = '前天';
        break;
      default:
        time = DateFormat('MM-dd').format(dataTime);
    }
  } else if (isYear) {
    time = DateFormat('MM-dd').format(dataTime);
  } else {
    time = DateFormat('yyyy-MM-dd').format(dataTime);
  }
  return time;
}