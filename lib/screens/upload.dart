// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
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
                height: 600,
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
              ElevatedButton(
                onPressed: () {
                  createAlbum(base64Image)
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

Future<http.Response> createAlbum(List<String> titles) {
  return http.post(
    Uri.parse('http://localhost:3000/api/v1/image'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'images': titles,
    }),
  );
}
