import 'package:flutter/material.dart';
import 'package:mew_mew/facts.dart';

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
  String? fact;

  Future getNewFact() async {
    Map<String, dynamic>? json = await getRandomFact();

    setState(() {
      fact = json!["text"];
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
          fact == null
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(fact!),
                ),
          ElevatedButton(
              onPressed: getNewFact, child: const Text("get new mew mew fact"))
        ]),
      ),
    );
  }
}
