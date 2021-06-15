import 'package:flutter/material.dart';

class StageMenuButton extends StatelessWidget {
  final String stageName;
  final Color color;
  final Color textColor;
  const StageMenuButton(
      {Key? key,
      required this.stageName,
      required this.color,
      this.textColor = Colors.black87})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: 8,
      ),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          stageName,
          style: TextStyle(color: textColor),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          elevation: MaterialStateProperty.all(8),
        ),
      ),
    );
  }
}
