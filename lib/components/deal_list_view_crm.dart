import 'package:bitrix24/components/deal_card.dart';
import 'package:bitrix24/components/diamond_floating_button.dart';
import 'package:bitrix24/components/stage_buttons_menu.dart';
import 'package:bitrix24/models/bitrix24.dart';
import 'package:bitrix24/models/deal.dart';
import 'package:bitrix24/screens/deal_add_screen.dart';
import 'package:bitrix24/screens/deal_view_screen.dart';
import 'package:bitrix24/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DealListViewCrm extends StatefulWidget {
  const DealListViewCrm(
      {Key? key,
      required this.mainPagePaddingRight,
      this.isSearch = false,
      this.searchValue})
      : super(key: key);

  final double mainPagePaddingRight;
  final bool isSearch;
  final String? searchValue;

  @override
  _DealListViewCrmState createState() => _DealListViewCrmState();
}

class _DealListViewCrmState extends State<DealListViewCrm> {
  late ScrollController scrollController;
  late Future<DealsList> dealsListFuture;
  late Map<String, List> stageMenuButtons;

  var formatter = NumberFormat('###,###,###');

  late final Bitrix24 bitrix24;

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
    bitrix24 = Bitrix24(webhook: webhook);

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
    dealsListFuture = widget.isSearch
        ? bitrix24.crmDealList(
            start: 0,
            stageIdList: stageMenuButtons.values,
            searchValue: widget.searchValue)
        : bitrix24.crmDealList(start: 0, stageIdList: stageMenuButtons.values);
    // getDealsList(start: 0, stageIdList: stageMenuButtons.values);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
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
                dealsListFuture = widget.isSearch
                    ? bitrix24.crmDealList(
                        start: 0,
                        stageIdList: stageMenuButtons.values,
                        searchValue: widget.searchValue)
                    : bitrix24.crmDealList(
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
                      return NotificationListener(
                        onNotification: (ScrollNotification notification) {
                          return _handlerScrollNotification(
                              notification, snapshot.data);
                        },
                        child: RefreshIndicator(
                          onRefresh: loadList,
                          child: ListView.builder(
                              // itemExtent: 150,
                              controller: scrollController,
                              physics: AlwaysScrollableScrollPhysics(),
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
                                Map<String, String> dateTime = bitrix24
                                    .dateParser(dealsList[index].dataCreate!);
                                return DealCard(
                                  onTap: () {
                                    setState(() {
                                      print('view');
                                      this.dealsListFuture = dealsListFuture =
                                          widget.isSearch
                                              ? bitrix24.crmDealList(
                                                  start: 0,
                                                  stageIdList:
                                                      stageMenuButtons.values,
                                                  searchValue:
                                                      widget.searchValue)
                                              : bitrix24.crmDealList(
                                                  start: 0,
                                                  stageIdList:
                                                      stageMenuButtons.values);
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DealViewPage(
                                            deal: dealsList[index],
                                            webhook: webhook,
                                            function: () {
                                              Future.delayed(
                                                  Duration(milliseconds: 1000),
                                                  () {
                                                setState(() {
                                                  print('update');
                                                  this.dealsListFuture =
                                                      dealsListFuture = widget
                                                              .isSearch
                                                          ? bitrix24.crmDealList(
                                                              start: 0,
                                                              stageIdList:
                                                                  stageMenuButtons
                                                                      .values,
                                                              searchValue: widget
                                                                  .searchValue)
                                                          : bitrix24.crmDealList(
                                                              start: 0,
                                                              stageIdList:
                                                                  stageMenuButtons
                                                                      .values);
                                                });
                                              });
                                            }),
                                      ),
                                    );
                                  },
                                  function: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text(
                                        'Вы действительно хотите удалить сделку?',
                                        // textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text(
                                            'Отмена',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteDeal(dealsList[index].id);
                                            Navigator.pop(context, 'OK');
                                          },
                                          child: const Text(
                                            'Удалить',
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  // _showDeleteDealDialog(dealsList[index].id);
                                  // deleteDeal(dealsList[index].id);
                                  ,
                                  title: dealsList[index].title,
                                  textColor: dealsList[index].stageId ==
                                          'Сделка провалена'
                                      ? Colors.white
                                      : Colors.black87,
                                  stageColor:
                                      stageColor[dealsList[index].stageId] ??
                                          Colors.white,
                                  stageName: dealsList[index].stageId,
                                  opportunity: formatter.format(
                                          dealsList[index].opportunity) +
                                      ' ${bitrix24.getCurrencyName(dealsList[index].currencyId)}',
                                  date: dateTime['date']!,
                                  time: dateTime['time']!,
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
              widget.isSearch
                  ? SizedBox()
                  : DiamandFloatingButton(
                      onPressed: () {
                        // setState(() {
                        // Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DealAddPage(
                                webhook: webhook,
                                function: () {
                                  Future.delayed(Duration(milliseconds: 1000),
                                      () {
                                    setState(() {
                                      print('create');
                                      this.dealsListFuture =
                                          bitrix24.crmDealList(
                                              start: 0,
                                              stageIdList:
                                                  stageMenuButtons.values);
                                    });
                                  });
                                }),
                          ),
                        );
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

  void deleteDeal(String id) {
    bitrix24.crmDealDelete(id: id).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              value == 0 ? Colors.green.shade400 : Colors.red.shade400,
          content: Text(
            value == 0 ? 'Сделка удалена' : 'Не удалось удалить сделку',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: value == 0 ? Colors.black87 : Colors.white,
                fontSize: 18),
          ),
          duration: const Duration(milliseconds: 3000),
          margin: EdgeInsets.only(bottom: 25, left: 65, right: 5),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        this.dealsListFuture = widget.isSearch
            ? bitrix24.crmDealList(
                start: 0,
                stageIdList: stageMenuButtons.values,
                searchValue: widget.searchValue)
            : bitrix24.crmDealList(
                start: 0, stageIdList: stageMenuButtons.values);
      });
    });
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

  void _scrollListener() {}

  Future loadList() async {
    await Future.delayed(Duration(milliseconds: 400));
    setState(() {
      this.dealsListFuture = widget.isSearch
          ? bitrix24.crmDealList(
              start: 0,
              stageIdList: stageMenuButtons.values,
              searchValue: widget.searchValue)
          : bitrix24.crmDealList(
              start: 0, stageIdList: stageMenuButtons.values);
    });
  }

  void _updateList({DealsList? dealsList}) {
    setState(() {
      if (dealsList != null) {
        if (dealsList.getNext == 0) {
          return;
        }
        dealsListFuture = widget.isSearch
            ? bitrix24.crmDealList(
                start: 0,
                stageIdList: stageMenuButtons.values,
                searchValue: widget.searchValue,
                dealsList: dealsList)
            : bitrix24.crmDealList(
                start: 0,
                stageIdList: stageMenuButtons.values,
                dealsList: dealsList);
      }
    });
  }
}
