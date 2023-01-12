import 'package:flutter/material.dart';
import 'package:pokedex/screens/DetailedView/DetailedViewMain.dart';
import 'package:pokedex/screens/PokeList/PokeListMain.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeDex',
      initialRoute: '/',
      routes: {
        '/': (context) => const PokeListMain(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final args = settings.arguments as PokemonDetail;
          return MaterialPageRoute(
            builder: (context) {
              return DetailedViewMain(
                number: args.pokeNum,
              );
            },
          );
        }
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF0E0E1E),
      ),
    );
  }
}
