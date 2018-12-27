import 'package:flutter/material.dart';
import 'Move.dart';
import 'MoveCenter.dart';
import 'MoveDetail.dart';

class MoveListPage extends StatefulWidget {
  const MoveListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MoveListPageState();
  }
}

class _MoveListPageState extends State<MoveListPage> {
  static List<Move> items = new List();
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



  Widget _renderRow(BuildContext context, int index) {
//        width: 90, height: 160, fit: BoxFit.fill)

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    ContactsDemo(items[index])));
      },
      child: Card(
          color: Colors.white,
          margin: EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.network(
                    items[index].coverUrl,
                    width: 90.0,
                    height: 120.0,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(left: 8, top: 8),
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      items[index].title, maxLines: 2,
                      style: TextStyle(fontSize: 16.0, color: Colors.black87),
                      overflow: TextOverflow
                          .ellipsis, //文字超出屏幕之后的处理方式  TextOverflow.clip剪裁   TextOverflow.fade 渐隐  TextOverflow.ellipsis省略号
                    ),
                    Text(
                      "番号:${items[index].code}",
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.ltr, //文本方向
                      style: TextStyle(fontSize: 13.0, color: Colors.black45),
                    ),
                    Text(
                      "时间:${items[index].date}",
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.ltr, //文本方向
                      style: TextStyle(fontSize: 13.0, color: Colors.black45),
                    )
                  ],
                ),
              ))
            ],
          )),
    );
  }

  Future<Null> _onRefresh() async {
    isLoading = true;
    print("开始刷新$page");
    moveCenter.getMove(page).then((data) {
      setState(() {
        if (data != null) {
          if (page == 1) {
            items.clear();
          }
          isLoading = false;
          items.addAll(data);
        } else {
          final snackBar = new SnackBar(content: new Text('加载出错!'));
          Scaffold.of(context).showSnackBar(snackBar);
        }
        return null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.only(top: 6, bottom: 6),
            controller: _controller,
            physics: new AlwaysScrollableScrollPhysics(),
            itemBuilder: _renderRow),
        onRefresh: _onRefresh);
  }
}

class MoveDetail extends StatelessWidget {
  final Move move;

  MoveDetail({Key key, this.move}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(title: Text(move.title)),
      body: Column(
        children: <Widget>[Image.network(move.coverUrl)],
      ),
    );
  }
}


