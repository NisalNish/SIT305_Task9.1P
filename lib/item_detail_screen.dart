import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class ItemDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Calculate the time difference
    final DateTime itemDate = DateFormat('yyyy-MM-dd').parse(item['date']);
    final int daysAgo = DateTime.now().difference(itemDate).inDays;

    // Common button style
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black),
        ),
        fixedSize: const Size(250, 50),
        backgroundColor: const Color(0xFFE0E0E0),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: ${item['name']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Date: ${daysAgo == 0 ? 'Today' : '$daysAgo days ago'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Location: ${item['location']}', style: TextStyle(fontSize: 16)),
            Spacer(),
            Center(  // Wrap the button with Center
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await DatabaseHelper.instance.delete(item['id']);
                    Navigator.pop(context, true); // Indicates successful deletion
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Failed to delete item: $e')));
                  }
                },
                style: buttonStyle,
                child: const Text('Remove Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// TODO Implement this library.