import 'package:flutter/material.dart';
import 'package:chatbotapp/services/chat_services.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, String>> messages = [];
  bool isTyping = false;

  void _sendMessage() async {
    String userInput = _controller.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": userInput});
      isTyping = true;
    });
    _controller.clear();

    _scrollToBottom();

    String botResponse = await chatService.getResponse(userInput);

    setState(() {
      messages.add({"sender": "bot", "text": botResponse});
      isTyping = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat with LLaMA',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['sender'] == 'user';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment:
                    isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isUser) _buildUserAvatar(isUser),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue[200] : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: isUser
                                  ? Radius.circular(12)
                                  : Radius.circular(0),
                              bottomRight: isUser
                                  ? Radius.circular(0)
                                  : Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            message['text']!,
                            style: TextStyle(
                              color: isUser ? Colors.black : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      if (isUser) _buildUserAvatar(isUser),
                    ],
                  ),
                );
              },
            ),
          ),
          if (isTyping)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20),
                  CircularProgressIndicator(strokeWidth: 2.0),
                  SizedBox(width: 10),
                  Text("Typing...", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          _buildMessageInputArea(),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(bool isUser) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: isUser ? Colors.blue : Colors.grey,
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        color: Colors.white,
      ),
    );
  }

  Widget _buildMessageInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
