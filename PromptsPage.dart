import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class PromptsPage extends StatefulWidget {
  @override
  _PromptsPageState createState() => _PromptsPageState();
}

class _PromptsPageState extends State<PromptsPage> {
  String generatedPrompt = "Press the button to generate a prompt";
  TextEditingController userResponseController = TextEditingController();
  String generatedFeedback = "";
  bool isSubmissionVisible = false;

  Future<void> generatePrompt() async {
    final apiKey = "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";
    final apiUrl = "https://api.openai.com/v1/chat/completions";

    // Clear the user's previous response
    userResponseController.clear();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4",

        "messages": [
          {"role": "user", "content": "I will ask you to generate a prompt for my mobile applciation. The prompts have to be as such that it addicts the user such that they would keep on generating more of them."},
          {"role": "user", "content": "Give me a short fun addictive prompt that helps me do critical thinking and reflection about my actions so that I can mentally grow! Make sure to use second person pronouns."},
        ],
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        generatedPrompt = json.decode(response.body)['choices'][0]['message']['content'];
        isSubmissionVisible = true;
        generatedFeedback = ""; // Reset feedback when generating a new prompt
      });
    } else {
      print("Error: ${response.statusCode}");
      print(response.body);
      setState(() {
        generatedPrompt = "Failed to generate prompt. Check console for details.";
        isSubmissionVisible = false;
      });
    }
  }

  Future<void> submitResponse() async {
    try {
      final apiKey = "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";
      final apiUrl = "https://api.openai.com/v1/chat/completions";

      // Save user response to Firestore
      await FirebaseFirestore.instance.collection('prompts_responses').add({
        'prompt': generatedPrompt,
        'response': userResponseController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Send prompt and user response to ChatGPT
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-4",
          "messages": [
            {"role": "system", "content": "You have created the following prompt for a user"},
            {"role": "user", "content": generatedPrompt},
            {"role": "system", "content": "Here's the user's response to it: "},
            {"role": "assistant", "content": userResponseController.text},
            {"role": "system", "content": "Give the user the feedback on it"},
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Response submitted successfully.'),
        ),
      );

      // Do not reset the user response
      isSubmissionVisible = true;
      generatedPrompt = "Press the button to generate a prompt";
    } catch (e) {
      print("Error submitting response: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit response. Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prompts Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF27AE60), // Dark green app bar color
      ),
      body: Container(
        color: Color(0xFFA9DFBF), // Light green background
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: generatePrompt,
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF196F3D), // Darker green color
                  onPrimary: Colors.white,
                  padding: EdgeInsets.all(16.0),
                ),
                child: Text('Generate Prompt'),
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: Color(0xFF27AE60), // Match the app bar color
              padding: EdgeInsets.all(16.0),
              child: Text(
                generatedPrompt,
                style: TextStyle(fontSize: 18, color: Colors.white), // White text color
                textAlign: TextAlign.center,
              ),
            ),
            if (isSubmissionVisible)
              Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Your Response:',
                    style: TextStyle(fontSize: 18, color: Color(0xFF27AE60)), // Match the app bar color
                  ),
                  SizedBox(height: 8),
                  Container(
                    color: Color(0xFF27AE60), // Match the app bar color
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      controller: userResponseController,
                      maxLines: 3,
                      style: TextStyle(color: Colors.white), // White text color
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Color(0xFF27AE60), // Match the app bar color
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: submitResponse,
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF27AE60), // Match the app bar color
                      onPrimary: Colors.white,
                      padding: EdgeInsets.all(16.0),
                    ),
                    child: Text('Submit Response'),
                  ),
                  if (generatedFeedback.isNotEmpty) // Only show if there is feedback
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Generated Feedback:',
                          style: TextStyle(fontSize: 18, color: Color(0xFF27AE60)), // Match the app bar color
                        ),
                        SizedBox(height: 8),
                        Container(
                          color: Color(0xFF27AE60), // Match the app bar color
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            generatedFeedback,
                            style: TextStyle(fontSize: 18, color: Colors.white), // White text color
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
    home: PromptsPage(),
  ));
}
