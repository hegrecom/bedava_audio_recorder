import 'package:flutter/material.dart';

class TabbedScreen extends StatefulWidget {
  @override
  _TabbedScreenState createState() => _TabbedScreenState();
}

class _TabbedScreenState extends State<TabbedScreen>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    Tab(
      text: 'Record',
      icon: Icon(Icons.mic),
    ),
    Tab(
      text: 'List',
      icon: Icon(Icons.list),
    ),
    Tab(
      text: 'Settings',
      icon: Icon(Icons.settings),
    ),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        tabs: tabs,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            child: Text('1'),
          ),
          Center(
            child: Text('2'),
          ),
          Center(
            child: Text('3'),
          ),
        ],
      ),
    );
  }
}
