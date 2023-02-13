import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:mew_mew/api_requests/images.dart';
import 'package:mew_mew/api_requests/facts.dart';
import 'package:mew_mew/shared_preferences_manager.dart';

import 'package:mew_mew/list_fact.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? json;
  Uint8List? imageBytes;
  late bool socketException;

  @override
  void initState() {
    super.initState();
    socketException = false;
    setRandomImageAndFact();
  }

  Future<void> setRandomImageAndFact() async {
    setState(() {
      json = imageBytes = null;
    });

    Future<Uint8List> bytesImageFuture = getRandomImage();
    Future<Map<String, dynamic>> decodedJsonFuture = getRandomFact();

    try{
      imageBytes = await bytesImageFuture;
      json = await decodedJsonFuture;
    } on SocketException {
      socketException = true;
    }

    setState(() {});
  }

  void saveImage() {
    if (imageBytes == null) return;

    ImageGallerySaver.saveImage(imageBytes!);
  }

  List<Widget> onSocketException(BuildContext context) {
    return [
      Card(
        child: Text(
          "An error ocurred, the reason might be that their is no internet connection. Check your internet connection and try again.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      ElevatedButton(
          onPressed: () {
            socketException = false;
            setRandomImageAndFact();
          },
          child: const Text("Retry"))
    ];
  }

  List<Widget> imageAndFact() {
    if (imageBytes == null || json == null) {
      return [
        const Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        )
      ];
    }
    return [
      Expanded(
          flex: 2,
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Image.memory(imageBytes!, fit: BoxFit.fitWidth))),
      Expanded(
        flex: 1,
        child: SingleChildScrollView(
          child: Dismissible(
              key: Key(json!['_id']),
              background: Container(color: Colors.red),
              secondaryBackground: Container(color: Colors.green),
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  savePrefs(Mode.rejected.value, json!['_id']);
                  setRandomImageAndFact();
                } else {
                  savePrefs(Mode.accepted.value, json!['_id']);
                  setRandomImageAndFact();
                }
              },
              child: () {
                return ListFact(json: json!);
              }()),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 15),
        child: ElevatedButton(
            onPressed: saveImage, child: const Text("Save Image")),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mew Mew',
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed("accepted list"),
                  child: const Text("Accepted List")),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ...() {
            if (socketException) {
              return onSocketException(context);
            }
            return imageAndFact();
          }()
        ]),
      ),
    );
  }
}
