import 'package:flutter/material.dart';

import '../../helper/theme/fonts_helper.dart';
import '../../helper/theme/text_style_helper.dart';

class TopBar extends StatelessWidget {
  String _barTitle;
  Widget? primaryAction;
  Widget? secondaryAction;
  double fontSize;
  late double _deviceHeight;
  late double _deviceWidth;

  TopBar(
    this._barTitle, {
    this.fontSize = 30,
    this.primaryAction,
    this.secondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: _deviceHeight * 0.10,
      width: _deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (secondaryAction != null) secondaryAction!,
          _titleBar(),
          if (primaryAction != null) primaryAction!,
        ],
      ),
    );
  }

  Widget _titleBar() {
    return Text(_barTitle,
        overflow: TextOverflow.ellipsis, style:  TextStyle(
      fontWeight: FontWeights.medium,
      fontSize:fontSize,
      color: Colors.white));
  }
}
