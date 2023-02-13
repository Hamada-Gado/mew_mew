import 'package:flutter/material.dart';
import 'package:mew_mew/api_requests/facts.dart';
import 'package:mew_mew/list_fact.dart';

class AcceptedList extends StatefulWidget {
  const AcceptedList({super.key});

  @override
  State<AcceptedList> createState() => _AcceptedListState();
}

class _AcceptedListState extends State<AcceptedList> {
  List<Map<String, dynamic>>? accepted;

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
              itemBuilder: (context, index) =>
                  ListFact(json: accepted![index]));
        }());
  }
}
