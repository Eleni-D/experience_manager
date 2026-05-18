class Experience {
  final int? id;
  final String title;
  final String details;

  Experience({this.id, required this.title, required this.details});

  // Maps incoming JSON fields from /posts to our Experience structure
  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      title: json['title'] ?? '',
      details: json['body'] ?? '', // Mapping 'body' from API to 'details'
    );
  }

  // Maps our structure back to JSON formatting for network requests
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'body': details, // Mapping 'details' back to 'body' for the API
    };
  }
}
