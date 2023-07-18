import 'package:flutter/material.dart';
import 'package:on_screen_keyboard/on_screen_keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'On-Screen minimalistic numerical keyboard demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
          title: 'On-Screen minimalistic numerical keyboard demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int?> cells = [];

  late KeyboardController<int?> keyboardController;

  @override
  void initState() {
    cells = List<int?>.generate(
      1,
      (_) => null,
    );

    keyboardController = KeyboardController<int?>(
      values: cells,
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: ColoredBox(
          color: const Color(0xffECE6E9),
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Type below to enter some numbers:',
                    ),
                    Text(
                      cells.map((cell) => '$cell').join(''),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: OnScreenKeyboard<int?>(
                      onValuesChanged: (values) {
                        setState(() {
                          print("values: $values");
                          cells = values;
                        });
                      },
                      controller: keyboardController,
                      focusedValueIndex: 0))
            ],
          ),
        ),
      ),
    );
  }
}
