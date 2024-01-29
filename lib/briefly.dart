import 'package:flutter/material.dart';
import 'package:briefly/gnews_adaptor.dart';

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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: composeHomePageWidgets(),
      builder: (context, AsyncSnapshot<List<Widget>?> snapshot) {
        var bodyWidget = <Widget>[];

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // Handle error state if needed
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (snapshot.data != null) {
          bodyWidget = bodyWidget + snapshot.data!;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: Colors.blue,
            strokeWidth: 4.0,
            onRefresh: () async {},
            child: ListView.builder(
              itemCount: bodyWidget.length,
              itemBuilder: (BuildContext context, int index) {
                return bodyWidget[index];
              },
            ),
          ),
        );
      },
    );
  }

  Future<List<Widget>> composeHomePageWidgets() async {
    var adaptor = GNewsAdaptor(context: context);
    var headlines = await adaptor.getHeadlines(10);
    var carousel = await adaptor.getHeadlinesCarousel(5);

    return carousel + headlines;
  }
}
