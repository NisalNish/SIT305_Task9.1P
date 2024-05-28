import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'item_detail_screen.dart'; // Ensure this import is correct

class ShowItemsScreen extends StatefulWidget {
  const ShowItemsScreen({Key? key}) : super(key: key);

  @override
  _ShowItemsScreenState createState() => _ShowItemsScreenState();
}

class _ShowItemsScreenState extends State<ShowItemsScreen> {
  late Future<List<Map<String, dynamic>>> _items;

  @override
  void initState() {
    super.initState();
    _items = DatabaseHelper.instance.queryAllRows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost and Found Items'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('An error occurred!'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, index) {
                var item = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(item['name']),
                    subtitle: Text(item['description']),
                    trailing: Text(item['date']),
                    onTap: () async {
                      bool? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailScreen(item: item),
                        ),
                      );
                      if (result == true) {
                        setState(() {
                          _items = DatabaseHelper.instance.queryAllRows();
                        });
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
