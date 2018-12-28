import 'dart:async';

import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

import 'Move.dart';
import 'beans/MoveBase.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class MoveCenter {
//  for (Element box : document.select("a[class*=movie-box]")) {
//  Element img = box.select("div.photo-frame > img").first();
//  Element span = box.select("div.photo-info > span").first();
//
//  boolean hot = span.getElementsByTag("i").size() > 0;
//
//  Elements date = span.select("date");
//
//  movies.add(
//  Movie.create(
//  img.attr("title"),  //标题
//  date.get(0).text(), //番号
//  date.get(1).text(), //日期
//  img.attr("src"),    //图片地址
//  box.attr("href"),   //链接
//  hot                 //是否热门
//  )
//  );
//  }
// AVMOO 日本  https://avmoo.xyz
// AVMOO 日本无码  https://avsox.net

  static const String baseUrl1="https://avmoo.xyz";
  static const String baseUrl2="https://avsox.net";


  Future getMove(int page) async {


    String url = "$baseUrl2/cn/popular/page/$page";
    try {
      var client = new http.Client();
      var response = await client.get(url);
      var document = parse(response.body);

      List<Element> eles = document.querySelectorAll("a[class*=movie-box]");
      List<Move> moves = [];
      int lens = eles.length;
      print("eles_size$lens");
      eles.forEach((box) {
        Element img = box.querySelector("div.photo-frame > img");
        Element span = box.querySelector("div.photo-info > span");
        bool hot = span.getElementsByTagName("i").length > 0;
        var date = span.querySelectorAll("date");
        Move move = new Move(img.attributes["title"], date[0].text,
            date[1].text, img.attributes["src"], box.attributes["href"], hot);
        moves.add(move);
        print("数据组装完成%");
      });
      return moves;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getMoveDetailInfo(String link) async {
    print("get__:$link");
    try {
      var client = new http.Client();
      var response = await client.get(link);
      var document = parse(response.body);

      MoveDetailInfo moveDetailInfo = new MoveDetailInfo();

      moveDetailInfo.title = document.querySelector("div.container > h3").text;
      moveDetailInfo.coverUrl =
          document.querySelector("[class=bigImage]").attributes["href"];

      List<Element> boxs = document.querySelectorAll("[class*=sample-box]");
      boxs.forEach((box) {
        String thumbnailUrl =
            box.getElementsByTagName("img")[0].attributes["src"];
        String link = box.attributes["href"];
        print("缩略图:$thumbnailUrl");
        moveDetailInfo.screenshots.add(Screenshot(thumbnailUrl, link));
      });

      List<Element> attresses =
          document.querySelectorAll("[class*=avatar-box]");

      print("演员信息:${attresses.length}");

      attresses.forEach((box) {
        moveDetailInfo.actresses.add(new Actress(
            box.text,
            box.getElementsByTagName("img")[0].attributes["src"],
            box.attributes["href"]));
      });
      //Parsing Headers

      Element info = document.querySelectorAll("div.info").first;

      if (info != null) {
//        print("开始解析header${info.outerHtml}");
//        info.querySelectorAll("p:not([class*=header]):has(span:not([class=genre]))")
//            .forEach((e){
//          var strings = e.text.split(":");
//          moveDetailInfo.headers.add(Header(   strings[0].trim(),
//              strings.length > 1 ? strings[1].trim() : "",
//              null));
//        });
        var headerNames = [];
        List<List<String>> headerAttr = [];
        info.querySelectorAll("p[class*=header]").forEach((e) {
          headerNames.add(e.text.replaceAll(":", ""));
        });

        info.querySelectorAll("p > a").forEach((e) {
          List<String> strs = [];
          strs.add(e.text);
          strs.add(e.attributes["href"]);
          headerAttr.add(strs);
        });
        int size = headerNames.length < headerAttr.length
            ? headerNames.length
            : headerAttr.length;
        for (int i = 0; i < size; i++) {
          moveDetailInfo.headers.add(Header(headerNames[i],
              headerAttr[i][0].trim(), headerAttr[i][1].trim()));
        }
        info.querySelectorAll("* > [class=genre] > a").forEach((e) {
          moveDetailInfo.genres.add(new Genre(e.text, e.attributes["href"]));
        });
      }
//      print(response.body);
      return moveDetailInfo;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> getAVG(String key) async {
    String videoUrl;
    try {
      String url = "http://api.rekonquer.com/psvs/search.php?kw=$key";
      print("请求地址:$url");
      var client = new http.Client();
      var response = await client.get(url);
//      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> avg = json.decode(response.body);
        bool success = avg["success"];

        Map<String, dynamic> responseJson = avg["response"];

        int total_videos = responseJson["total_videos"];

        if (success && total_videos > 0) {
          Map<String, dynamic> video = responseJson["videos"][0];
          String vid = video["vid"];
          videoUrl = video["preview_video_url"];
          print("播放地址:$videoUrl");
          return vid;
        }
      }
    } catch (e) {
      print(e);
    }
    return videoUrl;
  }


}
