import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class ReflectionPage extends StatefulWidget {
  @override
  _ReflectionPageState createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  List<String> questions = [
    "What are you grateful for today?",
    "What challenges did you face today?",
    "What could you improve for tomorrow?",
  ];

  List<TextEditingController> _responseControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  String generatedFeedback = "";
  bool isSubmissionVisible = false;

  Future<void> _submitResponses(BuildContext context) async {
    try {
      final apiKey = "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";
      final apiUrl = "https://api.openai.com/v1/chat/completions";

      // Concatenate responses for ChatGPT input
      String userResponses = _responseControllers.map((controller) => controller.text).join('\n');

      // Send responses to ChatGPT for feedback
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-4",
          "messages": [
            {"role": "system", "content": "You have received reflections from the user."},
            {"role": "user", "content": userResponses},
            {"role": "system", "content": "Provide feedback on the user's reflections."},
            {"role": "system", "content": "The user can only respond once so make sure you give feedback that doesn't require the user to respond back."},
          ],
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          generatedFeedback = json.decode(response.body)['choices'][0]['message']['content'];
        });
      } else {
        print("Error: ${response.statusCode}");
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate feedback. Check console for details.'),
          ),
        );
      }

      // Save all responses to Firestore in one document with timestamp
      await FirebaseFirestore.instance.collection('reflection_responses').add({
        'timestamp': FieldValue.serverTimestamp(),
        'responses': _responseControllers
            .asMap()
            .map((index, controller) => MapEntry('Response ${index + 1}', controller.text))
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Responses submitted successfully.'),
        ),
      );

      setState(() {
        isSubmissionVisible = true;
      });
    } catch (e) {
      print("Error submitting responses: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit responses. Error: $e'),
        ),
      );
    }
  }

  void _clearResponses() {
    setState(() {
      generatedFeedback = "";
      isSubmissionVisible = false;
      for (var controller in _responseControllers) {
        controller.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thoughtful Thinking Coach',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFF08080), // Coral app bar color
      ),
      body: Container(
        color: Color(0xFFFFB6C1), // Lighter shade of coral for background
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < questions.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    questions[i],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _responseControllers[i],
                    maxLines: 3,
                    style: TextStyle(color: Colors.black87), // Darker font color for response
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Color(0xFFF08080), // Coral accent
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ElevatedButton(
              onPressed: () => _submitResponses(context),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFCD5C5C), // Darker shade of coral for button
                onPrimary: Colors.white,
                padding: EdgeInsets.all(16.0),
              ),
              child: Text('Submit All'),
            ),
            SizedBox(height: 16),
            if (isSubmissionVisible)
              ElevatedButton(
                onPressed: _clearResponses,
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey, // Grey button for clearing responses
                  onPrimary: Colors.white,
                  padding: EdgeInsets.all(16.0),
                ),
                child: Text('Clear Responses'),
              ),
            SizedBox(height: 16),
            if (generatedFeedback.isNotEmpty) // Only show if there is feedback
              Column(
                children: [
                  Text(
                    'Generated Feedback:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    generatedFeedback,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReflectionPage(),
  ));
}
