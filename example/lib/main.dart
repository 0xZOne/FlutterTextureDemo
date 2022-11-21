import 'package:flutter/material.dart';

import 'texture_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _width = 300.0;
  final _height = 200.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OpenGL via Texture widget example'),
        ),
        // body: Center(
        //   child: TextureWidget(width: _width, height: _height),
        // ),
        body: Center(
          child: Stack(
            children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(height: _height),
                padding: const EdgeInsets.all(8.0),
                color: Colors.red[600],
                alignment: Alignment.center,
                child: TextureWidget(width: _width, height: _height),
              ),
              Opacity(
                opacity: 0.85,
                child: Container(
                  constraints: BoxConstraints.expand(height: _height / 2),
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.blue[600],
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(0.2),
                  child: Text('Flutter UI',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
