import 'package:flutter/material.dart';
import 'package:flutter_fastapi_pods/main.dart';

class FirstScreen extends StatefulWidget {
  var items;

  FirstScreen({Key? key, required this.items}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to First Screen'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.items['message']),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MyHomePage(title: 'Version 0.2'),
                        ));
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout')),
            ],
          ),
        ),
      ),
    );
  }
}
