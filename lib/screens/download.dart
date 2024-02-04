import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobil/model/image.dart';
import 'package:http/http.dart' as http;

class Download extends StatefulWidget {
  const Download({Key? key}) : super(key: key);

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  final TextEditingController _linkController = TextEditingController();
  List<String> images = [];

  Future<UserImages> getImage(BuildContext context, String url) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? userId = prefs.getString('userId');

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/v1/image/$url'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      UserImages userImages = UserImages.fromJson(data);

      return userImages;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        title: const Text(
          'Download',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (images.isEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _linkController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter the link',
                  ),
                ),
              ),
            if (images.isEmpty)
              ElevatedButton(
                onPressed: () {
                  String enteredLink = _linkController.text;
                  getImage(context, enteredLink).then((value) => {
                        setState(() {
                          images = value.images;
                        })
                      });
                },
                child: const Text(
                  'Download',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (images.isNotEmpty)
              SizedBox(
                height: 600,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.memory(
                        base64Decode(images[index]),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
