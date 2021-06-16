import 'dart:convert';
import 'package:http/http.dart' as http;

class Deal {
  final String id;

  String title;
  String typeId;
  String stageId;
  String? probability;
  String currencyId;
  double opportunity;
  String? leadId;
  String? contactId;

  String? dataCreate;
  String? dateModify;

  Deal(
      {required this.id,
      required this.title,
      required this.typeId,
      required this.stageId,
      required this.currencyId,
      required this.opportunity,
      this.probability,
      this.contactId,
      this.leadId,
      this.dataCreate,
      this.dateModify});

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(
        id: json['ID'],
        title: json['TITLE'],
        typeId: json['TYPE_ID'] ?? '',
        stageId: getStageWord(json['STAGE_ID']) ?? 'NEW',
        currencyId: json['CURRENCY_ID'],
        opportunity: double.parse(json['OPPORTUNITY'] ?? '0'),
        probability: json['PROBABILITY'],
        contactId: json['CONTACT_ID'],
        leadId: json['LEAD_ID'],
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
  List<Deal> deals;
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

    List<Deal> dealsList = dealsJson.map((i) => Deal.fromJson(i)).toList();
    return DealsList(
        deals: dealsList, total: json['total'], next: json['next']);
  }
}

Future<DealsList> getDealsList(
    {required int start,
    DealsList? dealsList,
    required Iterable<List> stageIdList}) async {
  const url =
      'https://b24-jnhi2r.bitrix24.ru/rest/1/pe1gbzl0hiihhcjq/crm.deal.list';

  var data = <String, dynamic>{
    'start': start.toString(),
    'order': {'DATE_MODIFY': 'DESC'},
    'select': ['*', 'UF_*'],
    'filter': {'!STAGE_ID': getStageIdList(stageIdList)}
  };
  print(getStageIdList(stageIdList));
  final response = await http.post(Uri.parse(url),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json; charset=UTF-8'});
  // final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    if (dealsList != null) {
      DealsList newDealsList = DealsList.fromJson(json.decode(response.body));
      newDealsList.deals.insertAll(0, dealsList.deals);

      return newDealsList;
    }
    return DealsList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error; ${response.reasonPhrase}');
  }
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
