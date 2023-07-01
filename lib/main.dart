import 'package:flutter/material.dart';
import 'package:todo_app/config/theme.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/provider/theme_provider.dart';
import 'package:todo_app/views/task_view.dart';

void main() {
  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          title: 'Flutter Demo',
          themeMode: themeProvider.mode,
          darkTheme: darkTheme,
          theme: lightTheme,
          home: const TaskView(),
        ),
      ),
    );
  }
}
