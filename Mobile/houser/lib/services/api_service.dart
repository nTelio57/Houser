import 'package:houser/extensions/int_extensions.dart';
import 'package:houser/models/AuthRequest.dart';
import 'package:houser/models/AuthResult.dart';
import 'package:houser/models/Offer.dart';
import 'package:houser/models/User.dart';
import 'package:houser/services/api_client.dart';

class ApiService {

  static final ApiService _singleton = ApiService._internal();
  factory ApiService(){
    return _singleton;
  }

  ApiService._internal() :
      _apiClient = ApiClient(
        '10.0.2.2:5001',
      );

  ApiClient _apiClient;

  Future<User> GetUserById(String id) async{
    ApiResponse response = await _apiClient.Get('/api/User/$id');
    return User.fromJson(response.body);
  }

  Future<Offer> GetOfferById(int id) async{
    ApiResponse response = await _apiClient.Get('/api/Offer/$id');
    return Offer.fromJson(response.body);
  }

  Future<List<Offer>> GetOffersByUser(String id) async{
    ApiResponse response = await _apiClient.Get('/api/Offer/user/$id');

    List<dynamic> jsonData = response.body;
    final parsed = jsonData.cast<Map<String, dynamic>>();

    return parsed.map<Offer>((e) => Offer.fromJson(e)).toList();
  }

  Future<AuthResult> Login(AuthRequest authRequest) async{
    ApiResponse response = await _apiClient.Post('/api/Auth/login', authRequest.toJson());
    return AuthResult.fromJson(response.body);
  }

  Future<AuthResult> Register(AuthRequest authRequest) async{
    ApiResponse response = await _apiClient.Post('/api/Auth/register', authRequest.toJson());
    return AuthResult.fromJson(response.body);
  }

  Future<bool> UpdateUserDetails(String id, User newDetails) async
  {
    ApiResponse response = await _apiClient.Put('/api/User/$id', newDetails.toJson());
    return response.statusCode.isSuccessStatusCode;
  }

  Future<ApiResponse> PostOffer(Offer offer) async
  {
    ApiResponse response = await _apiClient.Post('/api/Offer', offer.toJson());
    return response;
  }

}