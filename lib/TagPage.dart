// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'MoveCenter.dart';
import 'beans/MoveBase.dart';
import 'MoveListPageByLink.dart';

class ScrollableTabsTags extends StatefulWidget {
  @override
  ScrollableTabsDemoState createState() => ScrollableTabsDemoState();
}

class ScrollableTabsDemoState extends State<ScrollableTabsTags>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  MoveCenter moveCenter = new MoveCenter();

  Map<String, List<Genre>> map;

  List<String> title = ["主题", "角色", "服装", "体型", "行为", "玩法", "其他", "场所"];

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: title.length);
    _LoadTags();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _LoadTags() {
    moveCenter.getTags().then((data) {
      map = data;
      title = map.keys.toList();
      setState(() {});
    });
  }

  // ignore: missing_return
  Widget getTabContent(List<Genre> tags) {
    if (tags != null) {
      return GridView.count(
        padding: EdgeInsets.all(5),
        //一行多少个
        crossAxisCount: 2,
        //滚动方向
        scrollDirection: Axis.vertical,
        // 左右间隔
        crossAxisSpacing: 10.0,
        // 上下间隔
        mainAxisSpacing: 10.0,
        //宽高比
        childAspectRatio: 4 / 1,
        children: List.generate(tags.length, (index) {
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey, width: 1)),
              child: Center(
                child: Text(tags[index].name, textAlign: TextAlign.center),
              ),
            ),
            onTap: () {
              print(tags[index].name);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MoveListPageByLink(
                          tags[index].name, tags[index].link)));
            },
          );
        }),
      );
    } else {
      return Container(
        child: Center(
          child: Text("laoding"),
        ),
      );
    }
  }

  List<Widget> getTab() {
    if (map != null && map.length > 0) {
      return map.keys.map((s) {
        return getTabContent(map[s]);
      }).toList();
    } else {
      return title.map((s) {
        return Center(
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text('正在加载....'),
              ),
            ],
          )),
        );
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分类'),
        bottom: TabBar(
          controller: _controller,
          labelColor: Colors.white,
          isScrollable: true,
          tabs: title.map<Tab>((s) {
            return new Tab(
              text: s,
            );
          }).toList(),
        ),
      ),
      body: TabBarView(controller: _controller, children: getTab()),
    );
  }
}
