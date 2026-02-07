import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            _buildSection(
              'Account',
              [
                _buildTile(
                  context,
                  'Profile',
                  'Manage your profile information',
                  Icons.person,
                  () => Navigator.of(context).pushNamed('/profile'),
                ),
                _buildTile(
                  context,
                  'Change Password',
                  'Update your password',
                  Icons.lock,
                  () {},
                ),
              ],
            ),
            // App Section
            _buildSection(
              'App',
              [
                _buildTile(
                  context,
                  'Notifications',
                  'Manage notification settings',
                  Icons.notifications,
                  () {},
                ),
                _buildTile(
                  context,
                  'Dark Mode',
                  'Switch to dark theme',
                  Icons.dark_mode,
                  () {},
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                    activeColor: const Color(0xFF2196F3),
                  ),
                ),
                _buildTile(
                  context,
                  'Language',
                  'English',
                  Icons.language,
                  () {},
                ),
              ],
            ),
            // Support Section
            _buildSection(
              'Support',
              [
                _buildTile(
                  context,
                  'Help & Support',
                  'Get help and report issues',
                  Icons.help,
                  () {},
                ),
                _buildTile(
                  context,
                  'Terms & Conditions',
                  'Read our terms',
                  Icons.description,
                  () => _showTermsDialog(context),
                ),
                _buildTile(
                  context,
                  'Privacy Policy',
                  'Read our privacy policy',
                  Icons.privacy_tip,
                  () {},
                ),
              ],
            ),
            // Danger Zone
            _buildSection(
              'Danger Zone',
              [
                _buildTile(
                  context,
                  'Logout',
                  'Sign out from your account',
                  Icons.logout,
                  () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text(
                          'Are you sure you want to logout?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await ref
                                  .read(currentUserProvider.notifier)
                                  .logout();
                              if (context.mounted) {
                                Navigator.of(context)
                                    .pushReplacementNamed('/login');
                              }
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  textColor: Colors.red,
                ),
                _buildTile(
                  context,
                  'Delete Account',
                  'Permanently delete your account',
                  Icons.delete_forever,
                  () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Account'),
                        content: const Text(
                          'This action cannot be undone. Are you sure?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Account deletion request submitted',
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  textColor: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'NewsWatch v1.0.0',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2196F3),
            ),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    Color textColor = const Color(0xFF1A1A1A),
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Icon(icon, color: const Color(0xFF2196F3)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: trailing ??
          const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: SingleChildScrollView(
          child: Text(
            'By using NewsWatch, you agree to:\n\n'
            '1. Use the app for lawful purposes\n'
            '2. Not reproduce or distribute content without permission\n'
            '3. Respect intellectual property rights\n'
            '4. Not engage in harassment or abuse\n'
            '5. Comply with all applicable laws\n\n'
            'For complete terms, visit our website.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
