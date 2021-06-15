import 'package:bitrix24/components/stage_listmenu_button.dart';
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
  late Future<DealsList> dealsList;
  @override
  void initState() {
    super.initState();
    dealsList = getDealsList();
    scrollController = ScrollController()..addListener(_scrollListener);
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
          Container(
            height: 40,
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
          ),
          Expanded(
            child: Container(
              child: FutureBuilder<DealsList>(
                  future: dealsList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GestureDetector(
                        onTapUp: (context) => print(context.localPosition),
                        onVerticalDragDown: (context) => _updateList(),
                        child: ListView.builder(
                          controller: scrollController,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: 8),
                          itemCount: snapshot.data!.deals.length,
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
                                      '${snapshot.data!.deals[index].title} \n${snapshot.data!.deals.length}',
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
            ),
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

  void _updateList() {
    if (scrollController.position.extentAfter >=
        (scrollController.position.maxScrollExtent)) {
      print('Update list');
      setState(() {
        dealsList = getDealsList();
      });
    }
  }
}
