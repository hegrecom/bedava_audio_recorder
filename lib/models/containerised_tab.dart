import 'package:flutter/material.dart';

class ContainerisedTab extends StatelessWidget {
  final double height;
  final IconData iconData;

  ContainerisedTab({this.height, this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Tab(
        icon: Icon(
          iconData,
        ),
      ),
    );
  }
}
