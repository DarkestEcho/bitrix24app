import 'package:bitrix24/components/diamond_floating_button.dart';
import 'package:bitrix24/components/refresh_widget.dart';
import 'package:bitrix24/components/stage_buttons_menu.dart';
import 'package:bitrix24/models/deal.dart';
import 'package:flutter/material.dart';

class ListViewCrm extends StatefulWidget {
  const ListViewCrm({
    Key? key,
    required this.mainPagePaddingRight,
  }) : super(key: key);

  final double mainPagePaddingRight;

  @override
  _ListViewCrmState createState() => _ListViewCrmState();
}

class _ListViewCrmState extends State<ListViewCrm> {
  late ScrollController scrollController;
  late Future<DealsList> dealsListFuture;
  late Map<String, List> stageMenuButtons;
  Map<String, Color> stageColor = {
    'Новая': Colors.blue,
    'Подготовка документов': Colors.lightBlue,
    'Счет на предоплату': Colors.cyan,
    'В работе': Colors.teal.shade400,
    'Финальный счет': Colors.orange,
    'Сделка провалена': Colors.red,
    'Сделка успешна': Colors.green,
  };

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController()..addListener(_scrollListener);
    stageMenuButtons = {
      'Новая': [true, 'NEW'],
      'Подготовка документов': [true, 'PREPARATION'],
      'Счет на предоплату': [true, 'PREPAYMENT_INVOICE'],
      'В работе': [true, 'EXECUTING'],
      'Финальный счет': [true, 'FINAL_INVOICE'],
      'Сделка провалена': [true, 'LOSE'],
      'Сделка успешна': [true, 'WON'],
    };

    dealsListFuture =
        getDealsList(start: 0, stageIdList: stageMenuButtons.values);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(right: widget.mainPagePaddingRight),
      decoration: BoxDecoration(
          // color: Colors.white10, //Color(0xffeeeeee),
          // shape: BoxShape.rectangle,
          // borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          ),
      // padding: EdgeInsets.only(right: mainPagePaddingRight),
      child: Column(
        children: [
          StageButtonsMenu(
            stageButtonsStatus: stageMenuButtons,
            function: (value) {
              setState(() {
                bool _b = stageMenuButtons[value]![0] ?? false;
                stageMenuButtons[value]![0] = !_b;
                dealsListFuture = getDealsList(
                    start: 0, stageIdList: stageMenuButtons.values);
                scrollController.jumpTo(0.0);
              });
            },
          ),
          Expanded(
            child: Stack(alignment: Alignment.bottomRight, children: [
              FutureBuilder<DealsList>(
                  future: dealsListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Deal> dealsList = snapshot.data!.deals;
                      // print(dealsList);
                      return RefreshWidget(
                        onRefresh: loadList,
                        child: NotificationListener(
                          onNotification: (ScrollNotification notification) {
                            return _handlerScrollNotification(
                                notification, snapshot.data);
                          },
                          child: ListView.builder(
                              controller: scrollController,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: 8),
                              itemCount: dealsList.length,
                              itemBuilder: (_, index) {
                                if (index + 1 == dealsList.length &&
                                    dealsList.length !=
                                        snapshot.data!.getTotal) {
                                  return Center(
                                      heightFactor: 2,
                                      child: CircularProgressIndicator());
                                }
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 5),
                                  elevation: 5,
                                  child: ListTile(
                                      isThreeLine: true,
                                      title: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        direction: Axis.vertical,
                                        children: [
                                          Text(
                                            '${dealsList[index].title} \n${dealsList.length}',
                                            textAlign: TextAlign.left,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: stageColor[
                                                    dealsList[index].stageId],
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            // color: Colors.blue,
                                            child: Text(
                                              '${dealsList[index].stageId}',
                                              style: TextStyle(
                                                  color: dealsList[index]
                                                              .stageId ==
                                                          'Сделка провалена'
                                                      ? Colors.white
                                                      : Colors.black87),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                          '${dealsList[index].opportunity}\n${dealsList[index].dataCreate}')),
                                );
                              }),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error ${snapshot.error.toString()}');
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
              DiamandFloatingButton(
                onPressed: () {
                  // setState(() {
                  print(stageMenuButtons);
                  //dealsListFuture = getDealsList(start: 0);
                  // });
                },
              ),
            ]),
          ),
        ],
      ),
      // color: Colors.deepOrange.shade300,
    );
  }

  bool _handlerScrollNotification(
      ScrollNotification notification, DealsList? dealsList) {
    if (notification is ScrollEndNotification) {
      if (scrollController.position.extentAfter == 0) {
        _updateList(dealsList: dealsList);
      }
    }
    return false;
  }

  void _scrollListener() {
    print(
        '${scrollController.position.extentAfter}  ${scrollController.position.maxScrollExtent}');
    print(scrollController.position.extentAfter >=
        (scrollController.position.maxScrollExtent));
  }

  void _addListItems() {}

  Future loadList() async {
    await Future.delayed(Duration(milliseconds: 400));
    print('Refresh!');
    setState(() {
      this.dealsListFuture =
          getDealsList(start: 0, stageIdList: stageMenuButtons.values);
    });
  }

  void _updateList({DealsList? dealsList}) {
    print('Update list');
    setState(() {
      if (dealsList != null) {
        if (dealsList.getNext == 0) {
          return;
        }
        dealsListFuture = getDealsList(
            start: dealsList.getNext,
            dealsList: dealsList,
            stageIdList: stageMenuButtons.values);
      }
    });
  }
}
