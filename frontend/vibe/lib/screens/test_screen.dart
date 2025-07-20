import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:vibe/providers/theme_provider.dart';
import 'package:vibe/theme/app_theme.dart';
import 'package:vibe/theme/colors.dart';

class TestScreen extends ConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeNotiferProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Test',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        //backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: 
        GestureDetector(
          onTap: () {
              Routemaster.of(context).push('/');
            },
          child: Container(  
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
             // color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(Icons.arrow_left_outlined, size: 40,),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Хуевый'),
                  content: Text('Test'),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(context).pop();
                    },
                     child: Text('Закрыть'))
                  ],
                );
              });
            },
            child:  Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 37,
              child: Icon(Icons.join_right, size: 20,), 
              )
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40, left: 20, right: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 1.0 : 0.11),
                  blurRadius: 40,
                  spreadRadius: 0.0
                )
              ]
            ),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
               // fillColor: AppColorsLight.primary
              ),
            ),
          )
        ],
      ),
    );
  }
}