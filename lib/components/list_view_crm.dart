import 'package:bitrix24/components/diamond_floating_button.dart';
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
  late Map<String, bool> stageMenuButtons;

  @override
  void initState() {
    super.initState();
    dealsListFuture = getDealsList(start: 0);
    scrollController = ScrollController()..addListener(_scrollListener);
    stageMenuButtons = {
      'Новая': true,
      'Подготовка документов': true,
      'Счет на предоплату': true,
      'В работе': true,
      'Финальный счет': true,
      'Сделка провалена': true,
      'Сделка успешна': true,
    };
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
            function: (value) {
              setState(() {
                bool _b = stageMenuButtons[value] ?? false;
                stageMenuButtons[value] = !_b;
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
                      return GestureDetector(
                        onVerticalDragDown: (_) =>
                            _updateList(dealsList: snapshot.data),
                        child: ListView.builder(
                          controller: scrollController,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: 8),
                          itemCount: dealsList.length,
                          itemBuilder: (_, index) => Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            margin: EdgeInsets.symmetric(
                                horizontal: 22, vertical: 5),
                            elevation: 5,
                            child: ListTile(
                                isThreeLine: true,
                                title: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  direction: Axis.vertical,
                                  children: [
                                    Text(
                                      '${dealsList[index].title} \n${dealsList.length}',
                                      textAlign: TextAlign.left,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      // color: Colors.blue,
                                      child: Text(
                                        '${snapshot.data!.deals[index].stageId}',
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                    '${snapshot.data!.deals[index].opportunity}\n${snapshot.data!.deals[index].dataCreate}')),
                          ),
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

  void _scrollListener() {
    // print(
    //     '${scrollController.position.extentAfter}  ${scrollController.position.maxScrollExtent}');
    // print(scrollController.position.extentAfter >=
    //     (scrollController.position.maxScrollExtent));
  }

  void _addListItems() {}

  void _updateList({DealsList? dealsList}) {
    if (scrollController.position.extentAfter >=
        (scrollController.position.maxScrollExtent)) {
      print('Update list');
      setState(() {
        dealsListFuture = getDealsList(start: 0);
      });
      return;
    }
    if (scrollController.position.extentAfter ==
        (scrollController.position.minScrollExtent)) {
      print('Update list');

      setState(() {
        // if (dealsList == null) {
        //   dealsListFuture = getDealsList(start: 0);
        //   return;
        // }
        if (dealsList != null) {
          if (dealsList.getNext == 0) {
            return;
          }
          dealsListFuture =
              getDealsList(start: dealsList.getNext, dealsList: dealsList);
        }
      });
    }
  }
}
