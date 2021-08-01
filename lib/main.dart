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
      ),
      home: HomeScreen(title: 'Contact List'),
    );
  }
}
