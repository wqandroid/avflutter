import 'package:flutter/material.dart';
import 'package:flutter_app/beans/MoveBase.dart';
import 'MoveCenter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'MoveListPageByLink.dart';

class ActorListPage extends StatefulWidget {
  ActorListPage();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ActorListPage();
  }
}

class _ActorListPage extends State<ActorListPage> {
  static List<Actress> items = new List();
  ScrollController _controller = new ScrollController();
  static int page = 1;
  bool isLoading;

  MoveCenter moveCenter = new MoveCenter();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels && items.length > 10 && !isLoading) {
        print("加载更多");
        page++;
        _onRefresh();
      }
    });

    _onRefresh();
  }

  Future<Null> _onRefresh() async {
    isLoading = true;
    print("开始刷新$page");
    moveCenter.getActresses(page).then((data) {
      setState(() {
        if (data != null) {
          if (page == 1) {
            items.clear();
          }
          isLoading = false;
          items.addAll(data);
          items.forEach((e) {
            print("头像:${e.imageUrl}");
          });
        } else {
          final snackBar = new SnackBar(content: new Text('加载出错!'));
          Scaffold.of(context).showSnackBar(snackBar);
        }
        return null;
      });
    });
  }

  _goMoveList(String title,String link){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MoveListPageByLink(title,link)));
  }

  Widget buildCardInfo(Actress avt) {
    return Card(
        color: Colors.white,
        child: GridTile(
          child: GestureDetector(
            onTap:()=> _goMoveList(avt.name,avt.link),
            child:  CachedNetworkImage(
              imageUrl: avt.imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          footer: GridTileBar(
            backgroundColor:Colors.black45 ,
            title: Text(
              avt.name.trim(),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("作者"),
      ),
      body: RefreshIndicator(
          child: GridView.custom(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 4.0, crossAxisSpacing: 4.0),
            childrenDelegate: SliverChildBuilderDelegate((cotent, index) {
              return buildCardInfo(items[index]);
            }, childCount: items.length),
            controller: _controller,
          ),
          onRefresh: _onRefresh),
    );
  }
}
