import 'package:flutter/material.dart';

class DiamandFloatingButton extends StatelessWidget {
  const DiamandFloatingButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(30),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            shape: BeveledRectangleBorder(
                side: BorderSide(width: 3, color: Color(0xFFB151E26)),
                borderRadius: BorderRadius.circular(33)),
            backgroundColor: Colors.black54, //Color(0xFFB1F2B36),
            child: Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 35,
            ),
            onPressed: onPressed,
          ),
        ));
  }
}
