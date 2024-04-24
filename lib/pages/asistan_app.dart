import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  final List<ChatMessage> _messages = <ChatMessage>[];

  void _handleSubmitted(String text) {
    _textController.clear();

    ChatMessage message = ChatMessage(
      text: text,
    );

    setState(() {
      _messages.insert(0, message);
    });

    // Asistanın yanıtını oluşturun
    // Bu örnekte, asistan sadece gelen mesajı tekrarlar
    // Gerçek bir uygulamada, burada bir dil modeli kullanarak daha karmaşık yanıtlar oluşturabilirsiniz
    ChatMessage botMessage = ChatMessage(
      text: text,
      isUser: false,
    );

    setState(() {
      _messages.insert(0, botMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kişisel Asistan')),
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        const Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                    hintText: "Bir Şeyler Yazın..."),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, this.isUser = true});

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.5,
            ),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isUser
                  ? Colors.white
                  : const Color.fromARGB(222, 87, 135, 247),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}
