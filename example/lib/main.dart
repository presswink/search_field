import 'package:flutter/material.dart';
import 'package:search_field/search_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final _firstController = SearchFieldController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SearchField(
                controller: _firstController,
                filterItems: [
                  SearchFieldDataModel(key: "hey", value: "hello"),
                  SearchFieldDataModel(key: "hey", value: "bro"),
                  SearchFieldDataModel(key: "hey", value: "how are"),
                  SearchFieldDataModel(key: "hey", value: "hello"),
                  SearchFieldDataModel(key: "hey", value: "bro"),
                  SearchFieldDataModel(key: "hey", value: "how are")
                ],
                onSelected: (primarySelected, index, item) async {
                  print("primary item selected: $primarySelected");
                  print("selected item index: $index");
                  print("item key: ${item.key}, value: ${item.value}");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
