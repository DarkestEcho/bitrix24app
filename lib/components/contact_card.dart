import 'package:bitrix24/components/stage_id_card_widget.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard(
      {Key? key,
      required this.title,
      this.textColor = Colors.black87,
      this.email,
      this.phone,
      required this.date,
      required this.time,
      required this.function,
      required this.onTap})
      : super(key: key);

  final Color textColor;
  final String title;

  final String? phone;
  final String? email;
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
                title,
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
              email == null
                  ? SizedBox()
                  : Text(
                      email as String,
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                    ),
              SizedBox(
                height: email == null ? 0 : 12,
              ),
              phone == null
                  ? SizedBox()
                  : Text(
                      phone as String,
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                    ),
              SizedBox(
                height: 12,
              ),
              Text(
                '$date $time',
                style: TextStyle(color: Colors.black87, fontSize: 15),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ));
  }
}
