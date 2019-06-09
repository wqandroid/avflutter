import 'package:flutter/material.dart';

import 'MoveListPage.dart';
import 'MoveListPageByLink.dart';
import 'util/VlaueChange.dart';
import 'ActorListPage.dart';
import 'TagPage.dart';
import 'MoveCenter.dart';

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
          primarySwatch: Colors.pink,
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

  static var itemTextStyle =
      TextStyle(fontWeight: FontWeight.w600, color: Colors.black54);

  static var itemTextSelStyle =
      TextStyle(fontWeight: FontWeight.w600, color: Colors.blue);

  static int oldIndexPage = PAGE_HOT;

  _chanList(int indexPage) {
    print("修改列:$indexPage");

    if (indexPage == PAGE_ACTRESS) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => new ActorListPage()));
      return;
    }

    if (indexPage == PAGE_TAG) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => new ScrollableTabsTags()));
      return;
    }

    if (oldIndexPage == indexPage) return;

    setState(() {
      if (indexPage == PAGE_HOT) {
        vd.value = "popular";
      } else if (indexPage == PAGE_HOME) {
        vd.value = "";
      } else if (indexPage == PAGE_RELEASE) {
        vd.value = "released";
      }
      oldIndexPage = indexPage;
    });
    Navigator.pop(context);
  }

  TextStyle _getTextStype(int indexPage) {
    if (oldIndexPage == indexPage) {
      return itemTextSelStyle;
    } else {
      return itemTextStyle;
    }
  }


  _MySearchDelegate _delegate;

  @override
  void initState() {
    super.initState();
    _delegate = _MySearchDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String selected = await showSearch<String>(
                context: context,
                delegate: _delegate,
              );
              if (selected != null) {
                  Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You have selected the word: $selected'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: MoveListPage(vd),
      drawer: Drawer(
        semanticLabel: "lavr",
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("WangQiong"),
              accountEmail: Text("wqandroid@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("images/mine_avatar.png"),
                backgroundColor: Colors.white,
              ),
            ),
            ListTile(
              title: Text(
                "主页",
                style: _getTextStype(PAGE_HOME),
              ),
              leading: Icon(Icons.home),
              onTap: () => _chanList(PAGE_HOME),
            ),
            ListTile(
                title: Text("热门", style: _getTextStype(PAGE_HOT)),
                leading: Icon(Icons.whatshot),
                onTap: () => _chanList(PAGE_HOT)),
            ListTile(
                title: Text("已发布", style: _getTextStype(PAGE_RELEASE)),
                leading: Icon(Icons.group_work),
                onTap: () => _chanList(PAGE_RELEASE)),
            ListTile(
                title: Text("女优", style: itemTextStyle),
                leading: Icon(Icons.face),
                onTap: () => _chanList(PAGE_ACTRESS)),
            ListTile(
                title: Text("类别", style: itemTextStyle),
                leading: Icon(Icons.loyalty),
                onTap: () => _chanList(PAGE_TAG)),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// Defines the content of the search page in `showSearch()`.
// SearchDelegate has a member `query` which is the query string.
class _MySearchDelegate extends SearchDelegate<String> {


  // Leading icon in search bar.
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        // SearchDelegate.close() can return vlaues, similar to Navigator.pop().
        this.close(context, null);
      },
    );
  }

  String buildSearchUrl(){
    return MoveCenter.baseUrl1+"/cn"+ "/search/$query";
  }

  // Widget of result page.
  @override
  Widget buildResults(BuildContext context) {



    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('点击搜索:'),
            GestureDetector(
              onTap: () {
                // Returns this.query as result to previous screen, c.f.
                // `showSearch()` above.
                this.close(context, this.query);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MoveListPageByLink("搜索$query",buildSearchUrl() )));
              },
              child: Text(
                this.query,
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Suggestions list while typing (this.query).


  // Action buttons at the right of search bar.
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? IconButton(
              tooltip: 'Voice Search',
              icon: const Icon(Icons.mic),
              onPressed: () {
                this.query = 'TODO: implement voice input';
              },
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    final Iterable<String> suggestions=<String>['波多野','西野翔'];

    return _SuggestionList(
      query: this.query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        this.query = suggestion;
        showResults(context);
      },
    );
  }
}

// Suggestions list widget displayed in the search page.
class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? Icon(Icons.history) : Icon(null),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
