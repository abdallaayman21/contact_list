import 'dart:convert';
import 'package:faker/faker.dart';
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
  // List users = [
  //   'Abdalla Ayman',
  //   'Ahmed Hassan',
  //   'Shady Yasser',
  //   'Mohammed Shahin',
  //   'Nabila Mohammed'
  // ];

  // List phones = [
  //   '0136737610',
  //   '0134578945',
  //   '0139789798',
  //   '0167478941',
  //   '0194571257'
  // ];

  // List checkins = [
  //   '2019-06-30 16:10:05',
  //   '2018-12-25 03:00:00',
  //   '2021-03-01 14:30:05',
  //   '2021-01-05 20:55:05',
  //   '2020-09-16 18:20:05'
  // ];

  List contactList = [];

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
                if (contactList.isEmpty)
                  contactList = json.decode(snapshot.data.toString());
                sortList(contactList);
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      for (int x = 0; x < 5; x++) {
                        contactList.add(
                          json.decode(
                            '''{
                                "user": "${faker.person.name()}",
                                "phone": "${faker.phoneNumber.random.fromPattern([
                              '01########'
                            ])}",
                                "check-in": "${faker.date.dateTime(minYear: 2015, maxYear: 2021)}"
                              }''',
                          ),
                        );
                      }

                      print(contactList);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Page Refreshed',
                        textAlign: TextAlign.center,
                      ),
                    ));
                  },
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemCount: contactList.length + 1,
                    separatorBuilder: (context, i) {
                      return Divider(
                        height: 5,
                        thickness: 1.0,
                      );
                    },
                    itemBuilder: (context, i) {
                      if (i == contactList.length) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              '- You have reached the end of the list -',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        );
                      }
                      var data = contactList[i];
                      DateTime time = DateTime.parse(data['check-in']);
                      return ListTile(
                        title: Text(data['user']),
                        subtitle: Text(data['phone']),
                        trailing: Text(
                          Jiffy(time).fromNow(),
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        leading: Icon(Icons.call),
                      );
                    },
                  ),
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
