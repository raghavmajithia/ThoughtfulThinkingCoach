// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyC6jODS73PpJxuy0sl8Cfg2BKGwJ1mz4_0",
  authDomain: "thoughtful-thinking-coach-new.firebaseapp.com",
  projectId: "thoughtful-thinking-coach-new",
  storageBucket: "thoughtful-thinking-coach-new.appspot.com",
  messagingSenderId: "695236528926",
  appId: "1:695236528926:web:fec1afd3ebc771aafb970f",
  measurementId: "G-CSS72SFTTC"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

const express = require('express');
const bodyParser = require('body-parser');
const sqlite3 = require('sqlite3').verbose();

const app = express();
const port = 64716;

app.use(bodyParser.json());

// Create an SQLite database (in-memory for this example)
const db = new sqlite3.Database(':memory:');

// Create a table to store user responses
db.serialize(() => {
  db.run('CREATE TABLE responses (id INTEGER PRIMARY KEY AUTOINCREMENT, response1 TEXT, response2 TEXT, response3 TEXT)');
});

// Endpoint to save user responses
app.post('/save-response', (req, res) => {
  const { response1, response2, response3 } = req.body;

  // Insert responses into the SQLite database
  db.run('INSERT INTO responses (response1, response2, response3) VALUES (?, ?, ?)', [response1, response2, response3], (err) => {
    if (err) {
      console.error('Error saving responses:', err);
      res.status(500).json({ error: 'Failed to save responses' });
    } else {
      res.json({ success: true });
    }
  });
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
