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
  TextEditingController searchController = TextEditingController();

  var selected = "";
  var pokelist = {};
  var filterList = {};
  Future<void> loadAsset() async {
    final String response = await rootBundle.loadString('api/pokelist.json');
    final data = await json.decode(response);
    setState(() {
      pokelist = data;
    });
    setState(() {
      filterList = pokelist;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  void filterPokelist() {
    var filteredList = [
      for (final key in pokelist.keys)
        {
          if (key == searchController.text ||
              pokelist[key][0]['name']
                  .toString()
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
            1.toString(): pokelist[key]
        }
    ];
    filteredList.removeWhere((element) => element.isEmpty);
    if (searchController.text == "") {
      setState(() {
        filterList = pokelist;
      });
    } else {
      if (filteredList.isNotEmpty) {
        setState(() {
          filterList = filteredList[0];
        });
      } else {
        print("no such pokemon");
      }
    }
  }

  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          body: Center(
              child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(6, 36, 6, 0),
            padding: const EdgeInsets.all(8),
            child: Column(children: [
              const Text(
                "\n",
                style: TextStyle(fontSize: 6),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  "PokeDex",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFAFADA)),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  "Search for a pokemon by name or number, clear search to get back the full pokedex again. When in detailed view, swipe left or right to see next or previous pokemon. \n",
                  style: TextStyle(fontSize: 16, color: Color(0xFFFAFADA)),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                height: 48,
                child: TextField(
                  onChanged: (searchController) => filterPokelist(),
                  controller: searchController,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFFAFADA), width: 2),
                      ),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Color(0xFFFAFADA))),
                  style:
                      const TextStyle(color: Color(0xFFFAFADA), fontSize: 16),
                ),
              ),
            ]),
          ),
          pokelist.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (itemCount, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/detail',
                              arguments: PokemonDetail(
                                  '${filterList['${index + 1}'][0]['number']}'));
                        },
                        key: ValueKey(filterList[index + 1]),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFAFAEA),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              border: Border.all(
                                  color: const Color(0xFFACACAC), width: 1)),
                          child: Row(children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF547CFF),
                                  borderRadius: BorderRadius.circular(6)),
                              width: 60,
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                textAlign: TextAlign.center,
                                '${filterList['${index + 1}'][0]['number']}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Color(0xFFFAFADA),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                textAlign: TextAlign.center,
                                '${filterList['${index + 1}'][0]['name']}',
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ]),
                        ),
                      );
                    },
                  ),
                )
              : Container()
        ],
      ))),
    );
  }
}

//${pokelist['1'][0]['name']}
//return Text('${pokelist['${index + 1}'][0]['name']}');
//Image.network(width: MediaQuery.of(context).size.width * 0.30, '${pokelist['${index + 1}'][0]['sprite']}')