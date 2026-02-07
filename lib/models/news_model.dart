class News {
  final String id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final String source;
  final String author;
  final DateTime publishedAt;
  final String category;
  int likes;
  int comments;
  int shares;
  bool isLiked;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.source,
    required this.author,
    required this.publishedAt,
    required this.category,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
  });

  // Calculate time ago
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${publishedAt.month}/${publishedAt.day}/${publishedAt.year}';
    }
  }
}
