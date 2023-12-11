import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoriesPage extends StatefulWidget {
  @override
  _StoriesPageState createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  String story = "Press the button to generate a story";

  Future<void> generateStory() async {
    final apiKey = "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";
    final apiUrl = "https://api.openai.com/v1/chat/completions";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4",
        "messages": [
          {"role": "system", "content": "I will ask you to generate short stories for my mobile app. They have to addict the users like Instagram reels and YouTube shorts."},
          {"role": "system", "content": "Hi there, can you provide me with one insightful short story that helps me think critically and mentally grow"},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final generatedText = data['choices'][0]['message']['content'];

      // Save generated story to Firestore
      saveStoryToFirestore(generatedText);

      setState(() {
        story = generatedText;
      });
    } else {
      print("Error: ${response.statusCode}");
      print(response.body);
      setState(() {
        story = "Failed to generate story. Check console for details.";
      });
    }
  }

  Future<void> saveStoryToFirestore(String generatedStory) async {
    try {
      await FirebaseFirestore.instance.collection('generated_stories').add({
        'story': generatedStory,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving story to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stories',
          style: TextStyle(color: Colors.white), // White text color
        ),
        backgroundColor: Color(0xFF3498DB), // Blue app bar color
      ),
      body: Container(
        color: Color(0xFF87CEFA), // Light blue background
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: generateStory,
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF3498DB), // Blue color
                  onPrimary: Colors.white, // White text color
                  padding: EdgeInsets.all(16.0),
                ),
                child: Text('Generate Story'),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Color(0xFF87CEFA), // Light blue background color
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Text(
                      story,
                      style: TextStyle(fontSize: 18, color: Colors.black), // Black text color
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StoriesPage(),
    theme: ThemeData(
      scaffoldBackgroundColor: Color(0xFF87CEFA), // Light blue background
    ),
  ));
}
