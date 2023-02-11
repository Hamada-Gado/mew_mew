import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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

  http.Response response = await responseFuture;
  List<String> rejectedList = await rejectedListFuture;

  if (response.statusCode == 200) {
    Map<String, dynamic> decodedJson = jsonDecode(response.body);
    if (rejectedList.every((element) => element != decodedJson['_id'])) {
      return decodedJson;
    } else {
      return getRandomFact();
    }
  }

  throw Exception("Could not get random fact ${response.statusCode}");
}
