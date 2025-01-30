import 'package:firebase_messaging/firebase_messaging.dart';


FirebaseMessaging messaging = FirebaseMessaging.instance;

// Demande de permission pour iOS
void requestPermission() async {
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('L\'utilisateur a autorisé les notifications.');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('L\'utilisateur a donné une autorisation provisoire.');
  } else {
    print('L\'utilisateur a refusé les notifications.');
  }
}
