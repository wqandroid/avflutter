import 'dart:async';

import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

import 'Move.dart';
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

  Future getMove(int page) async {
    String url = "https://avsox.net/cn/popular/page/$page";
    try {
      var client =new http.Client();
      var response = await client.get(url);
      var document = parse(response.body);

      List<Element> eles = document.querySelectorAll("a[class*=movie-box]");
      List<Move> moves=[];
      int lens=eles.length;
      print("eles_size$lens");
      eles.forEach((box) {
        Element img = box.querySelector("div.photo-frame > img");
        Element span = box.querySelector("div.photo-info > span");
        bool hot = span.getElementsByTagName("i").length > 0;
        var date = span.querySelectorAll("date");
        Move move=new Move(img.attributes["title"], date[0].text, date[1].text, img.attributes["src"], box.attributes["href"],hot);
        moves.add(move);
        print("数据组装完成%");
      });
      return moves;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
