import 'package:flutter/material.dart';

import 'texture_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final double _width = 300;
  final double _height = 120;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Metal via Texture widget example'),
        ),
        body: ListView.builder(
            itemCount: 150,
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                height: 150,
                margin: const EdgeInsets.all(20),
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
              );
            }),
      ),
    );
  }
}
