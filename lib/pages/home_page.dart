import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:mew_mew/api_requests/images.dart';
import 'package:mew_mew/api_requests/facts.dart';

import 'package:mew_mew/exceptions/status_exception.dart';
import 'package:mew_mew/exceptions/socket_exception.dart';

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
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = setRandomImageAndFact();
  }

  Future<void> setRandomImageAndFact() async {
    setState(() {
      json = imageBytes = null;
    });

    await Future.wait([getRandomImage(), getRandomFact()])
        .then((value) {
          imageBytes = value[0] as Uint8List;
          json = value[1] as Map<String, dynamic>;
        })
        .catchError((e) => throw e, test: (e) => e is SocketException)
        .catchError((e) => throw e, test: (e) => e is StatusException);
  }

  void saveImage() {
    if (imageBytes == null) return;

    ImageGallerySaver.saveImage(imageBytes!);
  }

  Widget imageAndFact() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  _future = setRandomImageAndFact();
                } else {
                  savePrefs(Mode.accepted.value, json!['_id']);
                  _future = setRandomImageAndFact();
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
    ]);
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
                      Navigator.of(context).pushNamed("accepted page"),
                  child: const Text("Accepted Facts")),
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (snapshot.error is SocketException) {
              return SocketExceptionW(
                retry: () {
                  _future = setRandomImageAndFact();
                },
              );
            }
            if (snapshot.error is StatusException) {
              StatusException error = snapshot.error as StatusException;
              return StatusExceptionW(
                statusCode: error.statusCode,
                retry: () {
                  _future = setRandomImageAndFact();
                },
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return imageAndFact();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
