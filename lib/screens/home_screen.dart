import 'package:bitrix24/components/contact_list_view_crm.dart';
import 'package:bitrix24/components/deal_list_view_crm.dart';
import 'package:bitrix24/components/lead_list_view_crm.dart';
import 'package:bitrix24/components/menu_item_widget.dart';
import 'package:bitrix24/models/menu_item.dart';
import 'package:bitrix24/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String webhook =
    'https://b24-dxpzij.bitrix24.ru/rest/1/o71asvzlz62e2uxi/';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
    required this.mainColor,
  }) : super(key: key);

  final Color mainColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: mainColor,
        child: AppContainer(),
      ),
    );
  }
}

class AppContainer extends StatefulWidget {
  const AppContainer({Key? key}) : super(key: key);

  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  final searchFocusNode = FocusNode();

  final List<String> menuItems = ['Лиды', 'Сделки', 'Контакты'];

  final List<String> menuIcons = [
    'icon_lead',
    'deals',
    'icon_contacts',
  ];

  bool bIsSidebarOpen = false;

  final double mainPagePaddingRight = 60;

  late double xOffset;
  double yOffset = 0;
  double pageScale = 1;

  int selectedMenuItem = 0;

  String pageTitle = 'Лиды';

  @override
  void initState() {
    super.initState();
    xOffset = mainPagePaddingRight;
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  void setSidebarState() {
    setState(() {
      if (bIsSidebarOpen) {
        xOffset = 265;
        yOffset = 70;
        pageScale = 0.8;
        return;
      }
      xOffset = 60;
      yOffset = 0;
      pageScale = 1;
    });
  }

  void setPageTitle() {
    switch (selectedMenuItem) {
      case 0:
        pageTitle = 'Лиды';
        break;
      case 1:
        pageTitle = 'Сделки';
        break;
      case 2:
        pageTitle = 'Контакты';
        break;
      case 3:
        pageTitle = 'Настройки';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          _getSideBar(context),
          _getMainPage(context),
        ],
      ),
    );
  }

  AnimatedContainer _getMainPage(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 200),
      transform: Matrix4.translationValues(xOffset, yOffset, 1.0)
        ..scale(pageScale),
      //width: double.infinity,
      //height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/wp_3_rocks.jpg')),
          color: Colors.white,
          borderRadius: BorderRadius.circular(bIsSidebarOpen ? 20 : 0)),
      child: Column(
        //direction: Axis.horizontal,
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            height: 60,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    bIsSidebarOpen = !bIsSidebarOpen;
                    setSidebarState();
                  },
                  child: Container(
                    // color: Colors.white,
                    padding: EdgeInsets.all(20),
                    child: Icon(Icons.menu),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, bottom: 15),
                  child: Text(
                    pageTitle,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _getListViewCrm(),
          )
        ],
      ),
    );
  }

  Widget _getListViewCrm() {
    if (pageTitle == menuItems[0]) {
      return LeadListViewCrm(mainPagePaddingRight: mainPagePaddingRight);
    }
    if (pageTitle == menuItems[1]) {
      return DealListViewCrm(mainPagePaddingRight: mainPagePaddingRight);
    }
    if (pageTitle == menuItems[2]) {
      return ContactListViewCrm(mainPagePaddingRight: mainPagePaddingRight);
    }
    return Container(
      margin: EdgeInsets.only(right: mainPagePaddingRight),
      child: Icon(Icons.error),
    );
  }

  Container _getSideBar(BuildContext context) {
    var searchController = TextEditingController();
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Container(
              color: Color(0xFFB1F2B36),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      bIsSidebarOpen = true;
                      setSidebarState();
                      FocusScope.of(context).requestFocus(searchFocusNode);
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Image.asset('assets/images/icon_search.png'),
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: TextField(
                        controller: searchController,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchScreen(
                                  searchValue: searchController.text,
                                  mainColor: Color(0xFFB1F2B36),
                                  pageTitle: menuItems[selectedMenuItem],
                                ),
                              ));
                        },
                        focusNode: searchFocusNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(20),
                          hintText: 'Найти ${_getMenuItemForSearch()}...',
                          hintStyle: TextStyle(
                            color: Color(0xFFB666666),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    bIsSidebarOpen = false;
                    selectedMenuItem = index;
                    setSidebarState();
                    setPageTitle();
                  },
                  child: MenuItemWidget(
                    menuItem: MenuItem(
                        itemIcon: menuIcons[index],
                        itemText: menuItems[index],
                        selected: selectedMenuItem,
                        position: index),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: GestureDetector(
              onTap: () => SystemChannels.platform
                  .invokeMethod<void>('SystemNavigator.pop', true),
              child: MenuItemWidget(
                menuItem: MenuItem(
                    itemIcon: 'icon_logout',
                    itemText: 'Выйти',
                    selected: selectedMenuItem,
                    position: menuItems.length + 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMenuItemForSearch() {
    switch (selectedMenuItem) {
      case 0:
        return 'Лид';
      case 1:
        return 'Сделку';
      case 2:
        return 'Контакт';
      default:
        return '';
    }
  }

  void findEntity(int type) {}
}
