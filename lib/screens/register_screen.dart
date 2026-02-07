import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _isLoading = false;
  bool _agreeToTerms = false;
  String? _usernameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    bool isValid = true;
    setState(() {
      _usernameError = null;
      _emailError = null;
      _phoneError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    if (_usernameController.text.isEmpty) {
      setState(() => _usernameError = 'Username is required');
      isValid = false;
    } else if (_usernameController.text.length < 3) {
      setState(() => _usernameError = 'Username must be at least 3 characters');
      isValid = false;
    }

    if (_emailController.text.isEmpty) {
      setState(() => _emailError = 'Email is required');
      isValid = false;
    } else if (!_emailController.text.contains('@')) {
      setState(() => _emailError = 'Enter a valid email');
      isValid = false;
    }

    if (_phoneController.text.isEmpty) {
      setState(() => _phoneError = 'Phone number is required');
      isValid = false;
    } else if (_phoneController.text.length < 10) {
      setState(() => _phoneError = 'Enter a valid phone number');
      isValid = false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters');
      isValid = false;
    }

    if (_confirmPasswordController.text.isEmpty) {
      setState(() => _confirmPasswordError = 'Please confirm password');
      isValid = false;
    } else if (_confirmPasswordController.text != _passwordController.text) {
      setState(() => _confirmPasswordError = 'Passwords do not match');
      isValid = false;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms & Conditions'),
          backgroundColor: Colors.orange,
        ),
      );
      isValid = false;
    }

    return isValid;
  }

  Future<void> _register() async {
    if (!_validateInputs()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await ref.read(currentUserProvider.notifier).register(
            _usernameController.text,
            _emailController.text,
            _passwordController.text,
            _phoneController.text,
          );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pushReplacementNamed('/otp');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign up to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Username',
              hintText: 'Choose a username',
              controller: _usernameController,
            ),
            if (_usernameError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _usernameError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email Address',
              hintText: 'your@email.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            if (_emailError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _emailError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Phone Number',
              hintText: '+1234567890',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            if (_phoneError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _phoneError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Password',
              hintText: 'Create a strong password',
              controller: _passwordController,
              obscureText: true,
            ),
            if (_passwordError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _passwordError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Confirm Password',
              hintText: 'Confirm your password',
              controller: _confirmPasswordController,
              obscureText: true,
            ),
            if (_confirmPasswordError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _confirmPasswordError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() => _agreeToTerms = value ?? false);
                  },
                  activeColor: const Color(0xFF2196F3),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'I agree to ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      children: [
                        const TextSpan(
                          text: 'Terms & Conditions',
                          style: TextStyle(
                            color: Color(0xFF2196F3),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              label: 'Sign Up',
              onPressed: _register,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Color(0xFF2196F3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
