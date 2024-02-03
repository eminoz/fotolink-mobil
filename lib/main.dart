import 'package:flutter/material.dart';
import 'package:mobil/screens/download.dart';
import 'package:mobil/screens/sharelink.dart';
import 'package:mobil/screens/upload.dart';

/// Flutter code sample for [NavigationBar].

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
