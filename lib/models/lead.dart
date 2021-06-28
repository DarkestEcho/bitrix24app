class Lead {
  final String id;

  String title;
  String name;
  String secondName;
  String lastName;
  String? comments;
  String? contactId;
  String? email;
  String? honorific;
  String? phone;
  String? post;
  String statusId;
  String currencyId;
  double opportunity;

  String? dataCreate;
  String? dateModify;

  Lead(
      {required this.id,
      required this.title,
      required this.name,
      required this.secondName,
      required this.lastName,
      required this.currencyId,
      required this.opportunity,
      required this.statusId,
      this.contactId,
      this.email,
      this.honorific,
      this.phone,
      this.post,
      this.comments,
      this.dataCreate,
      this.dateModify});

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
        id: json['ID'],
        title: json['TITLE'],
        name: json['NAME'] ?? '',
        secondName: json['SECOND_NAME'] ?? '',
        lastName: json['LAST_NAME'] ?? '',
        statusId: getStatusWord(json['STATUS_ID']) ?? 'NEW',
        currencyId: json['CURRENCY_ID'],
        opportunity: double.parse(json['OPPORTUNITY'] ?? '0'),
        post: json['POST'],
        email: json['EMAIL'],
        phone: json['PHONE'],
        honorific: json['HONORIFIC'],
        contactId: json['CONTACT_ID'],
        comments: json['COMMENTS'] == null
            ? null
            : removeAllHtmlTags(json['COMMENTS']),
        dataCreate: json['DATE_CREATE'],
        dateModify: json['DATE_MODIFY']);
  }
}

String? getStatusWord(String stageId) {
  switch (stageId) {
    case 'NEW':
      return 'Не обработан';
    case 'IN_PROCESS':
      return 'В работе';
    case 'PROCESSED':
      return 'Обработан';
    case 'JUNK':
      return 'Некачественный лид';
    case 'CONVERTED':
      return 'Качественный лид';
  }
}

class LeadsList {
  List<Lead> deals;
  int _total;
  int? _next;

  int get getTotal => _total;
  int get getNext => _next ?? 0;

  set setNext(int val) => this._next = val;

  void updateTotal() {
    _total += 50;
  }

  LeadsList({required this.deals, required int total, int? next})
      : this._total = total,
        this._next = next;

  factory LeadsList.fromJson(Map<String, dynamic> json) {
    var dealsJson = json['result'] as List;

    List<Lead> dealsList = dealsJson.map((i) => Lead.fromJson(i)).toList();
    return LeadsList(
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
