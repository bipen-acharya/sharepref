import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  late SharedPreferences prefs;

  @override
  void initState() {
    intializePref();
    super.initState();
  }

  int _counter = 0;

  void intializePref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('count') ?? _counter;
    });
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await prefs.setInt('count', _counter);
  }

  @override
  Widget build(BuildContext context) {
    intializePref();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
