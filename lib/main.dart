import 'package:flutter/material.dart';
import 'package:selector/Tape.dart';

void main() {
  runApp(new MaterialApp(
      home: new Scaffold(
    appBar: new AppBar(
      title: new Text("Test"),
    ),
    body: new Tape(),
  )));
}
