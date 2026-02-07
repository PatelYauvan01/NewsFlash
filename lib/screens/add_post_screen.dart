import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news_provider.dart';
import '../providers/category_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String _selectedCategory = '';
  bool _isLoading = false;
  String? _titleError;
  String? _descriptionError;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    bool isValid = true;
    setState(() {
      _titleError = null;
      _descriptionError = null;
      _categoryError = null;
    });

    if (_titleController.text.isEmpty) {
      setState(() => _titleError = 'Title is required');
      isValid = false;
    }

    if (_descriptionController.text.isEmpty) {
      setState(() => _descriptionError = 'Description is required');
      isValid = false;
    } else if (_descriptionController.text.length < 10) {
      setState(() => _descriptionError = 'Description must be at least 10 characters');
      isValid = false;
    }

    if (_selectedCategory.isEmpty) {
      setState(() => _categoryError = 'Please select a category');
      isValid = false;
    }

    return isValid;
  }

  Future<void> _postNews() async {
    if (!_validateForm()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await ref.read(allNewsProvider.notifier).addNews(
            _titleController.text,
            _selectedCategory,
            _descriptionController.text,
            'https://via.placeholder.com/400x200?text=${_titleController.text.replaceAll(' ', '+')}',
          );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('News posted successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          _titleController.clear();
          _descriptionController.clear();
          setState(() => _selectedCategory = '');
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add News',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF2196F3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    size: 40,
                    color: Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Upload Image',
                    style: TextStyle(
                      color: Color(0xFF2196F3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'JPG, PNG up to 10MB',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Title',
              hintText: 'Enter news title',
              controller: _titleController,
            ),
            if (_titleError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _titleError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedCategory.isEmpty ? null : _selectedCategory,
              hint: const Text('Select a category'),
              isExpanded: true,
              items: categories
                  .map((cat) => DropdownMenuItem(
                        value: cat.name,
                        child: Text(cat.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value ?? '');
              },
            ),
            if (_categoryError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _categoryError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Description',
              hintText: 'Write your news description',
              controller: _descriptionController,
              maxLines: 5,
            ),
            if (_descriptionError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _descriptionError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 32),
            CustomButton(
              label: 'Post News',
              onPressed: _postNews,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
