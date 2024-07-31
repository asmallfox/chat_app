import 'dart:async';

import 'package:flutter/widgets.dart';

// GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
GlobalKey navigatorKey = GlobalKey();

final GlobalKey audioCloseKey = GlobalKey();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();
