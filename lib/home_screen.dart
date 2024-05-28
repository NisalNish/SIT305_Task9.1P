import 'package:flutter/material.dart';
import 'create_advert_screen.dart';  // Assuming you have this file for creating adverts
import 'show_items_screen.dart';      // Assuming you have this file for showing items
import 'map_screen.dart';             // Assuming you have this file for the map screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a common style for the buttons
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Adjusts the curvature of the button edges
        side: const BorderSide(color: Colors.black), // Adds a border around the button
      ),
      fixedSize: const Size(250, 50), // Sets a fixed width and height for both buttons
      padding: const EdgeInsets.symmetric(horizontal: 16), // Optional: Adjust padding if needed
      backgroundColor: const Color(0xFFE0E0E0), // Gray color background for the buttons
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost & Found Map'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateNewAdvertScreen()), // Navigate to the CreateNewAdvertScreen
                );
              },
              style: buttonStyle, // Apply the custom style
              child: const Text('Create a New Advert'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShowItemsScreen()), // Navigate to the ShowItemsScreen
                );
              },
              style: buttonStyle, // Apply the same custom style
              child: const Text('Show all Lost & Found Items'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()), // Navigate to the MapScreen
                );
              },
              style: buttonStyle, // Apply the same custom style
              child: const Text('Show On Map'),
            ),
          ],
        ),
      ),
    );
  }
}
