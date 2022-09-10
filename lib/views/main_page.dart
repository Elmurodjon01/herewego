
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  static String id = 'mainpage';
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Home'),
      ),
      body: Center(
        child: Container(
          width: 130,
          color: Colors.deepOrange,
          child: TextButton(
            child: const Text('Log Out', style: TextStyle(color: Colors.white),),
            onPressed: (){
              AuthService.removeUser(context);
            },
          ),
        ),
      ),
    );
  }
}
