// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mobil/main.dart';
import 'package:mobil/model/image.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final TextEditingController _linkerName = TextEditingController();
  List<XFile>? images = [];
  List<String> base64Image = [];
  final ImagePicker picker = ImagePicker();
  Future<String> imageToBase64(String imagePath) async {
    // Resmi oku
    File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();
    // Base64'e çevir
    String base64String = base64Encode(imageBytes);
    return base64String;
  }

  Future getImages(ImageSource media) async {
    var pickedImages = await picker.pickMultiImage(
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 100,
    );
    setState(() {
      if (pickedImages != null) {
        images = pickedImages;
      }
      //images to base64
      for (var i = 0; i < images!.length; i++) {
        imageToBase64(images![i].path).then((value) {
          base64Image.add(value);
        });
      }
    });
  }

  void myAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('Please choose media to select'),
          content: Container(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getImages(ImageSource.gallery);
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.image),
                      Text('From Gallery'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getImages(ImageSource.camera);
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.camera),
                      Text('From Camera'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Image',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[500],
      ),
      body: Center(
        child: Column(
          children: [
            if (!base64Image.isNotEmpty)
              FloatingActionButton.large(
                onPressed: () {
                  myAlert();
                },
                child: Icon(Icons.add_a_photo),
              ),
            const SizedBox(
              height: 10,
            ),
            if (base64Image.isNotEmpty)
              Container(
                height: 500,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: base64Image.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.memory(
                        base64Decode(base64Image[index]),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            if (base64Image.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _linkerName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter the link',
                  ),
                ),
              ),
            if (base64Image.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  createImage(context, base64Image, _linkerName.text)
                      .then((value) => {
                            setState(() {
                              base64Image = [];
                            })
                          })
                      .catchError((error) => print(error));
                },
                child: Text('Upload Photo'),
              )
          ],
        ),
      ),
    );
  }
}

class Images {
  final String? user_id;
  final String? linker_name;
  final List<String> images;

  Images({this.user_id, required this.images, this.linker_name});

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'images': images,
      'linker_name': linker_name,
    };
  }
}

Future<http.Response> createImage(
    BuildContext context, List<String> images, String linkerName) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/v1/image'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(Images(
        user_id: userId,
        images: images,
        linker_name: linkerName,
      )),
    );

    if (response.statusCode == 200) {
      // Successful response
      print('Success: ${response.body}');
    } else {
      // Handle error response
      print('Error: ${response.statusCode}, ${response.body}');
    }

    return response;
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    throw e; // Rethrow the exception if needed
  }
}
