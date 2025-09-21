import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibe/providers.dart';
import 'package:vibe/screens/chats_screen.dart';
import 'package:vibe/screens/login_screen.dart';
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
            elevation: 2.0,
            color: Colors.white,
            surfaceTintColor: Colors.teal.shade50
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12.0))
            )
          )
        ),
       // initialRoute: '/login',
       home: AuthCheckScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/chats': (context) => ChatsScreen()
          // '/chats': (context) => Scaffold(
          //   appBar: AppBar(title: Text('Chats'),),
          //   body: Center(child: Text('Chats list (Development)'),),
          // )
        },
        debugShowCheckedModeBanner: false,
      );
  }
}

class AuthCheckScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: ref.read(authServiceProvider).validateToken(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }
        if (snapshot.hasData && snapshot.data == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/chats');
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }
}