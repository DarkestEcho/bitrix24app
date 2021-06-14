import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  // const MenuItem({Key? key}) : super(key: key); // ?
  MenuItem(
      {required this.itemText,
      required this.itemIcon,
      required this.selected,
      required this.position});

  final String itemText;
  final String itemIcon;
  final int selected;
  final int position;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected == position ? Color(0xFFB151E26) : Color(0xFFB1F2B36),
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.all(20),
              child: Image.asset('assets/images/$itemIcon.png')),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              itemText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
