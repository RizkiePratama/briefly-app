import 'package:flutter/material.dart';
import 'package:gnews/gnews.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:briefly_app/briefly_webview.dart';

class GNewsAdaptor {
  GNewsAdaptor({required this.context });
  var service = GNewsScrap();
  BuildContext context;

  Future<List<Widget>> getHeadlines() async {
    var headlines = await service.getHeadlines();
    List<Widget> cards = [];

    await Future.forEach(headlines.getRange(0, 5).toList(), (headline) async {
      if (headline != null) {
        Widget title = Text(
          headline['title'],
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        );
        var post_date = DateTime.parse(headline['publish_at']);
        var date_formater = DateFormat('dd MMMM yyyy');
        Widget published_at = Text('Posted at ' + date_formater.format(post_date));

        Widget thumbnail_image;
        if(headline.containsKey('thumbnail_url') && headline['thumbnail_url'] != null) {
          thumbnail_image = Image(
              width: 150,
              image: NetworkImage(headline['thumbnail_url'])
          );
        } else {
          thumbnail_image = SizedBox(width: 10);
        }
        var target_url = await _getRealURL(headline['article_path']);
        print(target_url);
        Widget card = Expanded(
            child: GestureDetector(
                onTap: () {
                  //_launchUrl(headline['article_path']);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BrieflyAppWebView(url: target_url)
                      )
                  );
                },
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 10),
                    thumbnail_image,
                    SizedBox(width: 10),
                    Expanded(
                      child: Wrap(
                        runSpacing: 10,
                        children: [
                          title,
                          published_at
                        ],
                      )
                    ),
                  ],
                )
            )
        );
        cards.add(card);
      };
    });

    return cards;
  }

  Future<void> _launchUrl(String target) async {
    var target_post_uri = await _getRealURL(target);

    if (!await launchUrl(Uri.parse(target_post_uri))) {
      throw Exception('Could not launch $target');
    }
  }

  Future<String> _getRealURL(String target) async {
    var target_post = await service.getNewsPost(target);
    return target_post?['url'];
  }
}