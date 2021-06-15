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
            height: 50,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Новая'),
                  style: ButtonStyle(elevation: MaterialStateProperty.all(8)),
                ),
                TextButton(onPressed: () {}, child: Text('Новая')),
                TextButton(
                    onPressed: () {}, child: Text('Подготовка документов')),
                TextButton(onPressed: () {}, child: Text('Счет на предоплату')),
                TextButton(onPressed: () {}, child: Text('В работе')),
                TextButton(onPressed: () {}, child: Text('Финальный счет')),
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
                            margin: EdgeInsets.symmetric(
                                horizontal: 22, vertical: 5),
                            elevation: 5,
                            child: ListTile(
                                isThreeLine: true,
                                title: Text(
                                  '${snapshot.data!.deals[index].title} \n${snapshot.data!.deals.length}\n ${snapshot.data!.deals[index].stageId}',
                                  textAlign: TextAlign.left,
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
