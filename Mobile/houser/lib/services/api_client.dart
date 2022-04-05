import 'dart:convert';
import 'dart:io';

import 'package:houser/extensions/int_extensions.dart';
import 'package:houser/models/CurrentLogin.dart';
import 'package:http/http.dart' as http;

class ApiResponse{
  ApiResponse(this.body, this.statusCode, this.reasonPhrase);

  dynamic body;
  int statusCode;
  String? reasonPhrase;
}

class ApiClient{

  String apiUrl;
  ApiClient(this.apiUrl);

  Map<String, String> getHeaders(String contentType)
  {
    return {
      'Content-Type': contentType,
      'Authorization': 'bearer ' + CurrentLogin().jwtToken,
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

  Future<ApiResponse> Delete(String path, {String contentType = 'application/json; charset=UTF-8'}) async
  {
    final response = await http.delete(Uri.https(apiUrl, path),
        headers: getHeaders(contentType)
    );

    if(response.statusCode.isSuccessStatusCode)
    {
      return ApiResponse(response.statusCode.isSuccessStatusCode, response.statusCode, response.reasonPhrase);
    }
    else
    {
      print('Failed to DELETE. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}.');
      return ApiResponse(response.statusCode.isSuccessStatusCode, response.statusCode, response.reasonPhrase);
    }
  }

  Future<ApiResponse> Put(String path, Object body, {String contentType = 'application/json; charset=UTF-8'}) async
  {
    final response = await http.put(Uri.https(apiUrl, path),
        headers: getHeaders(contentType),
        body: json.encode(body)
    );

    if(response.statusCode.isSuccessStatusCode)
    {
      return ApiResponse(response.statusCode.isSuccessStatusCode, response.statusCode, response.reasonPhrase);
    }
    else
    {
      print('Failed to PUT. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}.');
      return ApiResponse(response.statusCode.isSuccessStatusCode, response.statusCode, response.reasonPhrase);
    }
  }

  Future<ApiResponse> PostImage(String path, String imagePath) async
  {
    var request = http.MultipartRequest('POST', Uri.https(apiUrl, path));
    request.headers['Authorization'] = 'bearer ' + CurrentLogin().jwtToken;
    request.files.add(await http.MultipartFile.fromPath(
        'image',
        imagePath
    ));
    var response = await request.send();

    if(response.statusCode.isSuccessStatusCode)
    {
      return ApiResponse(true, response.statusCode, response.reasonPhrase);
    }
    else
    {
      print('Failed to POST image. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}.');
      return ApiResponse(false, response.statusCode, response.reasonPhrase);
    }
  }

}

