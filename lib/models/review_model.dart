class Review {
  final String authorName;
  final String message;
  final String createdAt;

  Review({
    required this.authorName,
    required this.message,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      authorName: json['author']['name'] ?? 'Anonim', 
      message: json['message'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}