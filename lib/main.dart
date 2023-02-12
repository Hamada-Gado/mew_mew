import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mew_mew/facts.dart';

import 'package:mew_mew/images.dart';
import 'package:mew_mew/shared_preferences_manager.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? json;
  Image? image;

  @override
  void initState() {
    super.initState();
    setRandomImageAndFact();
  }

  Future<void> setRandomImageAndFact() async {
    setState(() {
      json = image = null;
    });

    Future<Uint8List> bytesImageFuture = getRandomImage();
    Future<Map<String, dynamic>> decodedJsonFuture = getRandomFact();

    Uint8List bytesImage = await bytesImageFuture;
    Map<String, dynamic> decodedJson = await decodedJsonFuture;

    setState(() {
      image = Image.memory(
        bytesImage,
        fit: BoxFit.fitWidth,
      );
      json = decodedJson;
    });
  }

  Widget listFact(Map<String, dynamic> json) {
    String fact = json['text'];
    bool? verified = json['status']['verified'];

    return Dismissible(
      key: Key(json['_id']),
      background: Container(color: Colors.red),
      secondaryBackground: Container(color: Colors.green),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          savePrefs(Mode.rejected.value, json['_id']);
          setRandomImageAndFact();
        } else {
          savePrefs(Mode.accepted.value, json['_id']);
          setRandomImageAndFact();
        }
      },
      child: Card(
        child: ListTile(
          title: SelectableText(fact),
          trailing: Container(
            decoration: BoxDecoration(
                color: verified == null
                    ? Colors.black38
                    : verified == false
                        ? Colors.red
                        : Colors.green,
                shape: BoxShape.circle),
            child: Icon(
              verified == null
                  ? Icons.question_mark
                  : verified == false
                      ? Icons.close
                      : Icons.check,
              size: 40,
              color: Colors.white,
            ),
          ),
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  List<Widget> imageAndFact() {
    if (image == null || json == null) {
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
              physics: const BouncingScrollPhysics(), child: image!)),
      Expanded(
        flex: 1,
        child: SingleChildScrollView(
          child: listFact(json!),
        ),
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
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ...imageAndFact(),
        ]),
      ),
    );
  }
}
