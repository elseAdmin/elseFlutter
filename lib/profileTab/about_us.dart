import 'package:flutter/material.dart';
import 'package:else_app_two/utils/Contants.dart';

class AboutUsDetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final int index;

  // In the constructor, require a Todo.
  AboutUsDetailScreen({Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    final String textData = 'Vestibulum euismod nisl suscipit ligula volutpat, '
        +'a feugiat urna maximus. Cras massa nibh, tincidunt ut eros a, '
        +'vulputate consequat odio. Vestibulum vehicula tempor nulla, sed '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'hendrerit urna interdum in. Donec et nibh maximus, congue est eu, '
        +'mattis nunc. Praesent ut quam quis quam venenatis fringilla. Morbi '
        +'vestibulum id tellus commodo mattis. Aliquam erat volutpat. Aenean '
        +'accumsan id mi nec semper. Ut ultricies imperdiet sodales. Aliquam '
        +'fringilla aliquam ex sit amet elementum. Commodo in diam nec, '
        +'pretium auctor sapien.';


    return Scaffold(
      backgroundColor: Constants.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.titleBarBackgroundColor,
        iconTheme: IconThemeData(
          color: Constants.textColor, //change your color here
        ),
        title: Text('About Us',
            style: TextStyle(
              color: Constants.titleBarTextColor,
              fontSize: 18,
            )
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Center(
            child: Text(textData),
          ),
        ),
      ),
    );
  }
}