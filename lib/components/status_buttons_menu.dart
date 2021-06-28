import 'package:bitrix24/components/stage_listmenu_button.dart';
import 'package:flutter/material.dart';

class StatusButtonsMenu extends StatelessWidget {
  const StatusButtonsMenu(
      {Key? key, required this.function, required this.statusButtonsStatus})
      : super(key: key);

  final Function(String text) function;

  final Map<String, List> statusButtonsStatus;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5, top: 5),
      height: 50,
      child: ListView(
        padding: EdgeInsets.only(left: 20, right: 12),
        scrollDirection: Axis.horizontal,
        children: [
          StageMenuButton(
            stageName: 'Не обработан',
            color: (statusButtonsStatus['Не обработан']![0] ?? true)
                ? Colors.blue
                : Colors.white38,
            function: function,
          ),
          StageMenuButton(
            stageName: 'В работе',
            color: (statusButtonsStatus['В работе']![0] ?? true)
                ? Colors.teal.shade400
                : Colors.white38,
            function: function,
          ),
          StageMenuButton(
            stageName: 'Обработан',
            color: (statusButtonsStatus['Обработан']![0] ?? true)
                ? Colors.orange
                : Colors.white38,
            function: function,
          ),
          StageMenuButton(
            stageName: 'Некачественный лид',
            color: (statusButtonsStatus['Некачественный лид']![0] ?? true)
                ? Colors.red
                : Colors.white38,
            function: function,
          ),
          StageMenuButton(
            stageName: 'Качественный лид',
            color: (statusButtonsStatus['Качественный лид']![0] ?? true)
                ? Colors.green
                : Colors.white38,
            function: function,
          ),
        ],
      ),
    );
  }
}
