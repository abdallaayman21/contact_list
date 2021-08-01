import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
          future: rootBundle.loadString('data/contact_list.json'),
          builder: (contxt, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                List contactList = json.decode(snapshot.data.toString());
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: contactList.length,
                  itemBuilder: (context, i) {
                    Map data = contactList[i];
                    DateTime time = DateTime.parse(data['check-in']);
                    Duration duration = DateTime.now().difference(time);
                    return ListTile(
                      title: Text(data['user']),
                      subtitle: Text(data['phone']),
                      trailing: Text(
                          "${((duration.inDays / 30) / 12).round()} years ago"),
                      leading: Icon(Icons.phone),
                    );
                  },
                );
              }
            }
            return Text("No Data");
          },
        ),
      ),
    );
  }
}
