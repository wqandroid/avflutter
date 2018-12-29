import 'package:flutter/material.dart';
import 'dart:io';
import 'MoveCenter.dart';
import 'Move.dart';

import 'MoveListPage.dart';
import 'package:event_bus/event_bus.dart';
import 'util/VlaueChange.dart';
import 'ActorListPage.dart';
import 'TagPage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.blue,
          backgroundColor: Colors.red,
          bottomAppBarColor: Colors.white,
          brightness: Brightness.light),
      home: new MyHomePage(title: 'AV图书馆'),
    );
  }
}

fun(String name, {int age = 24, String sex}) {
  print("$name,$age,$sex");
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ValueNotifierData vd = ValueNotifierData('Hello World');

  static const int PAGE_HOME = 1;
  static const int PAGE_HOT = 2;
  static const int PAGE_RELEASE = 3;
  static const int PAGE_ACTRESS = 4;
  static const int PAGE_TAG = 5;

  static var itemTextStyle=TextStyle(fontWeight: FontWeight.w600,color: Colors.black54);

  static var itemTextSelStyle=TextStyle(fontWeight: FontWeight.w600,color: Colors.blue);

  static int oldIndexPage=PAGE_HOME;

  _chanList(int indexPage){
    print("修改列:$indexPage");

    if(indexPage == PAGE_ACTRESS){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>new ActorListPage()));
      return;
    }

    if(indexPage == PAGE_TAG){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>new ScrollableTabsTags()));
      return;
    }

    if(oldIndexPage == indexPage)return;

    setState(() {
      if(indexPage == PAGE_HOT){
        vd.value="popular";
      }else if(indexPage == PAGE_HOME){
        vd.value="";
      }else if(indexPage == PAGE_RELEASE){
        vd.value="released";
      }
      oldIndexPage=indexPage;
    });
    Navigator.pop(context);
  }

  TextStyle _getTextStype(int indexPage){
    if(oldIndexPage == indexPage){
      return itemTextSelStyle;
    }else{
      return itemTextStyle;
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body:MoveListPage(vd),
      drawer: Drawer(
        semanticLabel: "lavr",
        child: Column(children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("WangQiong"),
            accountEmail: Text("wqandroid@gmail.com"),
            currentAccountPicture: CircleAvatar(backgroundImage: AssetImage("images/mine_avatar.png"),backgroundColor: Colors.white,),
          ),
          ListTile(title: Text("主页",style: _getTextStype(PAGE_HOME) ,),leading: Icon(Icons.home),onTap: ()=> _chanList(PAGE_HOME),),
          ListTile(title: Text("热门",style:_getTextStype(PAGE_HOT)),leading: Icon(Icons.whatshot),onTap: ()=> _chanList(PAGE_HOT)),
          ListTile(title: Text("已发布",style:_getTextStype(PAGE_RELEASE)),leading: Icon(Icons.group_work),onTap:  ()=>_chanList(PAGE_RELEASE)),
          ListTile(title: Text("女优",style:itemTextStyle),leading: Icon(Icons.face),onTap: ()=>_chanList(PAGE_ACTRESS)),
          ListTile(title: Text("类别",style:itemTextStyle),leading: Icon(Icons.loyalty),onTap: ()=>_chanList(PAGE_TAG)),
        ],),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
