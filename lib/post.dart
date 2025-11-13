// lib/post.dart

class Post {
  final int id;
  final String title;
  final String body;

  // Constructor
  Post({required this.id, required this.title, required this.body});

  // Factory method to create a Post object from a JSON map
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}