import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibe/generated/auth/auth.pbgrpc.dart';
import 'package:vibe/providers.dart';
import 'package:vibe/screens/login_screen.dart';
import 'package:vibe/screens/welcome_screen.dart';
import 'package:vibe/services/auth_service.dart';
import 'package:vibe/theme/colors.dart';
import 'package:vibe/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'router.dart';
import 'package:routemaster/routemaster.dart';
import 'package:vibe/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          cardTheme: CardThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12.0))
            )
          )
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/chats': (context) => Scaffold(
            appBar: AppBar(title: Text('Chats'),),
            body: Center(child: Text('Chats list (Development)'),),
          )
        },
      );
  }
}