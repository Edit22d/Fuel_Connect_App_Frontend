import 'package:flutter/material.dart';
import '/screens/home_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/settings_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Support Center',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gradient hero section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.85,
                  colors: [
                    Color(0xFF0D1117),
                    Color(0xFF0D1117),
                    Color(0xFF1A1A1A),
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
              child: Column(
                children: [
                  // Glowing circular icon
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Color(0xFFC4963D), Color(0xFFC4963D)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC4963D).withOpacity(0.6),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.headset_mic,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Contact our\n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                        TextSpan(
                          text: '24/7 Support\n',
                          style: TextStyle(
                            color: Color(0xFFC4963D),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                        TextSpan(
                          text: 'Team',
                          style: TextStyle(
                            color: Color(0xFFC4963D),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Our specialists are available around the\nclock to assist you with any inquiries.\nFree of charge for all domestic calls.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Call Now button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showCallDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC4963D),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.call, size: 18),
                      label: const Text(
                        'Call Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Toll-Free: 1-800 SUPPORT-247',
                    style: TextStyle(
                      color: Color(0xFFC4963D),
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // White background buttons: Chat, Email, FAQ
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWhiteButton(context, Icons.chat_bubble_outline, 'Chat'),
                  _buildWhiteButton(context, Icons.email_outlined, 'Email'),
                  _buildWhiteButton(context, Icons.help_outline, 'FAQ'),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar - Home, Station, Support, Settings
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D0D0D),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFC4963D),
        unselectedItemColor: Colors.white54,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_gas_station_outlined),
            activeIcon: Icon(Icons.local_gas_station),
            label: 'Station',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headset_mic_outlined),
            activeIcon: Icon(Icons.headset_mic),
            label: 'Support',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0: 
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
              break;
            case 1: 
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              break;
            case 2: 
              
              break;
            case 3: 
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              break;
          }
        },
        currentIndex: 2, 
      ),
    );
  }

  Widget _buildWhiteButton(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Chat') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatSupportScreen()),
          );
        } else if (label == 'Email') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmailSupportScreen()),
          );
        } else if (label == 'FAQ') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FAQScreen()),
          );
        }
      },
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFC4963D), size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFC4963D),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCallDialog(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Enter Phone Number',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: phoneController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'e.g., +1 234 567 8900',
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.phone, color: Color(0xFFC4963D)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFC4963D)),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFC4963D), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                if (phoneController.text.isNotEmpty) {
                  Navigator.pop(context);
                  _makePhoneCall(phoneController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC4963D),
                foregroundColor: Colors.white,
              ),
              child: const Text('Call Now'),
            ),
          ],
        );
      },
    );
  }

  void _makePhoneCall(String phoneNumber) {
   
    showDialog(
      context: chatContext.currentContext!,
    
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Calling...',
            style: TextStyle(color: Color(0xFFC4963D), fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.call, color: Color(0xFFC4963D), size: 50),
              const SizedBox(height: 10),
              Text(
                phoneNumber,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                'Our support team will contact you shortly.',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Color(0xFFC4963D))),
            ),
          ],
        );
      },
    );
  }
}


class ChatSupportScreen extends StatefulWidget {
  const ChatSupportScreen({super.key});

  @override
  State<ChatSupportScreen> createState() => _ChatSupportScreenState();
}

class _ChatSupportScreenState extends State<ChatSupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  final List<String> _quickReplies = [
    'How to order fuel?',
    'Delivery time?',
    'Payment methods',
    'Track my order',
    'Fuel prices',
    'Issue with delivery',
  ];

  @override
  void initState() {
    super.initState();
    _addSystemMessage('Hello! 👋 I\'m your fuel ordering assistant. How can I help you today?');
  }

  void _addSystemMessage(String text) {
    _messages.add(ChatMessage(text: text, isUser: false, timestamp: DateTime.now()));
  }

  void _addUserMessage(String text) {
    _messages.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;
    
    setState(() {
      _addUserMessage(message);
      _isTyping = true;
    });
    
    _messageController.clear();
    
    
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isTyping = false;
        _getAutoResponse(message);
      });
    });
  }

  void _getAutoResponse(String message) {
    String response;
    String lowerMsg = message.toLowerCase();
    
    if (lowerMsg.contains('order') || lowerMsg.contains('fuel')) {
      response = 'To order fuel:\n\n1. Go to Home screen\n2. Select your preferred fuel station\n3. Choose fuel type\n4. Enter quantity\n5. Confirm booking\n6. Make payment\n\nNeed help with any step? Just ask! 👍';
    } else if (lowerMsg.contains('delivery')) {
      response = 'Delivery typically takes 30-45 minutes. You can track your order in real-time from the Order History screen. 🚚';
    } else if (lowerMsg.contains('payment')) {
      response = 'We accept:\n• Mobile Money (M-Pesa, Airtel Money)\n• Credit/Debit Cards\n• Bank Transfer\n• Cash on Delivery\n\nAll payments are secure! 💳';
    } else if (lowerMsg.contains('track')) {
      response = 'Go to Orders → Track Order to see real-time location of your fuel delivery. You\'ll get SMS updates too! 📍';
    } else if (lowerMsg.contains('price')) {
      response = 'Fuel prices vary by station. Current average:\n• Petrol: UGX 4,500/L\n• Diesel: UGX 4,300/L\n• Kerosene: UGX 3,800/L\n\nCheck Station screen for exact prices! ⛽';
    } else if (lowerMsg.contains('issue') || lowerMsg.contains('problem')) {
      response = 'Sorry for the inconvenience! Please call our support line at 1-800-SUPPORT-247 or share your order ID so we can help immediately. 📞';
    } else {
      response = 'I\'m here to help! You can ask me about:\n• Ordering fuel\n• Delivery status\n• Payment methods\n• Fuel prices\n• Technical issues\n\nWhat would you like to know? 😊';
    }
    
    _addSystemMessage(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC4963D),
              ),
              child: const Icon(Icons.support_agent, color: Colors.black, size: 22),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fuel Support Chat',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Online • Response in mins',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
         
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return const TypingIndicator();
                }
                final message = _messages[index];
                return ChatBubble(message: message);
              },
            ),
          ),
          
         
          Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _quickReplies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(_quickReplies[index]),
                    onPressed: () => _sendMessage(_quickReplies[index]),
                    backgroundColor: const Color(0xFF1A1A1A),
                    labelStyle: const TextStyle(color: Color(0xFFC4963D), fontSize: 12),
                    side: const BorderSide(color: Color(0xFFC4963D)),
                  ),
                );
              },
            ),
          ),
          
       
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF0D0D0D),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _sendMessage(_messageController.text),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFC4963D),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.black, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  
  ChatMessage({required this.text, required this.isUser, required this.timestamp});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  
  const ChatBubble({super.key, required this.message});
  
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFFC4963D) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(20),
            bottomLeft: message.isUser ? const Radius.circular(20) : const Radius.circular(4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.black : Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: message.isUser ? Colors.black54 : Colors.white54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFFC4963D),
        shape: BoxShape.circle,
      ),
    );
  }
}


