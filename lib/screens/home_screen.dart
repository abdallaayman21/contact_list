import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';

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
                sortList(contactList);
                return ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: contactList.length,
                  separatorBuilder: (context, i) {
                    return Divider(
                      height: 5,
                      thickness: 1.0,
                    );
                  },
                  itemBuilder: (context, i) {
                    var data = contactList[i];
                    DateTime time = DateTime.parse(data['check-in']);
                    return ListTile(
                      title: Text(data['user']),
                      subtitle: Text(data['phone']),
                      trailing: Text(
                        Jiffy(time).fromNow(),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      leading: Icon(Icons.call),
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

void sortList(List contactList) {
  contactList.sort((a, b) {
    return DateTime.parse(b['check-in'])
        .compareTo(DateTime.parse(a['check-in']));
  });
}
