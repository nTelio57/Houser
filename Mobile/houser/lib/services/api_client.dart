import 'package:houser/extensions/int_extensions.dart';
import 'package:http/http.dart' as http;

class ApiResponse{
  ApiResponse(this.body, this.statusCode, this.reasonPhrase);

  String body;
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

  Future<ApiResponse> Get<T>(String path, {String contentType = 'application/json; charset=UTF-8'}) async
  {
    final response = await http.get(Uri.https(apiUrl, path),
      headers: {
        'Content-Type': contentType,
        'Authorization': 'bearer ' + jwtToken,
      }
    );

    if(response.statusCode.isSuccessStatusCode)
      {

        return ApiResponse(response.body, response.statusCode, response.reasonPhrase);
      }
    else
      {
        print('Failed to GET ${T.toString()}. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}.');
        return ApiResponse(response.body, response.statusCode, response.reasonPhrase);
      }
  }

}

