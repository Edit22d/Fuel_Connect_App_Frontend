import 'dart:math';
import 'package:flutter/material.dart';
import '../auth/theme.dart';

class MathCaptcha extends StatefulWidget {
  final Function(bool, String) onVerified;
  
  const MathCaptcha({super.key, required this.onVerified});
  
  @override
  State<MathCaptcha> createState() => _MathCaptchaState();
}

class _MathCaptchaState extends State<MathCaptcha> {
  int num1 = 0;
  int num2 = 0;
  int result = 0;
  final TextEditingController _answerController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }
  
  void _generateNewQuestion() {
    setState(() {
      num1 = Random().nextInt(20) + 1;
      num2 = Random().nextInt(20) + 1;
      result = num1 + num2;
    });
    _answerController.clear();
  }
  
  void _verify() {
    final answer = int.tryParse(_answerController.text.trim());
    if (answer == result) {
      // Generate a simple verification token
      String token = "math_captcha_${DateTime.now().millisecondsSinceEpoch}_$result";
      widget.onVerified(true, token);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect answer. Please try again!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _generateNewQuestion();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.gold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Security Verification',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.gold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please solve this math problem to continue:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.gold,
                    width: 2,
                  ),
                ),
                child: Text(
                  '$num1 + $num2 = ?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _answerController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your answer',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white24 : Colors.black26,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.gold, width: 2),
                  ),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}