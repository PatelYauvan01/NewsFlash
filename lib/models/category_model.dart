class Category {
  final String id;
  final String name;
  final String icon;
  bool isSelected;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    this.isSelected = false,
  });
}

List<Category> defaultCategories = [
  Category(id: '1', name: 'Technology', icon: '💻'),
  Category(id: '2', name: 'Business', icon: '📊'),
  Category(id: '3', name: 'Sports', icon: '⚽'),
  Category(id: '4', name: 'Entertainment', icon: '🎬'),
  Category(id: '5', name: 'Health', icon: '🏥'),
  Category(id: '6', name: 'Science', icon: '🔬'),
  Category(id: '7', name: 'Politics', icon: '🏛️'),
  Category(id: '8', name: 'Lifestyle', icon: '✨'),
];
