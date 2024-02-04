import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:mobil/model/image.dart';
import 'package:http/http.dart' as http;
import 'package:mobil/screens/list_image_to_dowloadn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareLink extends StatefulWidget {
  const ShareLink({Key? key}) : super(key: key);

  @override
  State<ShareLink> createState() => _ShareLinkState();
}

class _ShareLinkState extends State<ShareLink> {
  @override
  initState() {
    super.initState();
    _listImages(context);
  }

  var userImagesList = List<UserImages>.from([]);
  Future<void> _listImages(BuildContext context) async {
    try {
      userImagesList = await listImages(context);
      for (var userImages in userImagesList) {
        print('Image URL: ${userImages.imageUrl}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
        body: Center(
            child: ListView.builder(
          itemCount: userImagesList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListImagesToDownload(
                            images: userImagesList[index].images),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userImagesList[index].linker_name ?? '',
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              )),
                          ElevatedButton(
                            onPressed: () {
                              String imageUrl =
                                  userImagesList[index].imageUrl ??
                                      ''; // Get the image URL
                              Clipboard.setData(ClipboardData(
                                  text:
                                      imageUrl)); // Copy the URL to the clipboard
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Image URL copied to clipboard'),
                                ),
                              );
                            },
                            child: const Text('Copy  Link'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        )));
  }
}

Future<List<UserImages>> listImages(BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    final response = await http.get(
      Uri.parse('http://localhost:3000/api/v1/images/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    List<UserImages> userImagesList = List<UserImages>.from(
      json.decode(response.body).map((model) => UserImages.fromJson(model)),
    );

    // Kullanım örneği

    return userImagesList;
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    throw e; // Rethrow the exception if needed
  }
}
