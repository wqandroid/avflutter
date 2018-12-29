import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'Move.dart';
import 'MoveCenter.dart';
import 'beans/MoveBase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'VideoPlayPage.dart';
import 'MoveListPageByLink.dart';

class _ContactCategory extends StatelessWidget {
  const _ContactCategory({Key key, this.icon, this.children}) : super(key: key);

  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: themeData.dividerColor))),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  width: 72.0,
                  child: Icon(icon, color: themeData.primaryColor)),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children))
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  _ContactItem({Key key, this.icon, this.lines, this.tooltip, this.onPressed})
      : assert(lines.length > 1),
        super(key: key);

  final IconData icon;
  final List<String> lines;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> columnChildren = lines
        .sublist(0, lines.length - 1)
        .map<Widget>((String line) => Text(line))
        .toList();
    columnChildren.add(Text(lines.last, style: themeData.textTheme.caption));

    final List<Widget> rowChildren = <Widget>[
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren))
    ];
    if (icon != null) {
      rowChildren.add(SizedBox(
          width: 72.0,
          child: IconButton(
              icon: Icon(icon),
              color: themeData.primaryColor,
              onPressed: onPressed)));
    }
    return MergeSemantics(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren)),
    );
  }
}

class ContactsDemo extends StatefulWidget {
  static const String routeName = '/contacts';

  final Move move;

  ContactsDemo(this.move);

  @override
  ContactsDemoState createState() => ContactsDemoState(move);
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class CellTitleDetail extends StatelessWidget {
  Move move;
  MoveDetailInfo detailInfo;

  CellTitleDetail(this.move, this.detailInfo);

  List<Widget> buildHeadInfo(BuildContext context, List<Header> infos) {
    List<Widget> wind = [];
    infos.forEach((head) {
      wind.add(_ContactItem(
        icon: head.link == null ? null : Icons.arrow_forward_ios,
        tooltip: head.name,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MoveListPageByLink(head.name, head.link)));
        },
        lines: <String>[
          head.name,
          head.value,
        ],
      ));
    });
    return wind;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    List<Header> hedears = [];
    hedears.add(Header("影片名", move.title, null));
    hedears.add(Header("识别码", move.code, null));
    hedears.add(Header("发行时间", move.date, null));

    if (detailInfo != null) {
      detailInfo.headers.forEach((h) {
        hedears.add(Header(h.name, h.value, h.link));
      });
    }
    return MergeSemantics(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: buildHeadInfo(context, hedears)),
    );
  }
}

class ContactsDemoState extends State<ContactsDemo> {
  final double _appBarHeight = 256.0;

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  Move move;

  static const platform = const MethodChannel("samples.flutter.io/sign");

  ContactsDemoState(this.move);

  MoveDetailInfo moveDetailInfo;

  static String dialogcontent;

