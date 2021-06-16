import 'package:bitrix24/components/stage_listmenu_button.dart';
import 'package:flutter/material.dart';

class StageButtonsMenu extends StatelessWidget {
  const StageButtonsMenu({Key? key, required this.function}) : super(key: key);

  final Function(String text) function;
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
            color: Colors.blue,
            function: function,
          ),
          StageMenuButton(
            stageName: 'Подготовка документов',
            color: Colors.lightBlue,
            function: function,
          ),
          StageMenuButton(
            stageName: 'Счет на предоплату',
            color: Colors.cyan,
            function: function,
          ),
          StageMenuButton(
            stageName: 'В работе',
            color: Colors.teal.shade400,
            function: function,
          ),
          StageMenuButton(
            stageName: 'Финальный счет',
            color: Colors.orange,
            function: function,
          ),
          StageMenuButton(
            stageName: 'Сделка провалена',
            color: Colors.red,
            textColor: Colors.white,
            function: function,
          ),
          StageMenuButton(
            stageName: 'Сделка успешна',
            color: Colors.green,
            function: function,
          ),
        ],
      ),
    );
  }
}
