import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';

final newsServiceProvider = Provider((ref) => NewsService());

final allNewsProvider = StateNotifierProvider<NewsNotifier, List<News>>((ref) {
  return NewsNotifier(ref.watch(newsServiceProvider));
});

final trendingNewsProvider = FutureProvider<List<News>>((ref) {
  final newsService = ref.watch(newsServiceProvider);
  return Future.value(newsService.getTrendingNews());
});

final popularTagsProvider = FutureProvider<List<String>>((ref) {
  final newsService = ref.watch(newsServiceProvider);
  return Future.value(newsService.getPopularTags());
});

final newsByCategoryProvider = FutureProvider.family<List<News>, String>((ref, category) {
  final newsService = ref.watch(newsServiceProvider);
  return Future.value(newsService.getNewsByCategory(category));
});

final newsDetailProvider = FutureProvider.family<News?, String>((ref, newsId) {
  final newsService = ref.watch(newsServiceProvider);
  return Future.value(newsService.getNewsById(newsId));
});

class NewsNotifier extends StateNotifier<List<News>> {
  final NewsService _newsService;

  NewsNotifier(this._newsService) : super([]) {
    _loadNews();
  }

  void _loadNews() {
    state = _newsService.getAllNews();
  }

  void toggleLike(String newsId) {
    _newsService.toggleLike(newsId);
    state = [..._newsService.getAllNews()];
  }

  Future<bool> addNews(String title, String category, String description, String imageUrl) async {
    final success = await _newsService.addNews(title, category, description, imageUrl);
    if (success) {
      _loadNews();
    }
    return success;
  }

  void refresh() {
    _loadNews();
  }
}
