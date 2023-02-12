import 'package:flutter/material.dart';
import 'package:mew_mew/facts.dart';
import 'package:mew_mew/shared_preferences_manager.dart';

class AcceptedList extends StatefulWidget {
  const AcceptedList({super.key});

  @override
  State<AcceptedList> createState() => _AcceptedListState();
}

class _AcceptedListState extends State<AcceptedList> {
  List<String>? accepted;

  @override
  void initState() {
    super.initState();
    getAcceptedList();
  }

  Future<void> getAcceptedList() async {
    accepted = await getAcceptedFactsFromIds();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Accepted'),
          centerTitle: true,
        ),
        body: () {
          if (accepted == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: accepted!.length,
            itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                ),
                child: SelectableText(
                  accepted![index],
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
          );
        }());
  }
}
