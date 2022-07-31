import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_fastapi_pods/first_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Version 0.2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(this.title);
}

class _MyHomePageState extends State<MyHomePage> {
  final String title;

  var myEmailController = TextEditingController();
  var myPasswordController = TextEditingController();

  _MyHomePageState(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: myEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: myPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.password),
                    ),
                  ),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                      onPressed: () {
                        login();
                      },
                      icon: const Icon(
                        Icons.login,
                        size: 16,
                      ),
                      label: const Text(
                        'Login',
                      )),
                ],
              ),
            )),
      ),
    );
  }

  // Login with HTTP POST to FastAPI
  Future<void> login() async {
    if (myEmailController.text.isEmpty || myPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter email/password')));
    } else {
      final response = await http.post(Uri.parse('http://127.0.0.1:8000/login'),
          body: json.encode({
            'email': myEmailController.text,
            'password': myPasswordController.text,
          }),
          headers: {
            'Content-Type': 'application/json',
          });
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login successful')));
        var items = json.decode(response.body);
        // var folders = response.body.
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FirstScreen(items: items)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Login failed (invalid email/password)')));
      }
    }
  }
}
