import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WifiApp(),
    );
  }
}

class WifiApp extends StatefulWidget {
  @override
  _WifiAppState createState() => _WifiAppState();
}

class _WifiAppState extends State<WifiApp> {
  String collectedData = "No data yet";

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://raspberrypi-ip-address:5000/api/data'));
    if (response.statusCode == 200) {
      setState(() {
        collectedData = json.decode(response.body).toString();
      });
    } else {
      setState(() {
        collectedData = "Error fetching data";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wi-Fi App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Collected Data:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(collectedData, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Fetch Data'),
            ),
          ],
        ),
      ),
    );
  }
}
