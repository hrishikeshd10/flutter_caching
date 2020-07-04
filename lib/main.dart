import 'dart:io';

import 'package:caching_flutter/ApiCall/api_call.dart';
import 'package:caching_flutter/ApiResponse/api_response.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ApiCall _apiCall = new ApiCall();
  Future<void> _deleteCacheContents() async {
    final cacheDir = await getTemporaryDirectory();
    String fileName = "CacheData.json";

    if (await File(cacheDir.path + "/" + fileName).exists()) {
      cacheDir.delete(recursive: true);
      print("Deleted the CacheJson file!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Caching"),
        centerTitle: true,
      ),
      body: FutureBuilder<ApiResponse>(
        future: _apiCall.getUserDataResponse(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserData> usersList = List<UserData>();

            usersList = snapshot.data.data;

            return ListView.builder(
                itemCount: usersList.length,
                itemBuilder: (context, index) {
                  UserData userData = usersList[index];
                  return ListTile(
                    title: Text(userData.firstName + " " + userData.lastName),
                    subtitle: Text(userData.email),
                  );
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _deleteCacheContents,
        tooltip: 'Delete the Cache file',
        child: Icon(Icons.delete),
      ),
    );
  }
}
