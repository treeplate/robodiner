import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robo-Diner',
      theme: ThemeData(fontFamily: "mybitmap"),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Item playerItem = NoItem();
  Item customerItem = Lettuce();
  Random r = Random();
  List<Usable> materials = [
    LettuceCrate(),
    TomatoCrate(),
    Trash(),
    BunCrate(),
    MeatCrate(),
    Cooker(),
    Table(),
    Table(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "",
        ),
      ),
      body: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text("You have " + playerItem.name)),
                FlatButton(
                  color: Colors.red,
                  child: Text("You want " + customerItem.name),
                  onPressed: () {
                    setState(() {
                      if (playerItem.name == customerItem.name) {
                        playerItem = NoItem();
                        customerItem = [
                          Lettuce(),
                          Tomato(),
                          LettuceTomato(),
                          Burger(),
                        ][r.nextInt(4)];
                      }
                    });
                  },
                ),
                Container(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: materials.map((Usable usable) {
                          return FlatButton(
                            color: Colors.red,
                            child: Text(usable.name),
                            onPressed: () {
                              setState(() {
                                playerItem = usable.use(playerItem);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

abstract class Item {
  String get name;
  Item combine(Item other, {bool reverse = false}) {
    if (reverse) return other;
    return other.combine(this, reverse: true);
  }
}

class NoItem extends Item {
  final String name = "no item";
  Item combine(Item other, {bool reverse = false}) => other;
}

class Lettuce extends Item {
  final String name = "lettuce";
  Item combine(Item other, {bool reverse = false}) {
    if (other.name == "tomato") return LettuceTomato();
    return super.combine(other, reverse: reverse);
  }
}

class Tomato extends Item {
  final String name = "tomato";
}

class LettuceTomato extends Item {
  final String name = "lettuce+tomato";
}

class Bun extends Item {
  final String name = "bun";
  Item combine(Item other, {bool reverse = false}) {
    if (other.name == "cooked meat") return Burger();
    return super.combine(other, reverse: reverse);
  }
}

class Meat extends Item {
  final String name = "meat";
}

class CookedMeat extends Item {
  final String name = "cooked meat";
}

class Burger extends Item {
  final String name = "burger";
}

abstract class Usable {
  Item use(Item current);
  String get name;
}

class LettuceCrate extends Usable {
  Item use(Item current) {
    return current.combine(Lettuce());
  }

  String get name => "lettuce crate";
}

class TomatoCrate extends Usable {
  Item use(Item current) {
    return current.combine(Tomato());
  }

  String get name => "tomato crate";
}

class BunCrate extends Usable {
  Item use(Item current) {
    return current.combine(Bun());
  }

  String get name => "bun crate";
}

class MeatCrate extends Usable {
  Item use(Item current) {
    return current.combine(Meat());
  }

  String get name => "meat crate";
}

class Table extends Usable {
  Item thing = NoItem();
  Item use(Item current) {
    if (current.name == "no item") {
      var tthing = thing;
      thing = NoItem();
      return tthing;
    }
    thing = current.combine(thing);
    return NoItem();
  }

  String get name => "table with ${thing.name}";
}

class Cooker extends Usable {
  Item use(Item current) {
    if (current.name == "meat") return CookedMeat();
    return current;
  }

  String get name => "cooker";
}

class Trash extends Usable {
  Item use(Item current) => NoItem();
  String get name => "trash";
}