  AVinfo aVinfo;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MoveCenter().getMoveDetailInfo(move.link).then((d) {
      if (d != null) {
        MoveCenter().getAVG(move.code).then((res) {
          setState(() {
            aVinfo = res;
          });
        });
      }
      setState(() {
        moveDetailInfo = d;
      });
    });
  }

  List<Widget> crateAvatarInfo(BuildContext context,List<Actress> actresses) {
    List<Widget> items = [];
    actresses.forEach((avt) {
      print(avt.imageUrl);
      print(avt.name.trim());
      items.add(Card(
        color: Colors.white,
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MoveListPageByLink(avt.name, avt.link)));
          },
          child: Column(
            children: <Widget>[
              new CachedNetworkImage(
                imageUrl: avt.imageUrl,
                placeholder: new Image.asset(
                  "images/def_avatar.png",
                  width: 90,
                  height: 90,
                ),
                fit: BoxFit.cover,
                width: 90,
                height: 90,
                errorWidget: new Image.asset(
                  "images/def_avatar.png",
                  width: 90,
                  height: 90,
                ),
              ),
              Text(avt.name.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.start)
            ],
          ),
        ),
      ));
    });
    return items;
  }

  List<Widget> buildAvatarInfo(BuildContext context) {
    List<Widget> windets = [];
    if (moveDetailInfo == null) {
      windets.add(new CircularProgressIndicator());
      return windets;
    } else {
      if (moveDetailInfo != null && moveDetailInfo.actresses.length > 0) {
        windets.add(new Row(children: crateAvatarInfo(context,moveDetailInfo.actresses)));
      } else {
        print("meitoux");
        windets.add(Container(
          height: 72,
          child: Center(
            child: new Text("没有头像信息"),
          ),
        ));
      }
    }
    return windets;
  }

  List<Widget> buildTags(BuildContext context,) {
    List<Widget> windets = [];
    if (moveDetailInfo == null) return windets;
    if (moveDetailInfo.genres != null && moveDetailInfo.genres.length > 0) {
      windets.add(Wrap(
        children: creatTags(context,moveDetailInfo.genres),
      ));
    } else {
      windets.add(Container(
        height: 72,
        child: Center(child: new Text("没有标签分类"),),));
    }
    return windets;
  }

  List<Widget> creatTags(BuildContext context,List<Genre> genres) {
    List<Widget> windets = [];
    genres.forEach((tag) {
      print(tag.name);
      windets.add(Padding(
          padding: EdgeInsets.all(2.0),
          child: new ActionChip(label: new Text(tag.name), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MoveListPageByLink(tag.name, tag.link)));
          })));
    });
    return windets;
  }

  List<Widget> buildScreenShoot() {
    List<Widget> windets = [];
    if (moveDetailInfo == null ) {
      return [Container(
        height: 72,
        child: Center(child: new Text("没有影片截图"),),)];
    }

    if(moveDetailInfo.screenshots.isEmpty){
      return [Container(
        height: 72,
        child: Center(child: new Text("没有影片截图"),),)];
    }

    windets.add(Wrap(
      children: creatScreenShootItems(moveDetailInfo.screenshots),
    ));
    return windets;
  }

  List<Widget> creatScreenShootItems(List<Screenshot> screenshots) {
    print("缩率图:${screenshots.length}");
    List<Widget> windets = [];
    screenshots.forEach((e) {
      windets.add(Padding(
        padding: EdgeInsets.all(4),
        child: new CachedNetworkImage(
          imageUrl: e.thumbnailUrl,
          fit: BoxFit.cover,
          width: 56,
          height: 56,
          errorWidget:
              new Image.asset("images/def_avatar.png", width: 56, height: 56),
          placeholder: new Container(color: Colors.grey, width: 56, height: 56),
        ),
      ));
    });
    return windets;
  }

  Future doPlay(String vid) async {
    Map<String, dynamic> args = {
      "vid": vid,
    };
    await platform.invokeMethod("getsign", args).then((url) {
    });
  }

  Future doPreview(String url)async{
    Map<String, dynamic> args = {
      "url": url,
    };
    await platform.invokeMethod("preview", args).then((url) {
    });
  }


  Widget buildVideoUrlPlay() {

    if(aVinfo == null){
      return LinearProgressIndicator(backgroundColor: Colors.pink,valueColor: AlwaysStoppedAnimation(Colors.green));
    }
    var color = aVinfo .videoId==null ? Colors.grey : Colors.pink;

    var widget = IconButton(icon: Icon(aVinfo.videoId==null?Icons.error:Icons.play_arrow,color: color,),
     onPressed: aVinfo.videoId==null?null:(){
      doPlay(aVinfo.videoId);
    },);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 180,
          height: 80,
          child: Center(
            child: IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: color,
                ),
                onPressed: () {
                  doPreview(aVinfo.previewUrl);
                }),
          ),
        ),
        Container(
          width: 180,
          height: 80,
          child: Center(
            child:widget,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        platform: Theme.of(context).platform,
      ),
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: _appBarBehavior == AppBarBehavior.pinned,
              floating: _appBarBehavior == AppBarBehavior.floating ||
                  _appBarBehavior == AppBarBehavior.snapping,
              snap: _appBarBehavior == AppBarBehavior.snapping,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.star),
                  tooltip: 'Edit',
                  onPressed: () {
                   
                  },
                ),
                PopupMenuButton<AppBarBehavior>(
                  onSelected: (AppBarBehavior value) {
                    setState(() {
                      _appBarBehavior = value;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<AppBarBehavior>>[
                        const PopupMenuItem<AppBarBehavior>(
                            value: AppBarBehavior.normal,
                            child: Text('App bar scrolls away')),
                        const PopupMenuItem<AppBarBehavior>(
                            value: AppBarBehavior.pinned,
                            child: Text('App bar stays put')),
                        const PopupMenuItem<AppBarBehavior>(
                            value: AppBarBehavior.floating,
                            child: Text('App bar floats')),
                        const PopupMenuItem<AppBarBehavior>(
                            value: AppBarBehavior.snapping,
                            child: Text('App bar snaps')),
                      ],
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(move.code),
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.network(
                      move.coverUrl,
                      fit: BoxFit.cover,
                      height: _appBarHeight,
                    ),
                    // This gradient ensures that the toolbar icons are distinct
                    // against the background image.
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, -0.4),
                          colors: <Color>[Color(0x60000000), Color(0x00000000)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                buildVideoUrlPlay(),
                Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.dark,
                  child: _ContactCategory(
                    icon: Icons.movie,
                    children: <Widget>[
                      CellTitleDetail(move, moveDetailInfo),
                    ],
                  ),
                ),
                _ContactCategory(
                  icon: Icons.face,
                  children: buildAvatarInfo(context),
                ),
                _ContactCategory(
                  icon: Icons.photo,
                  children: buildScreenShoot(),
                ),
                _ContactCategory(icon: Icons.label, children: buildTags(context)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
