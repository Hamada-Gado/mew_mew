import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

Future<Map<String, dynamic>?> getRandomFact() async {
  Uri url = Uri.https(BASE_URL, "facts/random");
  http.Response response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  debugPrint("Error: ${response.statusCode}");
  return null;
}
