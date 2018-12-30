import 'package:flutter/material.dart';
import 'Move.dart';
import 'MoveCenter.dart';
import 'MoveDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'util/VlaueChange.dart';

class MoveListPage extends StatefulWidget {
  final ValueNotifierData data;

  MoveListPage(this.data);

  _MoveListPageState page;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MoveListPageState();
  }
}

class _MoveListPageState extends State<MoveListPage> {
  static List<Move> items = new List();
  ScrollController _controller = new ScrollController();
  static int page = 1;
  bool isLoading;
  bool isLoadMore = false;

  String type = "popular";
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
        _onRefresh(true);
      }
    });
    _onRefresh(false);

    widget.data.addListener(() {
      var newValue = widget.data.value;

      print("收到传递:$newValue");

      var isNeedLoad = type == newValue;

      print("load$isNeedLoad");

      setState(() {
        type = widget.data.value;
        page = 1;
        _onRefresh(false);
      });
    });
  }

  Widget _renderRow(BuildContext context, int index) {
//        width: 90, height: 160, fit: BoxFit.fill)

    if (isLoadMore && index >= items.length) {
      return LinearProgressIndicator(
        backgroundColor: Colors.pink,
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => ContactsDemo(items[index])));
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
                  child: new CachedNetworkImage(
                    imageUrl: items[index].coverUrl,
                    width: 90.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                    placeholder: Container(
                      width: 90.0,
                      height: 120.0,
                      color: Colors.grey,
                    ),
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

  Future<Null> _onRefresh(bool isLoadMore) async {
    setState(() {
      isLoading = true;
      this.isLoadMore = isLoadMore;
      if (!isLoadMore) {
        items.clear();
      }
    });
    print("开始刷新$page");
    moveCenter.getMove(type, page).then((data) {
      setState(() {
        if (data != null) {
          isLoading = false;
          items.addAll(data);
        } else {
          final snackBar = new SnackBar(content: new Text('加载出错!'));
          Scaffold.of(context).showSnackBar(snackBar);
          setState(() {
            this.isLoadMore = false;
            isLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty && isLoading) {
      return Scaffold(
        body: Container(
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text('正在加载....别慌'),
              ),
            ],
          )),
        ),
      );
    } else {
      return new RefreshIndicator(
          child: ListView.builder(
              itemCount:
                  (isLoadMore && isLoading) ? items.length + 1 : items.length,
              padding: EdgeInsets.only(top: 6, bottom: 6),
              controller: _controller,
              physics: new AlwaysScrollableScrollPhysics(),
              itemBuilder: _renderRow),
          onRefresh: () {
            _onRefresh(false);
          });
    }
  }
}
