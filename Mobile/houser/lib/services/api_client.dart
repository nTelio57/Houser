import 'dart:convert';

import 'package:houser/extensions/int_extensions.dart';
import 'package:http/http.dart' as http;

class ApiResponse{
  ApiResponse(this.body, this.statusCode, this.reasonPhrase);

  dynamic body;
  int? statusCode;
  String? reasonPhrase;
}

class ApiClient{

  String apiUrl;
  String jwtToken;

  ApiClient(this.apiUrl, {this.jwtToken = ''});

  void SetJWTToken(String token)
  {
    jwtToken = token;
  }

  Map<String, String> getHeaders(String contentType)
  {
    return {
      'Content-Type': contentType,
      'Authorization': 'bearer ' + jwtToken,
    };
  }


  Future<ApiResponse> Post(String path, Object body, {String contentType = 'application/json; charset=UTF-8'}) async
  {
    final response = await http.post(Uri.https(apiUrl, path),
      headers: getHeaders(contentType),
      body: json.encode(body)
    );

    if(response.statusCode.isSuccessStatusCode)
    {
      return ApiResponse(json.decode(response.body), response.statusCode, response.reasonPhrase);
    }
    else
    {
      print('Failed to POST. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}.');
      return ApiResponse(json.decode(response.body), response.statusCode, response.reasonPhrase);
    }
  }

  Future<ApiResponse> Get(String path, {String contentType = 'application/json; charset=UTF-8'}) async
  {
    final response = await http.get(Uri.https(apiUrl, path),
      headers: getHeaders(contentType)
    );

    if(response.statusCode.isSuccessStatusCode)
      {
        return ApiResponse(json.decode(response.body), response.statusCode, response.reasonPhrase);
      }
    else
      {
        print('Failed to GET. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}.');
        return ApiResponse(json.decode(response.body), response.statusCode, response.reasonPhrase);
      }
  }

}

