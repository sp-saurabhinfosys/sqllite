import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqllite/database_helper.dart';
import 'package:sqllite/model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApplication(),
    );
  }
}

class MyApplication extends StatefulWidget {
  @override
  _MyApplicationState createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication> {
  String myName;

  List<Map<String, dynamic>> fetch;
  var list = [];

  getFetchData() async {
   await DatabaseHelper.instance.init();
    list = await DatabaseHelper.instance.fetch();
    print(list.length);
    print(list[0]['id']);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getFetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              onChanged: (x) {
                myName = x;
                setState(() {});
              },
            ),
            FlatButton(
              onPressed: () async {
                int inserted = await DatabaseHelper.instance.insert({
                  DatabaseHelper.columnName: myName,
                });
                getFetchData();
                print("$inserted");
              },
              child: Text("Insert"),
              color: Colors.amber,
            ),
            FlatButton(
              onPressed: () async {
                int update = await DatabaseHelper.instance.update({
                  DatabaseHelper.columnId: 12,
                  DatabaseHelper.columnName: "Rahul"
                });
              },
              child: Text("Update"),
              color: Colors.green,
            ),
            FlatButton(
              onPressed: () async {
                await DatabaseHelper.instance.delete(10);
              },
              child: Text("Delete"),
              color: Colors.red,
            ),
            FlatButton(
              onPressed: () async {
                fetch = await DatabaseHelper.instance.fetch();
                print(fetch);
                getFetchData();
              },
              child: Text("Select"),
              color: Colors.orange,
            ),
            list.isEmpty
                ? Container(
                    color: Colors.red,
                    height: 100,
                    width: 100,
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (c, i) {
                          return GestureDetector(
                            onTap: () async {
                              await DatabaseHelper.instance.delete(list[i]["id"]);
                              setState(() {
                                print(list.length);
                                getFetchData();
                              });
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(list[i]["name"]),
                              ),
                            ),
                          );
                        }))
          ],
        ),
      ),
    );
  }
}
