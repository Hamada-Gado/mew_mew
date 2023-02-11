import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mew_mew/facts.dart' hide BASE_URL;

import 'package:mew_mew/images.dart';

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

  Future<void> getRandomFactAndImage() async {
    setState(() {
      json = image = null;
    });

    Future<Map<String, dynamic>> decodedJsonFuture = getRandomFact();
    Future<Uint8List> bytesImageFuture = getRandomImage();

    Map<String, dynamic> decodedJson = await decodedJsonFuture;
    Uint8List bytesImage = await bytesImageFuture;

    setState(() {
      image = Image.memory(
        bytesImage,
        fit: BoxFit.fitWidth,
      );
      json = decodedJson;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mew mew'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          image == null
              ? const Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(), child: image!)),
          json == null || json!['text'] == null
              ? const Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: ListFact(
                        fact: json!['text'],
                        verified: json?['status']['verified']),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 15),
            child: ElevatedButton(
                onPressed: getRandomFactAndImage,
                child: const Text("get random mew mew fact")),
          )
        ]),
      ),
    );
  }
}

class ListFact extends StatelessWidget {
  final String fact;
  final bool? verified;

  const ListFact({required this.fact, required this.verified, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
