import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'post.dart'; // Ensure this points to your post.dart file

// API Fetching Function (from Step 3)
Future<Post> fetchPost() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonBody = json.decode(response.body);
    return Post.fromJson(jsonBody);
  } else {
    throw Exception('Failed to load post. Status Code: ${response.statusCode}');
  }
}

// --- Main App and Widget ---

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PostScreen(),
    );
  }
}

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  // Declare a Future variable to hold the result of the API call
  late Future<Post> futurePost;

  @override
  void initState() {
    super.initState();
    // Call the API function when the widget is initialized
    futurePost = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic API Fetch'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        // FutureBuilder manages the async process and updates the UI
        child: FutureBuilder<Post>(
          future: futurePost,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // STATE 1: Data is loading
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // STATE 2: An error occurred
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              // STATE 3: Data successfully loaded
              // Use the retrieved 'Post' object to build the UI
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Post ID: ${snapshot.data!.id}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      snapshot.data!.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      snapshot.data!.body,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }
            // Fallback: Default spinner if no state has been reached yet
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}