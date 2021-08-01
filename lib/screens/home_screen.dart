import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List contactList = [];
  bool isTimeAgo = true;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      Future.microtask(() async {
        SharedPreferences storage = await SharedPreferences.getInstance();
        setState(() {
          isTimeAgo = storage.getBool('timeAgo') == null
              ? true
              : storage.getBool('timeAgo')!;
          isLoading = false;
        });
      });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                : ToggleButtons(
                    fillColor: Colors.white,
                    color: Colors.white54,
                    borderColor: Colors.white38,
                    selectedColor: Colors.indigo,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Time Ago'),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    isSelected: [isTimeAgo],
                    onPressed: (i) async {
                      setState(() {
                        isTimeAgo = !isTimeAgo;
                      });
                      SharedPreferences storage =
                          await SharedPreferences.getInstance();
                      await storage.setBool('timeAgo', isTimeAgo);
                      print(isTimeAgo);
                    },
                  ),
          ),
        ],
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
                        leading: IconButton(
                          icon: Icon(
                            Icons.share,
                            color: Colors.indigo,
                          ),
                          padding: EdgeInsets.all(0.0),
                          onPressed: () async {
                            Directory temp = await getTemporaryDirectory();

                            var vCard = File('${temp.path}/vCard.vcf');

                            await vCard.writeAsString(
                              'BEGIN:VCARD\nVERSION:3.0\nFN;CHARSET=UTF-8:${data['user']}\nN;CHARSET=UTF-8:;${data['user']};;;\nTEL;TYPE=CELL:${data['phone']}\nREV:${DateTime.now().toUtc()}\nEND:VCARD',
                            );

                            print(await vCard.readAsString());

                            await Share.shareFiles([vCard.path]);

                            await vCard.delete();

                            await temp.delete();
                          },
                        ),
                        title: Text(data['user']),
                        subtitle: Text(data['phone']),
                        trailing: Text(
                          isTimeAgo ? Jiffy(time).fromNow() : time.toString(),
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
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
