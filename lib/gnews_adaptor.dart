import 'package:flutter/material.dart';
import 'package:gnews/gnews.dart';
import 'package:intl/intl.dart';
import 'package:briefly_app/briefly_webview.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class GNewsAdaptor {
  var service = GNewsScrap();
  BuildContext context;
  List<Map<String, dynamic>?> _headlines = [];

  GNewsAdaptor({required this.context});

  Future<List<Widget>> getHeadlines([int? limit]) async {
    _headlines = await service.getHeadlines();

    limit ??= _headlines.length;

    List<Widget> cards = [];
    await Future.forEach(_headlines.getRange(0, limit).toList(), (headline) async {
      if (headline != null) {
        Widget title = Text(
          headline['title'],
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        );
        var postDate = DateTime.parse(headline['publish_at']);
        var dateFormater = DateFormat('dd MMMM yyyy');
        Widget publishedAt = Text('Posted at ${dateFormater.format(postDate)}');

        Widget thumbnailImage;
        if (headline.containsKey('thumbnail_url') && headline['thumbnail_url'] != null) {
          thumbnailImage = Image(width: 150, image: NetworkImage(headline['thumbnail_url']));
        } else {
          thumbnailImage = const SizedBox(width: 10);
        }

        var targetURL = await _getRealURL(headline['article_path']);
        Widget card = GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BrieflyAppWebView(url: targetURL)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 10),
                thumbnailImage,
                const SizedBox(width: 10),
                Expanded(
                    child: Wrap(
                  runSpacing: 10,
                  children: [title, publishedAt],
                )),
              ],
            ));
        cards.add(card);
        cards.add(const SizedBox(height: 10));
      }
    });

    return cards;
  }

  Future<List<Widget>> getHeadlinesCarousel([int? limit]) async {
    var carousels = <Widget>[];

    limit ??= 5;

    await Future.forEach(_headlines.getRange(0, limit).toList(), (headline) async {
      carousels.add(Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                image: DecorationImage(
                  image: NetworkImage(headline?['thumbnail_url']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(headline?['title'], style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white)),
                    )))
          ])));
    });

    return [
      const SizedBox(height: 20),
      FlutterCarousel(
        options: CarouselOptions(
          height: 200.0,
          showIndicator: false,
        ),
        items: carousels.map((carousel) {
          return Builder(
            builder: (BuildContext context) {
              return carousel;
            },
          );
        }).toList(),
      ),
      const SizedBox(height: 10),
    ];
  }

  Future<String> _getRealURL(String path) async {
    var service = GNewsScrap();
    var targetPost = await service.getNewsPost(path);
    return targetPost?['url'];
  }
}
