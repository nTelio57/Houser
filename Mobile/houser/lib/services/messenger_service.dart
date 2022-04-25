import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:signalr_core/signalr_core.dart';

class MessengerService{

  static final MessengerService _singleton = MessengerService._internal();
  factory MessengerService(){
    return _singleton;
  }
  MessengerService._internal(){
    connection = HubConnectionBuilder()
      .withUrl(
        kDebugMode ? 'http://10.0.2.2:5003/chathub' : 'houser-app-ktu.herokuapp.com',
        HttpConnectionOptions(
            logging: (level, message) => print(message)
        )
    ).build();
  }

  late HubConnection connection;

  init(BuildContext context) async{
    await connection.start();

    connection.on("ReceiveMessage", (arguments) {receiveMessage(arguments);});
  }

  closeConnection(BuildContext context) async{
    if(connection.state == HubConnectionState.connected)
      {
        await connection.stop();
      }
  }

  sendMessage(String userId, String message) async{
    await connection.invoke("SendMessage", args: [userId, message]);
  }

  receiveMessage(List<dynamic>? params) async{
    print(params);
    if(params == null) {
      return;
    }
    var userId = params[0];
    var message = params[1];
    print('Message received from: $userId that says: $message');
  }
}