import 'package:bitrix24/components/stage_listmenu_button.dart';
import 'package:flutter/material.dart';

class StageButtonsMenu extends StatelessWidget {
  const StageButtonsMenu({
    Key? key,
  }) : super(key: key);

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
          ),
          StageMenuButton(
            stageName: 'Подготовка документов',
            color: Colors.lightBlue,
          ),
          StageMenuButton(
            stageName: 'Счет на предоплату',
            color: Colors.cyan,
          ),
          StageMenuButton(
            stageName: 'В работе',
            color: Colors.teal.shade400,
          ),
          StageMenuButton(
            stageName: 'Финальный счет',
            color: Colors.orange,
          ),
          StageMenuButton(
            stageName: 'Сделка провалена',
            color: Colors.red,
            textColor: Colors.white,
          ),
          StageMenuButton(
            stageName: 'Сделка успешна',
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
