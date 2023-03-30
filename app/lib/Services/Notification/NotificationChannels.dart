import 'package:varla/Services/Notification/NotificationChannelStream.dart';

class NotificationChannels {
  static Map<String, NotificationChannelStream> channels = {};

  static NotificationChannelStream? subscribe(String channelName) {
    return NotificationChannels.channels[channelName];
  }

  static void add(NotificationChannelStream websocket) {
    NotificationChannels.channels[websocket.channelName] = websocket;
  }

  // TODO add reconnect all after wifi off
  static void init({String channelName = ""}) {
    if (channelName != "") {
      NotificationChannels.channels[channelName]?.init();
    } else {
      NotificationChannels.channels
          .forEach((name, websocket) async => await websocket.init());
    }
  }
}
