import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mew_mew/api_requests/facts.dart';
import 'package:mew_mew/exceptions/socket_exception.dart';
import 'package:mew_mew/exceptions/status_exception.dart';
import 'package:mew_mew/list_fact.dart';

import 'package:connectivity_plus/connectivity_plus.dart' as connectivity;

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

    if (await connectivity.Connectivity().checkConnectivity() ==
        connectivity.ConnectivityResult.none) {
      return Future.error(const SocketException("No internet connection"));
    }

    try {
      accepted = await getAcceptedFactsFromIds();
    } on SocketException catch (e) {
      return Future.error(e);
    } on StatusException catch (e) {
      return Future.error(e);
    }
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
              var error = snapshot.error;
              if (error is SocketException) {
                return SocketExceptionW(
                  message: error.message,
                  retry: () {
                    _future = getAcceptedList();
                  },
                );
              }
              if (error is StatusException) {
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
