import 'package:bitrix24/components/contact_card.dart';

import 'package:bitrix24/components/diamond_floating_button.dart';
import 'package:bitrix24/components/stage_buttons_menu.dart';
import 'package:bitrix24/models/bitrix24.dart';
import 'package:bitrix24/models/contact.dart';
import 'package:bitrix24/screens/contact_add_screen.dart';
import 'package:bitrix24/screens/contact_view_screen.dart';

import 'package:bitrix24/screens/home_screen.dart';
import 'package:flutter/material.dart';

class ContactListViewCrm extends StatefulWidget {
  const ContactListViewCrm({
    Key? key,
    required this.mainPagePaddingRight,
  }) : super(key: key);

  final double mainPagePaddingRight;

  @override
  _ContactListViewCrmState createState() => _ContactListViewCrmState();
}

class _ContactListViewCrmState extends State<ContactListViewCrm> {
  late ScrollController scrollController;
  late Future<ContactList> contactsListFuture;
  late Map<String, List> stageMenuButtons;

  late final Bitrix24 bitrix24;

  @override
  void initState() {
    super.initState();

    bitrix24 = Bitrix24(webhook: webhook);

    scrollController = ScrollController()..addListener(_scrollListener);

    contactsListFuture = bitrix24.crmContactList(start: 0);
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
          // Container(
          //   height: 100,
          //   child: Column(
          //     children: [
          //       Row(
          //         children: [],
          //       ),
          //     ],
          //   ),
          // ),
          // StageButtonsMenu(
          //   stageButtonsStatus: stageMenuButtons,
          //   function: (value) {
          //     setState(() {
          //       bool _b = stageMenuButtons[value]![0] ?? false;
          //       stageMenuButtons[value]![0] = !_b;
          //       contactsListFuture = bitrix24.crmContactList(
          //         start: 0,
          //       );

          //       scrollController.jumpTo(0.0);
          //     });
          //   },
          // ),
          Expanded(
            child: Stack(alignment: Alignment.bottomRight, children: [
              FutureBuilder<ContactList>(
                  future: contactsListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Contact> contactList = snapshot.data!.contacts;
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
                              itemCount: contactList.length,
                              itemBuilder: (_, index) {
                                if (index + 1 == contactList.length &&
                                    contactList.length !=
                                        snapshot.data!.getTotal) {
                                  return Center(
                                      heightFactor: 2,
                                      child: CircularProgressIndicator());
                                }
                                Map<String, String> dateTime = bitrix24
                                    .dateParser(contactList[index].dataCreate!);
                                return ContactCard(
                                  onTap: () {
                                    setState(() {
                                      print('view');
                                      this.contactsListFuture =
                                          bitrix24.crmContactList(
                                        start: 0,
                                      );
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ContactViewPage(
                                            contact: contactList[index],
                                            webhook: webhook,
                                            function: () {
                                              Future.delayed(
                                                  Duration(milliseconds: 1000),
                                                  () {
                                                setState(() {
                                                  print('update');
                                                  this.contactsListFuture =
                                                      bitrix24.crmContactList(
                                                    start: 0,
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
                                        'Вы действительно хотите удалить контакт?',
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
                                            deleteContact(
                                                contactList[index].id);
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
                                  ),
                                  title: contactList[index].name +
                                      " " +
                                      contactList[index].lastName,
                                  email: contactList[index].email,
                                  phone: contactList[index].phone,
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
              DiamandFloatingButton(
                onPressed: () {
                  // setState(() {
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactAddPage(
                          webhook: webhook,
                          function: () {
                            Future.delayed(Duration(milliseconds: 1000), () {
                              setState(() {
                                print('create');
                                this.contactsListFuture =
                                    bitrix24.crmContactList(
                                  start: 0,
                                );
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

  void deleteContact(String id) {
    bitrix24.crmContactDelete(id: id).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              value == 0 ? Colors.green.shade400 : Colors.red.shade400,
          content: Text(
            value == 0 ? 'Контакт удалена' : 'Не удалось удалить контакт',
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
        this.contactsListFuture = bitrix24.crmContactList(
          start: 0,
        );
      });
    });
  }

  bool _handlerScrollNotification(
      ScrollNotification notification, ContactList? contactList) {
    if (notification is ScrollEndNotification) {
      if (scrollController.position.extentAfter == 0) {
        _updateList(contactList: contactList);
      }
    }
    return false;
  }

  void _scrollListener() {}

  Future loadList() async {
    await Future.delayed(Duration(milliseconds: 400));
    setState(() {
      this.contactsListFuture = bitrix24.crmContactList(start: 0);
    });
  }

  void _updateList({ContactList? contactList}) {
    setState(() {
      if (contactList != null) {
        if (contactList.getNext == 0) {
          return;
        }
        contactsListFuture = bitrix24.crmContactList(
          start: contactList.getNext,
          contactList: contactList,
        );
      }
    });
  }
}
