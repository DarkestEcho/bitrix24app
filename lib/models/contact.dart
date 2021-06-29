class Contact {
  final String id;

  String name;
  String secondName;
  String lastName;

  String? comments;
  String? address;
  String? phone;
  String? post;
  String? honorific;
  String? email;
  String? dataCreate;
  String? dateModify;

  Contact(
      {required this.id,
      required this.name,
      required this.secondName,
      required this.lastName,
      this.address,
      this.email,
      this.honorific,
      this.phone,
      this.post,
      this.comments,
      this.dataCreate,
      this.dateModify});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
        id: json['ID'],
        name: json['NAME'] ?? '',
        secondName: json['SECOND_NAME'] ?? '',
        lastName: json['LAST_NAME'] ?? '',
        address: json['ADDRESS'],
        post: json['POST'],
        email: json['UF_CRM_1624968168488'],
        phone: json['UF_CRM_1624968219167'],
        honorific: json['HONORIFIC'],
        comments: json['COMMENTS'] == null
            ? null
            : removeAllHtmlTags(json['COMMENTS']),
        dataCreate: json['DATE_CREATE'],
        dateModify: json['DATE_MODIFY']);
  }
}

class ContactList {
  List<Contact> deals;
  int _total;
  int? _next;

  int get getTotal => _total;
  int get getNext => _next ?? 0;

  set setNext(int val) => this._next = val;

  void updateTotal() {
    _total += 50;
  }

  ContactList({required this.deals, required int total, int? next})
      : this._total = total,
        this._next = next;

  factory ContactList.fromJson(Map<String, dynamic> json) {
    var dealsJson = json['result'] as List;

    List<Contact> dealsList =
        dealsJson.map((i) => Contact.fromJson(i)).toList();
    return ContactList(
        deals: dealsList, total: json['total'], next: json['next']);
  }
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}

List<String> getStatusIdList(Iterable<List<dynamic>> statusId) {
  List<String> statusIdList = [];

  statusId.forEach((value) {
    if (!value[0]) {
      statusIdList.add(value[1]);
    }
  });

  return statusIdList;
}
