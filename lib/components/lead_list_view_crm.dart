import 'package:bitrix24/components/deal_card.dart';
import 'package:bitrix24/components/diamond_floating_button.dart';
import 'package:bitrix24/components/status_buttons_menu.dart';

import 'package:bitrix24/models/bitrix24.dart';
import 'package:bitrix24/models/lead.dart';

import 'package:bitrix24/screens/home_screen.dart';
import 'package:bitrix24/screens/lead_add_screen.dart';
import 'package:bitrix24/screens/lead_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeadListViewCrm extends StatefulWidget {
  const LeadListViewCrm(
      {Key? key,
      required this.mainPagePaddingRight,
      this.isSearch = false,
      this.searchValue})
      : super(key: key);

  final double mainPagePaddingRight;
  final bool isSearch;
  final String? searchValue;

  @override
  _LeadListViewCrmState createState() => _LeadListViewCrmState();
}

class _LeadListViewCrmState extends State<LeadListViewCrm> {
  late ScrollController scrollController;
  late Future<LeadsList> leadsListFuture;
  late Map<String, List> statusMenuButtons;

  var formatter = NumberFormat('###,###,###');

  late final Bitrix24 bitrix24;

  Map<String, Color> stageColor = {
    'Не обработан': Colors.blue,
    'В работе': Colors.teal.shade400,
    'Обработан': Colors.orange,
    'Некачественный лид': Colors.red,
    'Качественный лид': Colors.green,
  };

  @override
  void initState() {
    super.initState();

    bitrix24 = Bitrix24(webhook: webhook);

    scrollController = ScrollController()..addListener(_scrollListener);
    statusMenuButtons = {
      'Не обработан': [true, 'NEW'],
      'В работе': [true, 'IN_PROCESS'],
      'Обработан': [true, 'PROCESSED'],
      'Некачественный лид': [true, 'JUNK'],
      'Качественный лид': [true, 'CONVERTED'],
    };

    leadsListFuture = widget.isSearch
        ? bitrix24.crmLeadList(
            start: 0,
            statusIdList: statusMenuButtons.values,
            searchValue: widget.searchValue)
        : bitrix24.crmLeadList(
            start: 0,
            statusIdList: statusMenuButtons.values,
          );
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
          StatusButtonsMenu(
            statusButtonsStatus: statusMenuButtons,
            function: (value) {
              setState(() {
                bool _b = statusMenuButtons[value]![0] ?? false;
                statusMenuButtons[value]![0] = !_b;
                leadsListFuture = widget.isSearch
                    ? bitrix24.crmLeadList(
                        start: 0,
                        statusIdList: statusMenuButtons.values,
                        searchValue: widget.searchValue)
                    : bitrix24.crmLeadList(
                        start: 0,
                        statusIdList: statusMenuButtons.values,
                      );

                scrollController.jumpTo(0.0);
              });
            },
          ),
          Expanded(
            child: Stack(alignment: Alignment.bottomRight, children: [
              FutureBuilder<LeadsList>(
                  future: leadsListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Lead> leadsList = snapshot.data!.deals;
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
                              itemCount: leadsList.length,
                              itemBuilder: (_, index) {
                                if (index + 1 == leadsList.length &&
                                    leadsList.length !=
                                        snapshot.data!.getTotal) {
                                  return Center(
                                      heightFactor: 2,
                                      child: CircularProgressIndicator());
                                }
                                Map<String, String> dateTime = bitrix24
                                    .dateParser(leadsList[index].dataCreate!);
                                return DealCard(
                                  onTap: () {
                                    setState(() {
                                      print('view');
                                      this.leadsListFuture = widget.isSearch
                                          ? bitrix24.crmLeadList(
                                              start: 0,
                                              statusIdList:
                                                  statusMenuButtons.values,
                                              searchValue: widget.searchValue)
                                          : bitrix24.crmLeadList(
                                              start: 0,
                                              statusIdList:
                                                  statusMenuButtons.values,
                                            );
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LeadViewPage(
                                            lead: leadsList[index],
                                            webhook: webhook,
                                            function: () {
                                              Future.delayed(
                                                  Duration(milliseconds: 1000),
                                                  () {
                                                setState(() {
                                                  print('update');
                                                  this.leadsListFuture = widget
                                                          .isSearch
                                                      ? bitrix24.crmLeadList(
                                                          start: 0,
                                                          statusIdList:
                                                              statusMenuButtons
                                                                  .values,
                                                          searchValue: widget
                                                              .searchValue)
                                                      : bitrix24.crmLeadList(
                                                          start: 0,
                                                          statusIdList:
                                                              statusMenuButtons
                                                                  .values,
                                                        );
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
                                        'Вы действительно хотите удалить лид?',
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
                                            deleteLead(leadsList[index].id);
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
                                  title: leadsList[index].title,
                                  textColor: leadsList[index].statusId ==
                                          'Некачественный лид'
                                      ? Colors.white
                                      : Colors.black87,
                                  stageColor:
                                      stageColor[leadsList[index].statusId] ??
                                          Colors.white,
                                  stageName: leadsList[index].statusId,
                                  opportunity: formatter.format(
                                          leadsList[index].opportunity) +
                                      ' ${bitrix24.getCurrencyName(leadsList[index].currencyId)}',
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
                            builder: (context) => LeadAddPage(
                                webhook: webhook,
                                function: () {
                                  Future.delayed(Duration(milliseconds: 1000),
                                      () {
                                    setState(() {
                                      print('create');
                                      this.leadsListFuture =
                                          bitrix24.crmLeadList(
                                              start: 0,
                                              statusIdList:
                                                  statusMenuButtons.values);
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

  void deleteLead(String id) {
    bitrix24.crmLeadDelete(id: id).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              value == 0 ? Colors.green.shade400 : Colors.red.shade400,
          content: Text(
            value == 0 ? 'Лид удален' : 'Не удалось удалить лид',
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
        this.leadsListFuture = widget.isSearch
            ? bitrix24.crmLeadList(
                start: 0,
                statusIdList: statusMenuButtons.values,
                searchValue: widget.searchValue)
            : bitrix24.crmLeadList(
                start: 0,
                statusIdList: statusMenuButtons.values,
              );
      });
    });
  }

  bool _handlerScrollNotification(
      ScrollNotification notification, LeadsList? dealsList) {
    if (notification is ScrollEndNotification) {
      if (scrollController.position.extentAfter == 0) {
        _updateList(leadsList: dealsList);
      }
    }
    return false;
  }

  void _scrollListener() {}

  Future loadList() async {
    await Future.delayed(Duration(milliseconds: 400));
    setState(() {
      this.leadsListFuture = widget.isSearch
          ? bitrix24.crmLeadList(
              start: 0,
              statusIdList: statusMenuButtons.values,
              searchValue: widget.searchValue)
          : bitrix24.crmLeadList(
              start: 0,
              statusIdList: statusMenuButtons.values,
            );
    });
  }

  void _updateList({LeadsList? leadsList}) {
    setState(() {
      if (leadsList != null) {
        if (leadsList.getNext == 0) {
          return;
        }
        leadsListFuture = widget.isSearch
            ? bitrix24.crmLeadList(
                start: 0,
                statusIdList: statusMenuButtons.values,
                searchValue: widget.searchValue,
                leadsList: leadsList,
              )
            : bitrix24.crmLeadList(
                start: leadsList.getNext,
                leadsList: leadsList,
                statusIdList: statusMenuButtons.values);
      }
    });
  }
}
