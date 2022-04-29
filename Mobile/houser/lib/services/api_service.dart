import 'package:flutter/foundation.dart';
import 'package:houser/enums/FilterType.dart';
import 'package:houser/extensions/int_extensions.dart';
import 'package:houser/models/AuthRequest.dart';
import 'package:houser/models/AuthResult.dart';
import 'package:houser/models/Filter.dart';
import 'package:houser/models/Image.dart';
import 'package:houser/models/Message.dart';
import 'package:houser/models/Room.dart';
import 'package:houser/models/RoomFilter.dart';
import 'package:houser/models/Swipe.dart';
import 'package:houser/models/Match.dart';
import 'package:houser/models/User.dart';
import 'package:houser/models/UserFilter.dart';
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

  Future<Room> GetRoomById(int id) async{
    ApiResponse response = await _apiClient.Get('/api/Room/$id');
    return Room.fromJson(response.body);
  }

  Future<List<Room>> GetRoomsByUser(String id) async{
    ApiResponse response = await _apiClient.Get('/api/Room/user/$id');

    List<dynamic> jsonData = response.body;
    final parsed = jsonData.cast<Map<String, dynamic>>();

    return parsed.map<Room>((e) => Room.fromJson(e)).toList();
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

  Future<ApiResponse> PostRoom(Room room) async
  {
    ApiResponse response = await _apiClient.Post('/api/Room', room.toJson());
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

  Future<ApiResponse> PostRoomImage(String path, int roomId) async
  {
    ApiResponse response = await _apiClient.PostImage('/api/Image/room/$roomId', path);
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

  Future<bool> UpdateOfer(int id, Room room) async
  {
    ApiResponse response = await _apiClient.Put('/api/Room/$id', room);
    return response.statusCode.isSuccessStatusCode;
  }

  Future<bool> DeleteRoom(int id) async
  {
    ApiResponse response = await _apiClient.Delete('/api/Room/$id');
    return response.statusCode.isSuccessStatusCode;
  }

  Future<List<Room>> GetRoomRecommendationByFilter(int count, int offset, RoomFilter filter) async
  {
    ApiResponse response = await _apiClient.Post('/api/Recommendation/room/$count/$offset', filter);
    List<dynamic> jsonData = response.body;
    final parsed = jsonData.cast<Map<String, dynamic>>();
    return parsed.map<Room>((e) => Room.fromJson(e)).toList();
  }

  Future<List<User>> GetUserRecommendationByFilter(int count, int offset, UserFilter filter) async
  {
    ApiResponse response = await _apiClient.Post('/api/Recommendation/user/$count/$offset', filter);
    List<dynamic> jsonData = response.body;
    final parsed = jsonData.cast<Map<String, dynamic>>();
    return parsed.map<User>((e) => User.fromJson(e)).toList();
  }

  Future<Filter?> GetUsersFilter(String id) async{
    ApiResponse response = await _apiClient.Get('/api/Filter/$id');
    if(!response.statusCode.isSuccessStatusCode) {
      return null;
    }

    var filterType = Filter.fromJson(response.body).filterType;
    switch(filterType)
    {
      case FilterType.room:
        return RoomFilter.fromJson(response.body);
      case FilterType.user:
        return UserFilter.fromJson(response.body);
      default:
        return null;
    }
  }

  Future<ApiResponse> PostFilter(Filter filter) async
  {
    switch(filter.filterType)
    {
      case FilterType.room:
        ApiResponse response = await _apiClient.Post('/api/Filter/room', filter.toJson());
        return response;
      case FilterType.user:
        ApiResponse response = await _apiClient.Post('/api/Filter/user', filter.toJson());
        return response;
      default:
        ApiResponse response = await _apiClient.Post('/api/Filter/room', filter.toJson());
        return response;
    }
  }

  Future<ApiResponse> PostSwipe(Swipe swipe) async
  {
    ApiResponse response = await _apiClient.Post('/api/Match/swipe', swipe.toJson());
    return response;
  }

  Future<List<Match>> GetMatchesByUser(String id) async{
    ApiResponse response = await _apiClient.Get('/api/Match/user/$id');

    List<dynamic> jsonData = response.body;
    final parsed = jsonData.cast<Map<String, dynamic>>();

    return parsed.map<Match>((e) => Match.fromJson(e)).toList();
  }

  Future<bool> UpdateUserVisibility(String id, bool visibility) async
  {
    int visibilityInt = visibility ? 1 : 0;
    ApiResponse response = await _apiClient.Put('/api/User/visibility/$id/$visibilityInt', '');
    return response.statusCode.isSuccessStatusCode;
  }

  Future<List<Message>> GetMessagesByMatch(int id) async{
    ApiResponse response = await _apiClient.Get('/api/Message/match/$id');

    List<dynamic> jsonData = response.body;
    final parsed = jsonData.cast<Map<String, dynamic>>();

    return parsed.map<Message>((e) => Message.fromJson(e)).toList();
  }

  Future<bool> DeleteMatch(int id) async
  {
    ApiResponse response = await _apiClient.Delete('/api/Match/$id');
    return response.statusCode.isSuccessStatusCode;
  }
}