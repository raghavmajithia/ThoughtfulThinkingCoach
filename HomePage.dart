import 'package:flutter/material.dart';
import 'StoriesPage.dart';
import 'ReflectionsPage.dart';
import 'PromptsPage.dart';
import 'AffirmationsPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thoughtful Thinking Coach',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xFF0E103D), // Deep blue background
        appBarTheme: AppBarTheme(
          color: Color(0xFF0E103D), // Deep blue app bar
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thoughtful Thinking Coach',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Color(0xFF0E103D), // Deep blue background
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: HomeButton(
                      title: 'Reflection',
                      color: Color(0xFFF08080), // Light pink
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReflectionPage()),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: HomeButton(
                      title: 'Prompts',
                      color: Color(0xFF66BB6A), // Light green
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PromptsPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: HomeButton(
                      title: 'Short Stories',
                      color: Color(0xFF6FA1D2), // Light blue
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StoriesPage()),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: HomeButton(
                      title: 'Affirmations',
                      color: Color(0xFFFFB74D), // Light orange
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AffirmationsPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ClipOval(
              /*child: Image.asset(
                'logo-transparent-png.png',
                width: 50, // Adjust the width as needed
                height: 50, // Adjust the height as needed
              ),*/
            ),
          ],
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;

  const HomeButton({
    required this.title,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        onPrimary: Color(0xFF0E103D), // Deep blue text color
        padding: EdgeInsets.all(16.0),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 25, // Adjusted font size
            fontWeight: FontWeight.bold, // Bold font weight
            color: Color(0xFF0E103D), // Deep blue text color
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
