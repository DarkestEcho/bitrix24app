import 'package:bitrix24/components/stage_id_card_widget.dart';
import 'package:flutter/material.dart';

class DealCard extends StatelessWidget {
  const DealCard(
      {Key? key,
      required this.stageColor,
      required this.title,
      required this.stageName,
      this.textColor = Colors.black87,
      required this.opportunity,
      required this.date,
      required this.time,
      required this.function,
      required this.onTap})
      : super(key: key);

  final Color stageColor;
  final Color textColor;
  final String title;
  final String stageName;
  final String opportunity;
  final String date;
  final String time;
  final Function() function;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(horizontal: 22, vertical: 5),
        elevation: 8,
        child: ListTile(
          onTap: onTap,
          // contentPadding: EdgeInsets.all(15),
          trailing: IconButton(
            visualDensity: VisualDensity.comfortable,
            // padding: EdgeInsets.all(1),
            splashRadius: 30,
            alignment: Alignment.centerRight,
            icon: Icon(
              Icons.delete_forever_outlined,
              size: 30,
            ),
            onPressed: function,
          ),
          // isThreeLine: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                title.length > 18 ? title.substring(0, 16) + "..." : title,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19),
              ),
              Divider(
                height: 20,
                thickness: 1,
                color: Colors.black54,
              ),
            ],
          ),

          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                opportunity,
                style: TextStyle(color: Colors.black87, fontSize: 20),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                '$date $time',
                style: TextStyle(color: Colors.black87, fontSize: 15),
              ),
              StageIdCardWidget(
                  stageColor: stageColor,
                  stageName: stageName,
                  textColor: textColor),
            ],
          ),
        ));
  }
}
