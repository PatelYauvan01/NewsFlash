import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';

final categoriesProvider = StateNotifierProvider<CategoriesNotifier, List<Category>>((ref) {
  return CategoriesNotifier();
});

class CategoriesNotifier extends StateNotifier<List<Category>> {
  CategoriesNotifier() : super(defaultCategories.map((c) => Category(
    id: c.id,
    name: c.name,
    icon: c.icon,
    isSelected: false,
  )).toList());

  void toggleCategory(String categoryId) {
    state = [
      for (final category in state)
        if (category.id == categoryId)
          Category(
            id: category.id,
            name: category.name,
            icon: category.icon,
            isSelected: !category.isSelected,
          )
        else
          category
      ];
  }

  void selectMultiple(List<String> categoryIds) {
    state = [
      for (final category in state)
        Category(
          id: category.id,
          name: category.name,
          icon: category.icon,
          isSelected: categoryIds.contains(category.id),
        )
    ];
  }

  List<String> getSelectedCategories() {
    return state.where((c) => c.isSelected).map((c) => c.name).toList();
  }

  void resetSelection() {
    state = [
      for (final category in state)
        Category(
          id: category.id,
          name: category.name,
          icon: category.icon,
          isSelected: false,
        )
    ];
  }
}
