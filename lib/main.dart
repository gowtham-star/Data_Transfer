import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'databasehelper.dart';

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
  Duration refreshRate = Duration(seconds: 2);
  late Timer dataTimer;

  TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData(); // Initial data fetch
    dataTimer = Timer.periodic(refreshRate, (Timer t) {
      fetchData(); // Fetch data periodically
    });
  }

  Future<void> fetchData() async {
    final url = urlController.text;
    if (url.isEmpty) {
      setState(() {
        collectedData = "URL is empty";
      });
      return;
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
       final jsonData = json.decode(response.body);
      setState(() {
        collectedData = jsonData.toString();
      });

      //Storing data in database
      final dbHelper =  PiDatabase.instance;
      // Make changes based attribute names here
      var dataObj =  PiDataModel(
        timeStamp: jsonData["timeStamp"],
        temperature: jsonData["temperature"],
        random: jsonData["random"],
      );
      dbHelper.insertdata(dataObj);

    } else {
      setState(() {
        collectedData = "Error fetching data";
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    dataTimer.cancel();
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
            Text('Enter URL:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: 'Enter the URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Fetch Data'),
            ),
            SizedBox(height: 20),
            Text('Collected Data:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(collectedData, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
