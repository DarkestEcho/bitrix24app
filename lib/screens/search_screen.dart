import 'package:bitrix24/components/contact_list_view_crm.dart';
import 'package:bitrix24/components/deal_list_view_crm.dart';
import 'package:bitrix24/components/lead_list_view_crm.dart';

import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen(
      {Key? key,
      required this.pageTitle,
      required this.mainColor,
      required this.searchValue})
      : super(key: key);

  final Color mainColor;
  final String pageTitle;
  final String searchValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(pageTitle),
      ),
      body: Container(
        color: mainColor,
        child: AppContainer(
          pageTitle: pageTitle,
          searchValue: searchValue,
        ),
      ),
    );
  }
}

class AppContainer extends StatefulWidget {
  const AppContainer(
      {Key? key, required this.pageTitle, required this.searchValue})
      : super(key: key);

  final String pageTitle;
  final String searchValue;

  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  final double mainPagePaddingRight = 0;

  final List<String> menuItems = ['Лиды', 'Сделки', 'Контакты'];

  late double xOffset;
  double yOffset = 0;
  double pageScale = 1;

  int selectedMenuItem = 0;

  @override
  void initState() {
    super.initState();
    xOffset = mainPagePaddingRight;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          _getMainPage(context),
        ],
      ),
    );
  }

  AnimatedContainer _getMainPage(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),

      //width: double.infinity,
      //height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/wp_3_rocks.jpg')),
          color: Colors.white,
          borderRadius: BorderRadius.circular(0)),
      child: Column(
        //direction: Axis.horizontal,
        children: [
          Container(
            height: 20,
          ),
          Expanded(
            child: Container(
              child: _getListViewCrm(),
              margin: EdgeInsets.symmetric(horizontal: 20),
            ),
          )
        ],
      ),
    );
  }

  Widget _getListViewCrm() {
    if (widget.pageTitle == menuItems[0]) {
      return LeadListViewCrm(
        mainPagePaddingRight: mainPagePaddingRight,
      );
    }
    if (widget.pageTitle == menuItems[1]) {
      return DealListViewCrm(
        mainPagePaddingRight: mainPagePaddingRight,
        isSearch: true,
        searchValue: widget.searchValue,
      );
    }
    if (widget.pageTitle == menuItems[2]) {
      return ContactListViewCrm(mainPagePaddingRight: mainPagePaddingRight);
    }
    return Container(
      margin: EdgeInsets.only(right: mainPagePaddingRight),
      child: Icon(Icons.error),
    );
  }
}
