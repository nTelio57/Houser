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
        jwtToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJhZG1pbkBnbWFpbC5jb20iLCJqdGkiOiIyNjEyY2IwZC02NDYxLTRjOGYtODk0OC04MDZhNWNkMTBiYjUiLCJ1c2VySWQiOiI1NzA0NTdiYy01MWE2LTQ3ZDctOTBhMS1jYzNjZDE1OTg1NjMiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOlsiQWRtaW4iLCJCYXNpYyJdLCJleHAiOjE2NTEwOTY0NDYsImlzcyI6IkhvdXNlckFQSSIsImF1ZCI6IlRydXN0ZWRDbGllbnQifQ.fR3Q5O_wbFHCqYU8sVwlvEX5lFg_7kSS83v2k4m6Q8o"
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

}