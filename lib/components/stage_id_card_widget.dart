import 'package:flutter/material.dart';

class StageIdCardWidget extends StatelessWidget {
  const StageIdCardWidget({
    Key? key,
    required this.stageColor,
    required this.stageName,
    required this.textColor,
  }) : super(key: key);

  final Color stageColor;
  final String stageName;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: stageColor, borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      // color: Colors.blue,
      child: Text(
        stageName,
        style: TextStyle(color: textColor, fontSize: 15),
      ),
    );
  }
}
