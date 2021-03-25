import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  static String domain = 'gmail.com';
  String imapServerHost = 'imap.$domain';
  int imapServerPort = 993;
  bool isImapServerSecure = true;
  String popServerHost = 'pop.$domain';
  int popServerPort = 995;
  bool isPopServerSecure = true;
  String smtpServerHost = 'smtp.$domain';
  int smtpServerPort = 465;
  bool isSmtpServerSecure = true;
  /// Low level IMAP API usage example
  Future<void> imapExample() async {
    final client = ImapClient(isLogEnabled: false);
    try {
      await client.connectToServer("imap.gmail.com", imapServerPort,
          isSecure: false);
      await client.login("you_gmail@gmail.com", "your password");
      final mailboxes = await client.listMailboxes();
      print('mailboxes: $mailboxes');
      await client.selectInbox();
      // fetch 10 most recent messages:
      final fetchResult = await client.fetchRecentMessages(
          messageCount: 10, criteria: 'BODY.PEEK[]');
      for (final message in fetchResult.messages) {
        printMessage(message);
      }
      await client.logout();
    } on ImapException catch (e) {
      print('IMAP failed with ${e.details}');
    }
  }



  void printMessage(MimeMessage message) {
    print('from: ${message.from} with subject "${message.decodeSubject()}"');
    if (!message.isTextPlainMessage()) {
      print(' content-type: ${message.mediaType}');
    } else {
      final plainText = message.decodeTextPlainPart();
      if (plainText != null) {
        final lines = plainText.split('\r\n');
        for (final line in lines) {
          if (line.startsWith('>')) {
            // break when quoted text starts
            break;
          }
          print(line);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text"),
      ),
      body: Stack(
        alignment: Alignment.center,

        children: [
          Align(
            alignment: Alignment.center,

            child: ElevatedButton(onPressed: (){
              imapExample();
            }, child: Text("SIGN IN")),
          ),
        ],
      ),
    );
  }
}

