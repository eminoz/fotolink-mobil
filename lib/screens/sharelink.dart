import 'package:flutter/material.dart';

class ShareLink extends StatelessWidget {
  const ShareLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        title: const Text(
          'Share Link',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Center(
        child: Text('There is nothing to share yet!'),
      ),
    );
  }
}
