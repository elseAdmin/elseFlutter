
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {

  final List<String> entries = <String>['Help', 'About', 'Share', 'Rate', 'Logout'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Center(child: Text('${entries[index]}')),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AboutUsDetailScreen(index: index),
              ),
            );
          },
        );
      },
    );
  }
}

class AboutUsDetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final int index;

  // In the constructor, require a Todo.
  AboutUsDetailScreen({Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text('About US'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Kuch bhi likh diya hai bus'),
      ),
    );
  }
}