class EmailSupportScreen extends StatefulWidget {
  const EmailSupportScreen({super.key});

  @override
  State<EmailSupportScreen> createState() => _EmailSupportScreenState();
}

class _EmailSupportScreenState extends State<EmailSupportScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Email Support',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.email, color: Color(0xFFC4963D), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Our support team will respond within 24 hours',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInputField('Full Name', _nameController, Icons.person),
            const SizedBox(height: 16),
            _buildInputField('Email Address', _emailController, Icons.email, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildInputField('Order ID (Optional)', _orderIdController, Icons.receipt),
            const SizedBox(height: 16),
            _buildInputField('Message', _messageController, Icons.message, maxLines: 5),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty && _messageController.text.isNotEmpty) {
                    _showEmailSentDialog(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC4963D),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Send Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInputField(String label, TextEditingController controller, IconData icon, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFFC4963D), size: 20),
            filled: true,
            fillColor: const Color(0xFF1A1A1A),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
  
  void _showEmailSentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Icon(Icons.check_circle, color: Color(0xFFC4963D), size: 50),
          content: const Text(
            'Email sent successfully!\nOur team will respond shortly.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC4963D), foregroundColor: Colors.black),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// FAQ Screen
class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Frequently Asked Questions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          FAQItem(
            question: 'How do I order fuel?',
            answer: '1. Go to Home screen\n2. Select a fuel station\n3. Choose fuel type (Petrol/Diesel/Kerosene)\n4. Enter quantity in liters\n5. Review payment details\n6. Confirm booking\n7. Complete payment\n\nYour fuel will be delivered to your location within 30-45 minutes.',
          ),
          FAQItem(
            question: 'What payment methods are accepted?',
            answer: 'We accept multiple payment methods:\n• Mobile Money (M-Pesa, Airtel Money)\n• Credit/Debit Cards (Visa, Mastercard)\n• Bank Transfer\n• Cash on Delivery\n\nAll transactions are secure and encrypted.',
          ),
          FAQItem(
            question: 'How can I track my order?',
            answer: 'To track your order:\n1. Go to Order History\n2. Find your active order\n3. Tap "Track Order"\n4. See real-time location of your delivery\n\nYou\'ll also receive SMS updates at each stage.',
          ),
          FAQItem(
            question: 'What is the delivery time?',
            answer: 'Standard delivery takes 30-45 minutes depending on your location and traffic conditions. During peak hours (8-10 AM, 5-7 PM), delivery may take up to 60 minutes. You\'ll receive an estimated arrival time after booking.',
          ),
          FAQItem(
            question: 'Can I cancel my order?',
            answer: 'Yes, orders can be cancelled within 5 minutes of booking without any fee. After 5 minutes, a small cancellation fee may apply. To cancel:\n1. Go to Order History\n2. Select the order\n3. Tap "Cancel Order"\n4. Confirm cancellation',
          ),
          FAQItem(
            question: 'What if I have issues with delivery?',
            answer: 'If you experience any issues:\n1. Use our live chat support for immediate help\n2. Call our 24/7 support line: 1-800-SUPPORT-247\n3. Send an email to support@fuelapp.com\n\nOur team will resolve your issue within 2 hours.',
          ),
          FAQItem(
            question: 'Are there any delivery fees?',
            answer: 'Delivery fees vary by distance:\n• Within 5km: Free delivery\n• 5-10km: UGX 5,000\n• 10-15km: UGX 8,000\n• 15+ km: UGX 10,000\n\nMinimum order of 10 liters required for delivery.',
          ),
          FAQItem(
            question: 'How do I get a refund?',
            answer: 'Refunds are processed within 3-5 business days. To request a refund:\n1. Contact support via chat or email\n2. Provide your order ID\n3. Explain the issue\n4. Our team will review and process your refund',
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;
  
  const FAQItem({super.key, required this.question, required this.answer});
  
  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.question,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
            ),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: const Color(0xFFC4963D),
            ),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.answer,
                style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
              ),
            ),
        ],
      ),
    );
  }
}

// Global variable to help with context in makePhoneCall
GlobalKey<NavigatorState> chatContext = GlobalKey<NavigatorState>();