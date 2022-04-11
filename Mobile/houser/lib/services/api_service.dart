import 'package:flutter/foundation.dart';
import 'package:houser/extensions/int_extensions.dart';
import 'package:houser/models/AuthRequest.dart';
import 'package:houser/models/AuthResult.dart';
import 'package:houser/models/Image.dart';
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
        kDebugMode ? '10.0.2.2:5001' : 'houser-app-ktu.herokuapp.com',
      );

  ApiClient _apiClient;
  String get apiUrl => _apiClient.apiUrl;

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

  Future<List<Image>> GetAllImagesByUserId(String id) async
  {
    ApiResponse response = await _apiClient.Get('/api/Image/user/$id');
    List<dynamic> jsonData = response.body;
    final parsed = jsonData.cast<Map<String, dynamic>>();

    return parsed.map<Image>((e) => Image.fromJson(e)).toList();
  }

  Future<ApiResponse> PostUserImage(String path) async
  {
    ApiResponse response = await _apiClient.PostImage('/api/Image/user', path);
    return response;
  }

  Future<ApiResponse> PostOfferImage(String path, int offerId) async
  {
    ApiResponse response = await _apiClient.PostImage('/api/Image/offer/$offerId', path);
    return response;
  }

  Future<bool> UpdateImage(int id, Image image) async
  {
    ApiResponse response = await _apiClient.Put('/api/Image/$id', image);
    return response.statusCode.isSuccessStatusCode;
  }

  Future<bool> DeleteImage(int id) async
  {
    ApiResponse response = await _apiClient.Delete('/api/Image/$id');
    return response.statusCode.isSuccessStatusCode;
  }

  Future<bool> UpdateOfer(int id, Offer offer) async
  {
    ApiResponse response = await _apiClient.Put('/api/Offer/$id', offer);
    return response.statusCode.isSuccessStatusCode;
  }

  Future<bool> DeleteOffer(int id) async
  {
    ApiResponse response = await _apiClient.Delete('/api/Offer/$id');
    return response.statusCode.isSuccessStatusCode;
  }

}