import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import '../commons/common_imports/apis_commons.dart';
import '../commons/common_imports/common_libs.dart';
import '../models/notification_model.dart';
import 'constants/constants.dart';
import 'dart:convert';

final notificationProvider = Provider((ref) => MessagingFirebase());

class MessagingFirebase {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;

  Future<String> getFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        return token;
      } else {
        return '';
      }
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  subscribeTo({required String topicName}) {
    FirebaseMessaging.instance.subscribeToTopic(topicName);
  }

  unSubscribeFrom({required String topicName}) {
    FirebaseMessaging.instance.unsubscribeFromTopic(topicName);
  }

  Future<bool> pushNotificationsGroupDevice({
    required WidgetRef ref,
    required BuildContext context,
    required NotificationModel model,
    List<String>? registerIds,
    List<String>? userIds,
    bool isGroupNotification = false,
  }) async {
    try {
      final dataNotifications;
      dataNotifications = {
        'message': {
          'topic': model.placeId,
          'notification': {
            'title': model.title,
            'body': model.description,
          },
          'data': {
            'screen': jsonEncode(model.toMap()),
            'id': model.notificationId,
          },
        }
      };

      final serviceAccessToken = await Constants.getAccessToken();

      var response = await http.post(
        Uri.parse(Constants.BASE_URL),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serviceAccessToken',
        },
        body: jsonEncode(dataNotifications),
      );

      if (response.body.toString() ==
          '"registration_ids" field cannot be empty') {
        return false;
      } else {
        print(response.body.toString());
        return true;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
