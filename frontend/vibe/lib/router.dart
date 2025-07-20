import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:vibe/screens/welcome_screen.dart';
import 'package:vibe/screens/test_screen.dart';
import 'package:animations/animations.dart';

class FadeTransitionPage<T> extends Page<T> {
  final Widget child;

  const FadeTransitionPage({required this.child, super.key, super.name});

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

class SlidePage<T> extends Page<T> {
  final Widget child;
  final Offset beginOffset;

  const SlidePage({
    required this.child,
    this.beginOffset = const Offset(1.0, 0.0), // справа налево
    super.key,
    super.name,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}

final routes = RouteMap(routes: {
  '/': (_) => const SlidePage(child: WelcomeScreen()),
  '/chat': (_) => SlidePage(child: TestScreen()),
  // '/chat': (_) => PageRouteBuilder(
  //   pageBuilder:(context, animation, secondaryAnimation) => const TestScreen()
  //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //     final tween = Tween<Offset>(
  //       begin: const Offset(1, 0),
  //       end: Offset.zero,
  //     ).chain(CurveTween(curve: Curves.ease));

  //     return SlideTransition(
  //       position: animation.drive(tween),
  //       child: child,
  //     );
  //   },
  // )
});