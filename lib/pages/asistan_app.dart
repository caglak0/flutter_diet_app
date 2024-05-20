import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Medica\'ya Sor   👩‍💻'),
          backgroundColor: const Color.fromARGB(255, 107, 132, 222),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/background.jpg"), // Görsel dosyasının yolunu buraya yazın
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // İçerik
            Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length,
                  ),
                ),
                const Divider(height: 1.0),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          onSubmitted: _handleSubmitted,
                          style: const TextStyle(fontSize: 18.0),
                          decoration: const InputDecoration(
                            hintText: "Mesajınızı buraya yazın...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () => _handleSubmitted(_textController.text),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 72, 104, 219),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.send, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmitted(String text) async {
    _textController.clear();
    _addMessage(text, true);
    final response = await _sendMessageToAPI(text);
    if (response != null) {
      final botReply = response['choices'][0]['message']['content'];
      _addMessage(botReply, false);
    } else {
      _addMessage('Sunucudan yanıt alınamadı.', false);
    }
  }

  Future<Map<String, dynamic>?> _sendMessageToAPI(String message) async {
    try {
      final url = Uri.parse('https://api.openai.com/v1/chat/completions');
      const apiKey = 'sk-proj-FWF9aes53umxjub5Tlx2T3BlbkFJasHiApBY4ngkxeLswCJ2';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };
      final body = json.encode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": message}
        ],
        "temperature": 0.7
      });

      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Yanıt alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }

  void _addMessage(String text, bool isUser) {
    final message = ChatMessage(text: text, isUser: isUser);
    setState(() {
      _messages.insert(0, message);
    });
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.isUser});

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          if (!isUser) ...[
            const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 72, 104, 219),
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 10),
          ],
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isUser
                  ? const Color.fromARGB(255, 251, 255, 254)
                  : const Color.fromARGB(222, 122, 193, 255),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12.0),
                topRight: const Radius.circular(12.0),
                bottomLeft: Radius.circular(isUser ? 12.0 : 0),
                bottomRight: Radius.circular(isUser ? 0 : 12.0),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 16.0, color: Color.fromARGB(255, 30, 29, 29)),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 10),
            const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 72, 104, 219),
              child: Icon(Icons.person, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
