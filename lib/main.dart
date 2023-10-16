import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'databasehelper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'chartspage.dart';


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
  Duration refreshRate = Duration(seconds: 1);
  List<PiDataModel>  databaseData= [];
  late Timer dataTimer;
  String debugOutput = "Null";

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

      //Display data from database
       final result = await dbHelper.getdata();
       setState(() {
         databaseData = result;
       });

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



  Future<void> downloadCsv() async {
    final dbHelper = PiDatabase.instance;
    final result = await dbHelper.getdata();

    final List<List<dynamic>> rows = [];

    // Convert PiDataModel objects to lists of values
    for (var data in result) {
      rows.add([
        data.timeStamp,
        data.temperature,
        data.random,
      ]);
    }

    final csvData = const ListToCsvConverter().convert(rows);

    // Request permission to access the selected directory
    final status = await Permission.storage.request();
    if (status.isGranted) {
      // Use the file picker to choose the folder location to save the file
      String? result = await FilePicker.platform.getDirectoryPath();

      if (result != null) {
        final folderPath = result;

        final file = File('$folderPath/pi_data.csv');
        await file.writeAsString(csvData);

        // Show a dialog or snackbar to inform the user that the download is complete.
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('CSV Downloaded'),
              content: Text('CSV file has been downloaded successfully to $folderPath/pi_data.csv'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Handle the case where the user cancels the folder selection.
        // You can show a message to inform the user.
      }
    } else {
      // Handle the case where permission is not granted.
      // You can show a message to inform the user.
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data collection and visualiser'),
      ),
      body: Center(
        child: Scrollbar( // Wrap your ListView with Scrollbar
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              Text('Enter the URL in this format http://x.x.x.x:5500', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  hintText: 'URL',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: fetchData,
                child: Text('Fetch Data'),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10), // Adjust the padding as needed
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1), // Add a border for better visual separation
                ),
                child: Text(
                  collectedData,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black, // Change the text color as needed
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  downloadCsv();
                },
                child: Text('Download CSV'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChartsPage(databaseData: databaseData),
                    ),
                  );
                },
                child: Text('View Charts'),
              ),

            ],
          ),
        ),
      ),
    );
  }



}



