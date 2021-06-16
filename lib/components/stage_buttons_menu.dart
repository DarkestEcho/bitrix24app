import 'package:bitrix24/components/stage_listmenu_button.dart';
import 'package:flutter/material.dart';

class StageButtonsMenu extends StatelessWidget {
  const StageButtonsMenu(
      {Key? key, required this.function, required this.stageButtonsStatus})
      : super(key: key);

  final Function(String text) function;

  final Map<String, List> stageButtonsStatus;
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
            stageName: 'Новая',
            color: (stageButtonsStatus['Новая']![0] ?? true)
                ? Colors.blue
                : Colors.white38,
            function: function,
          ),
          StageMenuButton(
            stageName: 'Подготовка документов',
            color: (stageButtonsStatus['Подготовка документов']![0] ?? true)
                ? Colors.lightBlue
                : Colors.white38,
            function: function,
          ),
          StageMenuButton(
            stageName: 'Счет на предоплату',
            color: (stageButtonsStatus['Счет на предоплату']![0] ?? true)
                ? Colors.cyan
                : Colors.white38,
            function: function,
          ),
          StageMenuButton(
            stageName: 'В работе',
            color: (stageButtonsStatus['В работе']![0] ?? true)
                ? Colors.teal.shade400
                : Colors.white38,
            function: function,
          ),
          StageMenuButton(
            stageName: 'Финальный счет',
            color: (stageButtonsStatus['Финальный счет']![0] ?? true)
                ? Colors.orange
                : Colors.white38,
            function: function,
          ),
          StageMenuButton(
            stageName: 'Сделка провалена',
            color: (stageButtonsStatus['Сделка провалена']![0] ?? true)
                ? Colors.red
                : Colors.white38,
            textColor: (stageButtonsStatus['Сделка провалена']![0] ?? true)
                ? Colors.white
                : Colors.black87,
            function: function,
          ),
          StageMenuButton(
            stageName: 'Сделка успешна',
            color: (stageButtonsStatus['Сделка успешна']![0] ?? true)
                ? Colors.green
                : Colors.white38,
            function: function,
          ),
        ],
      ),
    );
  }
}
