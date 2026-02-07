import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/category_selection_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/news_detail_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return MaterialApp(
      title: 'NewsWatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isLoggedIn.when(
        data: (loggedIn) {
          if (loggedIn) {
            return const MainNavigationScreen();
          } else {
            return const SplashScreen();
          }
        },
        loading: () => const SplashScreen(),
        error: (err, stack) => const SplashScreen(),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case '/otp':
            return MaterialPageRoute(builder: (_) => const OTPScreen());
          case '/category':
            return MaterialPageRoute(
              builder: (_) => const CategorySelectionScreen(),
            );
          case '/home':
            return MaterialPageRoute(
              builder: (_) => const MainNavigationScreen(),
            );
          case '/news-detail':
            final newsId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => NewsDetailScreen(newsId: newsId),
            );
          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
    );
  }
}
