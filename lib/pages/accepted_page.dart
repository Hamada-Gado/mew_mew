import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mew_mew/api_requests/facts.dart';
import 'package:mew_mew/exceptions/socket_exception.dart';
import 'package:mew_mew/exceptions/status_exception.dart';
import 'package:mew_mew/list_fact.dart';

class AcceptedList extends StatefulWidget {
  const AcceptedList({super.key});

  @override
  State<AcceptedList> createState() => _AcceptedListState();
}

class _AcceptedListState extends State<AcceptedList> {
  List<Map<String, dynamic>>? accepted;
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = getAcceptedList();
  }

  Future<void> getAcceptedList() async {
    setState(() {});
    await getAcceptedFactsFromIds()
        .then((value) => accepted = value)
        .catchError((e) => throw e, test: (e) => e is SocketException)
        .catchError((e) => throw e, test: (e) => e is StatusException);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Accepted'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              if (snapshot.error is SocketException) {
                return SocketExceptionW(
                  retry: () {
                    _future = getAcceptedList();
                  },
                );
              }
              if (snapshot.error is StatusException) {
                var error = snapshot.error as StatusException;
                return StatusExceptionW(
                  statusCode: error.statusCode,
                  retry: () {
                    _future = getAcceptedList();
                  },
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: accepted!.length,
                  itemBuilder: (context, index) =>
                      ListFact(json: accepted![index]));
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
