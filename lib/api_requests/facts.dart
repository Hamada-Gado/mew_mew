import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mew_mew/exceptions/status_exception.dart';
import 'package:mew_mew/shared_preferences_manager.dart';

/*
{
  "status" : {"verified": bool,"sentCount": int},
  "_id" : String,
  "__v" : int,
  "text" : String,
  "source" : String,
  "updateAt" : DateTime,
  "type" : String,
  "createdAt" : String,
  "deleted" : bool,
  "used" : bool,
  "user" : Map | String,
} 
*/
const String BASE_URL = "cat-fact.herokuapp.com";

Future<Map<String, dynamic>> getRandomFact() async {
  Uri url = Uri.https(BASE_URL, "facts/random");
  Future<http.Response> responseFuture = http.get(url);
  Future<List<String>> rejectedListFuture = loadPrefs(Mode.rejected.value);
  Future<List<String>> acceptedListFuture = loadPrefs(Mode.accepted.value);

  List<String> rejectedList = await rejectedListFuture;
  List<String> acceptedList = await acceptedListFuture;
  List<String> loadedList = rejectedList..addAll(acceptedList);

  http.Response response;

  try {
    response = await responseFuture;
  } on SocketException {
    rethrow;
  }

  if (response.statusCode == 200) {
    Map<String, dynamic> decodedJson = jsonDecode(response.body);
    if (loadedList.every((element) => element != decodedJson['_id'])) {
      return decodedJson;
    } else {
      return getRandomFact();
    }
  }

  throw StatusException(response.statusCode);
}

Future<List<Map<String, dynamic>>> getAcceptedFactsFromIds() async {
  http.Client client = http.Client();
  List<String> ids = await loadPrefs(Mode.accepted.value);

  List<Map<String, dynamic>> results = [];
  List<Future<http.Response>> responseFuture = [];
  Uri url;

  try {
    for (int i = 0; i < ids.length; i++) {
      url = Uri.https(BASE_URL, "facts/${ids[i]}");
      responseFuture.add(client.get(url));
    }

    http.Response response;

    for (int i = 0; i < ids.length; i++) {
      response = await responseFuture[i];
      results.add(jsonDecode(response.body));
    }

    return results;
  } finally {
    client.close();
  }
}
