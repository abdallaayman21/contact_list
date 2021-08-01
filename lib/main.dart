import 'package:contact_list/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ContactList());
}

class ContactList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        // appBarTheme: Theme.of(context)
        //     .appBarThem
      ),
      home: HomeScreen(title: 'Contact List'),
    );
  }
}
