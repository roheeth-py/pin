import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';

final lightMode = ThemeData().copyWith(
  brightness: Brightness.light
);

final darkMode = ThemeData().copyWith(
  brightness: Brightness.dark,
);


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: "Pin Point",
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    ),
  );
}
