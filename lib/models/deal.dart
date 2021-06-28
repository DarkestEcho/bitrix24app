class Lead {
  final String id;

  String title;
  String typeId;
  String stageId;
  String? probability;
  String currencyId;
  double opportunity;
  String? leadId;
  String? contactId;
  String? comments;

  String? dataCreate;
  String? dateModify;

  Lead(
      {required this.id,
      required this.title,
      required this.typeId,
      required this.stageId,
      required this.currencyId,
      required this.opportunity,
      this.probability,
      this.contactId,
      this.leadId,
      this.comments,
      this.dataCreate,
      this.dateModify});

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
        id: json['ID'],
        title: json['TITLE'],
        typeId: json['TYPE_ID'] ?? '',
        stageId: getStageWord(json['STAGE_ID']) ?? 'NEW',
        currencyId: json['CURRENCY_ID'],
        opportunity: double.parse(json['OPPORTUNITY'] ?? '0'),
        probability: json['PROBABILITY'],
        contactId: json['CONTACT_ID'],
        leadId: json['LEAD_ID'],
        comments: json['COMMENTS'] == null
            ? null
            : removeAllHtmlTags(json['COMMENTS']),
        dataCreate: json['DATE_CREATE'],
        dateModify: json['DATE_MODIFY']);
  }
}

String? getStageWord(String stageId) {
  switch (stageId) {
    case 'NEW':
      return 'Новая';
    case 'PREPARATION':
      return 'Подготовка документов';
    case 'PREPAYMENT_INVOICE':
      return 'Счет на предоплату';
    case 'EXECUTING':
      return 'В работе';
    case 'FINAL_INVOICE':
      return 'Финальный счет';
    case 'LOSE':
      return 'Сделка провалена';
    case 'WON':
      return 'Сделка успешна';
  }
}

class DealsList {
  List<Lead> deals;
  int _total;
  int? _next;

  int get getTotal => _total;
  int get getNext => _next ?? 0;

  set setNext(int val) => this._next = val;

  void updateTotal() {
    _total += 50;
  }

  DealsList({required this.deals, required int total, int? next})
      : this._total = total,
        this._next = next;

  factory DealsList.fromJson(Map<String, dynamic> json) {
    var dealsJson = json['result'] as List;

    List<Lead> dealsList = dealsJson.map((i) => Lead.fromJson(i)).toList();
    return DealsList(
        deals: dealsList, total: json['total'], next: json['next']);
  }
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}

List<String> getStageIdList(Iterable<List<dynamic>> stageId) {
  List<String> stageIdList = [];

  stageId.forEach((value) {
    if (!value[0]) {
      stageIdList.add(value[1]);
    }
  });

  return stageIdList;
}
