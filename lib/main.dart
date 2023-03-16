import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_app/providers/provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ListProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController = ScrollController();
  bool isScrolling = false;
  Random rnd = new Random();
  final List<String> _aa = [];
  bool autoAdd = false;

  void _incrementCounter() {
    List<String> list = [
      "03/22 08:51:01 INFO   :..settcpimage: Associate with TCP/IP image name = TCPCS",
      "03/22 08:51:06 INFO   :...read_physical_netif: index #6, interface LOOPBACK has address 127.0.0.1, ifidx 0",
      "03/22 08:51:06 INFO   :.....mailslot_create: \n creating mailslot for RSVP",
      "An Observatory debugger and profiler on iPhone 13 Pro Max is available at: http://127.0.0.1:63540/BEblksdVaQM=/The Flutter DevTools debugger and profiler on iPhone 13 Pro Max is available at: http://127.0.0.1:9102?uri=http://127.0.0.1:63540/BEblksdVaQM=/",
      "Running Xcode build...",
      "warning ../../../../package.json: No license field",
      "Port 8888 is in use, trying another one...",
    ];

    Provider.of<ListProvider>(context, listen: false)
        .setList(list[rnd.nextInt(list.length)]);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  Future<void> addXAmount(int num) async {
    for (var i = 0; i < num; i++) {
      await Future.delayed(const Duration(milliseconds: 100), () {
        _incrementCounter();
      });
    }
  }

  Future<void> addRandomly(int min, int max) async {
    var num = Random().nextInt(max - min) + min;
    print(num);
    addXAmount(num);
  }

  void autoAdding() {
    var second = Random().nextInt(5) + 1;
    var subSecond = 1;

    Timer.periodic(new Duration(seconds: 1), (timer) {
      if (autoAdd && second == subSecond) {
        second = Random().nextInt(5) + 1;
        subSecond = 0;
        addRandomly(1, 10);
      }
      subSecond += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    autoAdding();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(child: SafeArea(
            child: Consumer<ListProvider>(builder: (context, data, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // do something
            _scrollToBottom();
          });
          return Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: ListView(
              controller: _scrollController,
              children: Provider.of<ListProvider>(context, listen: false)
                  .data
                  .map((e) => Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          e,
                        ),
                      ))
                  .toList(),
            ),
          );
        }))),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => addRandomly(40, 50),
              tooltip: 'Increment',
              child: const Text('40-50'),
            ),
            FloatingActionButton(
              onPressed: () => addRandomly(10, 20),
              tooltip: 'Increment',
              child: const Text('10-20'),
            ),
            FloatingActionButton(
              onPressed: () => addXAmount(5),
              tooltip: 'Increment',
              child: const Text('5'),
            ),
            FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              onPressed: _scrollToBottom,
              tooltip: 'top',
              child: const Icon(Icons.arrow_downward),
            ),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  autoAdd = !autoAdd;
                });
              },
              tooltip: 'autoAdd',
              child: Icon(autoAdd ? Icons.check : Icons.close),
            ),
            Consumer<ListProvider>(builder: (context, data, child) {
              return Text(Provider.of<ListProvider>(context, listen: false)
                  .data
                  .length
                  .toString());
            })
          ],
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
