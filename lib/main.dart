import 'package:flutter/material.dart';

import 'package:mobil/screens/download.dart';
import 'package:mobil/screens/sharelink.dart';
import 'package:mobil/screens/upload.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});
  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  String? userId;
  @override
  void initState() {
    super.initState();
    _retrieveData(); // Uygulama başladığında çağrılacak fonksiyon
  }

  Future<void> _retrieveData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        userId = prefs.getString('userId');
      });
      if (userId == null) {
        String userId = await fetchUserId();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', userId);
        setState(() {
          userId = userId;
        });
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blueAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.upload),
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          NavigationDestination(
            icon: Icon(Icons.download),
            label: 'Download',
          ),
          NavigationDestination(
            icon: Icon(Icons.share),
            label: 'Share Link',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        const Center(
          child: Upload(
            key: Key('upload'),
          ),
        ),

        /// Notifications page

        const Center(
            child: Download(
          key: Key('download'),
        )),

        /// Messages page
        ///
        const Center(
            child: ShareLink(
          key: Key('download'),
        )),
      ][currentPageIndex],
    );
  }
}

Future<String> fetchUserId() async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/api/v1/user-id'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
