import 'package:flutter/material.dart';
import 'package:briefly_app/gnews_adaptor.dart';

class BrieflyApp extends StatelessWidget {
  const BrieflyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Briefly News',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'BRIEFLY'),
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
  void _incrementCounter() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    var adaptor = GNewsAdaptor(context: context);
    return FutureBuilder<List<Widget>>(
        future: adaptor.getHeadlines(),
        builder: (context, AsyncSnapshot<List<Widget>?> snapshot) {
          List<Widget> body_widget = [];
          if (snapshot.data != null) {
            body_widget = snapshot.data!;
          } else {
            body_widget = <Widget>[CircularProgressIndicator()];
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: body_widget
              ),
            ),
          );
        }
    );
  }
}