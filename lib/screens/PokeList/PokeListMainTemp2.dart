import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pokedex/screens/DetailedView/DetailedViewMain.dart';

class PokeListMain extends StatelessWidget {
  const PokeListMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: PokeListUI(),
    ));
  }
}

class PokeListUI extends StatefulWidget {
  const PokeListUI({Key? key}) : super(key: key);

  @override
  DynamicPokeListUI createState() => DynamicPokeListUI();
}

class DynamicPokeListUI extends State {
  var selected = "";
  var pokelist = {};
  Future<void> loadAsset() async {
    final String response = await rootBundle.loadString('api/pokelist.json');
    final data = await json.decode(response);
    setState(() {
      pokelist = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        Container(
          height: 200,
          padding: EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search By Name',
            ),
          ),
        ),
        pokelist.isNotEmpty
            ? Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: pokelist.length,
                  itemBuilder: (itemCount, index) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/detail',
                              arguments: PokemonDetail(
                                  '${pokelist['${index + 1}'][0]['number']}'));
                        },
                        key: ValueKey(pokelist[index + 1]),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFAFADA),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              border: Border.all(
                                  color: const Color(0xFFACACAC), width: 1)),
                          child: Column(children: [
                            Text("\n".toString()),
                            Image.network(
                                width: MediaQuery.of(context).size.width * 0.25,
                                '${pokelist['${index + 1}'][0]['sprite']}'),
                            Text(
                              '${pokelist['${index + 1}'][0]['name']}',
                              style: const TextStyle(fontSize: 22),
                            ),
                            Text(
                              '${pokelist['${index + 1}'][0]['number']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ]),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container()
      ],
    )));
  }
}

//${pokelist['1'][0]['name']}
//return Text('${pokelist['${index + 1}'][0]['name']}');

//Image.network('${pokelist['${index + 1}'][0]['sprite']}')

//Text('\n\nGeneration: ${pokelist['${index + 1}'][0]['gen']}'),
