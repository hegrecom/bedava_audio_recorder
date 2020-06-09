import 'package:bedava_audio_recorder/screens/recorder_screen.dart';
import 'package:bedava_audio_recorder/screens/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:bedava_audio_recorder/constants.dart';
import 'package:bedava_audio_recorder/widgets/containerised_tab.dart';

class TabbedScreen extends StatefulWidget {
  @override
  _TabbedScreenState createState() => _TabbedScreenState();
}

class _TabbedScreenState extends State<TabbedScreen>
    with SingleTickerProviderStateMixin {
  final List<Widget> tabs = <Widget>[
    ContainerisedTab(
      height: kTabBarHeight,
      iconData: Icons.mic,
    ),
    ContainerisedTab(
      height: kTabBarHeight,
      iconData: Icons.list,
    ),
    ContainerisedTab(
      height: kTabBarHeight,
      iconData: Icons.settings,
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kTabBarHeight),
        child: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            child: RecorderScreen(),
          ),
          Center(
            child: PlayerScreen(),
          ),
          Center(
            child: Text('3'),
          ),
        ],
      ),
    );
  }
}
