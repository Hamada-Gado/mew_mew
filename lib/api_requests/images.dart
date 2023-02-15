import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mew_mew/exceptions/status_exception.dart';

/*
/cat or /c
/says or /s

/cat -- Will return a random cat

/cat/:tag -- Will return a random cat with a :tag

/cat/gif -- Will return a random gif cat \\o/

/cat/says/:text -- Will return a random cat saying :text

/cat/:tag/says/:text -- Will return a random cat with a :tag and saying :text

/cat?type=:type -- Will return a random cat with image :type (small or sm, medium or md, square or sq, original or or)

/cat?filter=:filter -- Will return a random cat with image filtered by :filter (blur, mono, sepia, negative, paint, pixel)

/cat?width=:width or /cat?height=:height --	Will return a random cat with :width or :height
*/
const String BASE_URL = "cataas.com";

Future<Uint8List> getRandomImage() async {
  Uri url = Uri.https(BASE_URL, "cat");

  http.Response response;

  try {
    response = await http.get(url);
  } on SocketException {
    rethrow;
  }

  if (response.statusCode == 200) {
    return response.bodyBytes;
  }

  throw StatusException(response.statusCode);
}
