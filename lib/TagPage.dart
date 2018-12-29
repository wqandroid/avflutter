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

  Widget getTabContent(List<Genre> tags) {
    if (tags == null) {
      return Container(
        child: Text("laoding"),
      );
    } else {
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
          return Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey, width: 1)),
            child: Center(
              child: Text(tags[index].name, textAlign: TextAlign.center),
            ),
          );
        }),
      );
    }
  }

  //              onTap: _onGoLink(tags[index])
  _onGoLink(Genre g) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MoveListPageByLink(g.name, g.link)));
  }

  List<Widget> getTab() {
    if (map == null) {
      return [
        Container(
          child: Text("laoding"),
        ),
      ];
    } else {
      return map.keys.map((s) {
        return getTabContent(map[s]);
      }).toList();
    }
  }

  List<Widget> _getTopTab() {
    if (map == null) {
      return [
        Container(
          child: Text("laoding"),
        ),
      ];
    } else {
      return map.keys.map((s) {
        return getTabContent(map[s]);
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
