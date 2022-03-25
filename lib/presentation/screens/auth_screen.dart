import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app_second/presentation/widgets/auth_card.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                    Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1]),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'My Shop',
                        style: TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 40,
                          color: Colors.white70,
                        ),
                      ),
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade900,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: AuthCard(),
                    flex: 7,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
