import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:domgaleto/models/home/page_manager.dart';
import 'package:domgaleto/models/user/user_manager.dart';
import 'package:domgaleto/screens/admin_orders/admin_orders_screen.dart';
import 'package:domgaleto/screens/admin_users/admin_users_screen.dart';
import 'package:domgaleto/screens/home/home_screen.dart';
import 'package:domgaleto/screens/orders/orders_screen.dart';
import 'package:domgaleto/screens/products/products_screen.dart';
import 'package:domgaleto/screens/stores/stores_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    configFCM();
  }

  void configFCM() {
    final fcm = FirebaseMessaging.instance;

    if (Platform.isIOS) {
      fcm.requestPermission();
    }

    void showNotification(String title, String message) {
      Flushbar(
        title: title,
        message: message,
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        isDismissible: true,
        backgroundColor: Theme.of(context).primaryColor,
        duration: const Duration(seconds: 5),
        icon: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
      ).show(context);
    }

    // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    fcm.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('getInitialMessage data: ${message.data}');
      }
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp data: ${message.data}');
    });

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showNotification(
        message.data["notification"]['title'] as String,
        message.data['notification']['body'] as String,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              HomeScreen(),
              const ProductsScreen(),
              OrdersScreen(),
              StoresScreen(),
              if (userManager.adminEnabled()) ...[
                AdminUsersScreen(),
                AdminOrdersScreen(),
              ]
            ],
          );
        },
      ),
    );
  }
}
