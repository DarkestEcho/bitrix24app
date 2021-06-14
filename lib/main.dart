import 'package:flutter/material.dart';

void main() {
  runApp(Bitrix24App());
}

class Bitrix24App extends StatelessWidget {
  const Bitrix24App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color mainColor = Color(0xFFB1F2B36);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: mainColor,
          child: AppContainer(),
        ),
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

  final List<String> menuItems = [
    'Home',
    'Blogger',
    'Add New Post',
    'Settings'
  ];

  final List<String> menuIcons = [
    'icon_home',
    'icon_blogger',
    'icon_add',
    'icon_settings'
  ];

  bool bIsSidebarOpen = false;

  double xOffset = 60;
  double yOffset = 0;
  double pageScale = 1;

  int selectedMenuItem = 0;

  String pageTitle = 'Homepage';

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
        pageTitle = 'Homepage';
        break;
      case 1:
        pageTitle = 'Blogger';
        break;
      case 2:
        pageTitle = 'Add New Post';
        break;
      case 3:
        pageTitle = 'Settings';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
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
                            FocusScope.of(context)
                                .requestFocus(searchFocusNode);
                          },
                          child: Container(
                              padding: EdgeInsets.all(20),
                              child:
                                  Image.asset('assets/images/icon_search.png')),
                        ),
                        Container(
                          child: Expanded(
                            child: TextField(
                              focusNode: searchFocusNode,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(20),
                                hintText: 'Search here...',
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
                        child: MenuItem(
                          itemIcon: menuIcons[index],
                          itemText: menuItems[index],
                          selected: selectedMenuItem,
                          position: index,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: MenuItem(
                    itemIcon: 'icon_logout',
                    itemText: 'Logout',
                    selected: selectedMenuItem,
                    position: menuItems.length + 1,
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 200),
            transform: Matrix4.translationValues(xOffset, yOffset, 1.0)
              ..scale(pageScale),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(bIsSidebarOpen ? 20 : 0)),
            child: Column(
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
                          color: Colors.white,
                          padding: EdgeInsets.all(20),
                          child: Icon(Icons.menu),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          pageTitle,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  // const MenuItem({Key? key}) : super(key: key); // ?
  MenuItem(
      {required this.itemText,
      required this.itemIcon,
      required this.selected,
      required this.position});

  final String itemText;
  final String itemIcon;
  final int selected;
  final int position;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected == position ? Color(0xFFB151E26) : Color(0xFFB1F2B36),
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.all(20),
              child: Image.asset('assets/images/$itemIcon.png')),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              itemText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
