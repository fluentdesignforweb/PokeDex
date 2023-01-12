import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class DetailedViewMain extends StatelessWidget {
  final String number;

  const DetailedViewMain({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: PokeViewUI(
        pokeNum: number,
      ),
    ));
  }
}

class PokemonDetail {
  String pokeNum;

  PokemonDetail(this.pokeNum);
}

class PokeViewUI extends StatefulWidget {
  final String pokeNum;
  const PokeViewUI({Key? key, required this.pokeNum}) : super(key: key);

  @override
  DynamicPokeViewUI createState() => DynamicPokeViewUI(pokeNum);
}

class DynamicPokeViewUI extends State {
  final String pokemonNumber;
  DynamicPokeViewUI(this.pokemonNumber);

  var pokelist = {};
  Future<void> loadAsset() async {
    final String response = await rootBundle.loadString('api/pokelist.json');
    final data = await json.decode(response);
    setState(() {
      pokelist = data['${int.parse(pokemonNumber)}'][0];
    });
  }

  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  pokeList() {
    Navigator.pushNamed(context, '/');
  }

  navPrevNext(direction) {
    var newPokeNum = int.parse(pokemonNumber);
    if (direction == DismissDirection.startToEnd) {
      newPokeNum = newPokeNum - 1;
      if (newPokeNum == 0) newPokeNum = 807;
      Navigator.pushNamed(context, '/detail',
          arguments: PokemonDetail(newPokeNum.toString()));
    } else {
      newPokeNum = newPokeNum + 1;
      if (newPokeNum == 808) newPokeNum = 1;
      Navigator.pushNamed(context, '/detail',
          arguments: PokemonDetail(newPokeNum.toString()));
    }
  }

  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/');
        return false;
      },
      child: Scaffold(
          body: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) => navPrevNext(direction),
        child: Center(
            child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 36, 0, 0),
              height: 48,
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Color(0x000065AF)),
              child: Text(
                textAlign: TextAlign.center,
                '${pokelist['number']}   ${pokelist['name']}',
                style: const TextStyle(
                    color: Color(0xFFFAFADA),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Color(0xAA0065AF)),
              child: Text(
                textAlign: TextAlign.center,
                '${pokelist['height']} ${pokelist['weight']} \n ${pokelist['species']} Pokemon',
                style: const TextStyle(
                  color: Color(0xFFFAFADA),
                  fontSize: 18,
                ),
              ),
            ),
            pokelist.isNotEmpty
                ? Expanded(
                    child: Container(
                      color: const Color(0xDDFACCFA),
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      child: FadeInImage.assetNetwork(
                          imageScale: 1.0,
                          placeholder: 'api/pokeball.png',
                          image: pokelist['sprite']),
                    ),
                  )
                : Container(),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Color(0xFFFAACAA)),
              width: MediaQuery.of(context).size.width,
              height: 36,
              child: Text(
                '${pokelist['types']}',
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Color(0xFFFAFAFA),
              child: Text(
                '${pokelist['description']}',
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        )),
      )),
    );
  }
}


//${pokelist['1'][0]['name']}
//return Text('${pokelist['${index + 1}'][0]['name']}');
//Image.network('${pokelist['sprite']}')