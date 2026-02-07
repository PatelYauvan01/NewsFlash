import '../models/news_model.dart';

class NewsService {
  // Dummy news data
  static final List<News> dummyNews = [
    News(
      id: '1',
      title: 'Flutter 4.0 Announced with New Features',
      description: 'Google announced the latest version of Flutter with incredible new features and performance improvements.',
      content: 'Flutter 4.0 is here with groundbreaking features including improved performance, better tooling, and enhanced platform support. This version focuses on web development and desktop applications.',
      imageUrl: 'https://via.placeholder.com/400x200?text=Flutter+4.0',
      source: 'Flutter News',
      author: 'John Developer',
      publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      category: 'Technology',
      likes: 245,
      comments: 18,
      shares: 42,
    ),
    News(
      id: '2',
      title: 'Tech Giants Report Record Profits',
      description: 'Major technology companies announce unprecedented earnings in Q4.',
      content: 'The world\'s leading tech companies have reported record profits in their latest quarterly earnings. Stock prices surged following the announcements.',
      imageUrl: 'https://via.placeholder.com/400x200?text=Tech+Profits',
      source: 'Business Daily',
      author: 'Sarah Finance',
      publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
      category: 'Business',
      likes: 189,
      comments: 12,
      shares: 35,
    ),
    News(
      id: '3',
      title: 'Championship Team Wins Historic Victory',
      description: 'Local team secures their first championship in 25 years with a thrilling victory.',
      content: 'In an exciting match yesterday, the hometown team claimed their first championship title in a quarter-century. Fans celebrated throughout the night.',
      imageUrl: 'https://via.placeholder.com/400x200?text=Sports+Victory',
      source: 'Sports Weekly',
      author: 'Mike Sports',
      publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
      category: 'Sports',
      likes: 512,
      comments: 45,
      shares: 128,
    ),
    News(
      id: '4',
      title: 'New Movie Breaks Box Office Records',
      description: 'Blockbuster film becomes the highest-grossing movie of all time.',
      content: 'The highly anticipated film has broken all box office records on its opening weekend, becoming the fastest movie to reach \$1 billion.',
      imageUrl: 'https://via.placeholder.com/400x200?text=Movie+Release',
      source: 'Entertainment Tonight',
      author: 'Emma Film',
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Entertainment',
      likes: 342,
      comments: 28,
      shares: 89,
    ),
    News(
      id: '5',
      title: 'Breakthrough in Cancer Research',
      description: 'Scientists discover promising new treatment for cancer patients.',
      content: 'Researchers have unveiled a groundbreaking treatment that shows remarkable results in clinical trials. The discovery could revolutionize cancer care.',
      imageUrl: 'https://via.placeholder.com/400x200?text=Medical+Breakthrough',
      source: 'Health News',
      author: 'Dr. Richard Health',
      publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      category: 'Health',
      likes: 678,
      comments: 52,
      shares: 156,
    ),
    News(
      id: '6',
      title: 'NASA Discovers New Earth-like Planet',
      description: 'Telescope reveals a potentially habitable exoplanet orbiting nearby star.',
      content: 'NASA scientists have discovered a new exoplanet in the habitable zone of its star system. The planet shows signs that could support life.',
      imageUrl: 'https://via.placeholder.com/400x200?text=Space+Discovery',
      source: 'Science Journal',
      author: 'Dr. Space Explorer',
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Science',
      likes: 923,
      comments: 67,
      shares: 234,
    ),
    News(
      id: '7',
      title: 'New Government Policy Approved',
      description: 'Parliament passes landmark legislation affecting millions.',
      content: 'After months of debate, lawmakers have passed a comprehensive new policy that will have far-reaching implications for the nation.',
      imageUrl: 'https://via.placeholder.com/400x200?text=Government+News',
      source: 'Political Times',
      author: 'David Politics',
      publishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      category: 'Politics',
      likes: 445,
      comments: 89,
      shares: 123,
    ),
    News(
      id: '8',
      title: 'Wellness Trends to Watch in 2026',
      description: 'Experts share the top lifestyle and wellness trends for the coming year.',
      content: 'Health and wellness experts have identified the key trends that will dominate 2026, from fitness innovations to mental health awareness.',
      imageUrl: 'https://via.placeholder.com/400x200?text=Wellness+Trends',
      source: 'Lifestyle Magazine',
      author: 'Lisa Wellness',
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      category: 'Lifestyle',
      likes: 267,
      comments: 34,
      shares: 76,
    ),
  ];

  List<News> getAllNews() {
    return dummyNews;
  }

  List<News> getNewsByCategory(String category) {
    return dummyNews.where((news) => news.category == category).toList();
  }

  News? getNewsById(String id) {
    try {
      return dummyNews.firstWhere((news) => news.id == id);
    } catch (e) {
      return null;
    }
  }

  List<News> getTrendingNews() {
    final sorted = [...dummyNews];
    sorted.sort((a, b) => (b.likes + b.comments + b.shares).compareTo(a.likes + a.comments + a.shares));
    return sorted.take(5).toList();
  }

  List<String> getPopularTags() {
    return [
      'Breaking',
      'Trending',
      'Technology',
      'Business',
      'Entertainment',
      'Health',
      'Science',
      'Sports',
      'Innovation',
      'Updates',
    ];
  }

  Future<bool> addNews(String title, String category, String description, String imageUrl) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      final newNews = News(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        content: description,
        imageUrl: imageUrl,
        source: 'User Posted',
        author: 'You',
        publishedAt: DateTime.now(),
        category: category,
      );
      
      dummyNews.insert(0, newNews);
      return true;
    } catch (e) {
      return false;
    }
  }

  void toggleLike(String newsId) {
    final news = getNewsById(newsId);
    if (news != null) {
      news.isLiked = !news.isLiked;
      if (news.isLiked) {
        news.likes++;
      } else {
        news.likes--;
      }
    }
  }
}
