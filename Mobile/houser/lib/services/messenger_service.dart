import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:houser/utils/current_login.dart';
import 'package:signalr_core/signalr_core.dart';

class MessengerService{

  static final MessengerService _singleton = MessengerService._internal();
  factory MessengerService(){
    return _singleton;
  }
  MessengerService._internal(){
    connection = HubConnectionBuilder()
      .withUrl(
        kDebugMode ? 'https://10.0.2.2:5004/messenger' : 'houser-app-ktu.herokuapp.com',
        HttpConnectionOptions(
          logging: (level, message) => print(message),
          accessTokenFactory: () => Future.value(CurrentLogin().jwtToken)
        )
    )
    .withAutomaticReconnect([2000, 5000, 10000, 20000])
    .build();
  }

  late HubConnection connection;


  init(BuildContext context) async{

    if(connection.state == HubConnectionState.connected) {
      return;
    }
    await connection.start();
    await login();

    connection.on("ReceiveMessage", (arguments) {receiveMessage(arguments);});
  }

  closeConnection(BuildContext context) async{
    if(connection.state == HubConnectionState.connected)
      {
        await connection.stop();
      }
  }

  login() async
  {
    await connection.invoke("Login", args: [CurrentLogin().user!.id]);
  }

  sendMessage(int matchId, String userId, String message) async{
    await connection.invoke("SendMessage", args: [matchId, userId, message]);
  }

  receiveMessage(List<dynamic>? params) async{
    print(params);
    if(params == null) {
      return;
    }
    var matchId = params[0];
    var userId = params[1];
    var message = params[2];
    print('Message received from: $userId in $matchId that says: $message');
  }
}