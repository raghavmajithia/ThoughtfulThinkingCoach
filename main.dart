import 'package:flutter/material.dart';
import 'theme.dart';
import 'HomePage.dart';
import 'ReflectionsPage.dart';
import 'PromptsPage.dart';
import 'StoriesPage.dart';
import 'AffirmationsPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ThoughtfulThinkingCoachApp());
}

class ThoughtfulThinkingCoachApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thoughtful Thinking Coach',
      theme: themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/reflections': (context) => ReflectionPage(),
        '/prompts': (context) => PromptsPage(),
        '/stories': (context) => StoriesPage(),
        '/affirmations': (context) => AffirmationsPage(),
      },
    );
  }
}