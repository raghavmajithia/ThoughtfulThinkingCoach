import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class AffirmationsPage extends StatefulWidget {
  @override
  _AffirmationsPageState createState() => _AffirmationsPageState();
}

class _AffirmationsPageState extends State<AffirmationsPage> {
  String affirmation = "Press the button to generate an affirmation";

  Future<void> generateAffirmation() async {
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
          {"role": "user", "content": "Give me a fun, effective daily affirmation that helps me mentally grow! Use second person pronouns"},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final generatedText = data['choices'][0]['message']['content'];

      // Save generated affirmation to Firestore
      saveAffirmationToFirestore(generatedText);

      setState(() {
        affirmation = generatedText;
      });
    } else {
      print("Error: ${response.statusCode}");
      print(response.body);
      setState(() {
        affirmation = "Failed to generate affirmation. Check console for details.";
      });
    }
  }

  Future<void> saveAffirmationToFirestore(String generatedAffirmation) async {
    try {
      await FirebaseFirestore.instance.collection('generated_affirmations').add({
        'affirmation': generatedAffirmation,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving affirmation to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Affirmations',
          style: TextStyle(color: Colors.yellow[900]), // Dark yellow text color
        ),
        backgroundColor: Colors.yellow[600], // Medium yellow app bar color
      ),
      body: Container(
        color: Colors.yellow[400], // Light yellow background
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: generateAffirmation,
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow[600], // Medium yellow color
                  onPrimary: Colors.black, // Black text color
                  padding: EdgeInsets.all(16.0),
                ),
                child: Text('Generate Affirmation'),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.yellow[200], // Lighter yellow box color
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              padding: EdgeInsets.all(16.0),
              child: Text(
                affirmation,
                style: TextStyle(fontSize: 18, color: Colors.black), // Black text color
                textAlign: TextAlign.center,
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
    home: AffirmationsPage(),
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.yellow[400], // Light yellow background
    ),
  ));
}
