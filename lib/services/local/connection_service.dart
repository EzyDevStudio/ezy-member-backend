import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';

class ConnectionService {
  ConnectionService._internal();
  static final ConnectionService instance = ConnectionService._internal();

  static Future<bool> checkConnection() async {
    final List<ConnectivityResult> result = await Connectivity().checkConnectivity();

    if (result.contains(ConnectivityResult.none)) MessageHelper.showDisconnected();

    return !result.contains(ConnectivityResult.none);
  }
}
