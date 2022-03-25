import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static Future<String?> getToken() async {
    return FirebaseMessaging.instance.getToken(
        vapidKey: "BFegerezgi_Uv2hezgtkqEDTzzertez-Xbt8OK8mJ4eteztVsdWDJQLkMg");
  }
}
