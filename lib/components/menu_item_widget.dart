import 'package:bitrix24/models/menu_item.dart';
import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final MenuItem menuItem;
  // const MenuItem({Key? key}) : super(key: key); // ?
  MenuItemWidget({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: menuItem.selected == menuItem.position
          ? Color(0xFFB151E26)
          : Color(0xFFB1F2B36),
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.all(20),
              child: Image.asset('assets/images/${menuItem.itemIcon}.png')),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              menuItem.itemText,
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
