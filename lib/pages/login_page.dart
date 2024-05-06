import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_learning/models/user_model.dart';
import 'package:network_learning/pages/main_page.dart';
import 'package:network_learning/services/network_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "Login ",
            style: TextStyle(fontSize: 32),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                  hintText: "Your username",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                  hintText: "Your Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
            ),
          ),
          MaterialButton(
            minWidth: 150,
            height: 50,
            color: Colors.blue,
            onPressed: () async {
              String? info = await NetworkService.postDate(
                  api: NetworkService.apiAuthUsers,
                  param: NetworkService.paramEmpty(),
                  date: {
                    "username": usernameController.text,
                    "password": passwordController.text
                  });
              if (info != null) {
                Map<String, Object?> map = jsonDecode(info);
                UsersModel userModel = UsersModel.fromJson(map);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Successfully Loged in!"),
                  backgroundColor: Colors.blue,
                ));
                await Future.delayed(const Duration(seconds: 1));
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainPage(),
                        settings: RouteSettings(arguments: userModel)));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Username or Password is wrong!"),
                  backgroundColor: Colors.red,
                ));
              }
            },
            child: const Text("Login"),
          )
        ],
      ),
    );
  }
}
