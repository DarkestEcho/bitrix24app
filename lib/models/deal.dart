import 'dart:convert';
import 'package:http/http.dart' as http;

class Deal {
  final String id;

  String title;
  String typeId;
  String stageId;
  String? probability;
  String currencyId;
  String opportunity;
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
        stageId: json['STAGE_ID'],
        currencyId: json['CURRENCY_ID'],
        opportunity: json['OPPORTUNITY'] ?? '',
        probability: json['PROBABILITY'],
        contactId: json['CONTACT_ID'],
        leadId: json['LEAD_ID'],
        dataCreate: json['DATE_CREATE'],
        dateModify: json['DATE_MODIFY']);
  }
}

class DealsList {
  List<Deal> deals;
  DealsList({required this.deals});

  factory DealsList.fromJson(Map<String, dynamic> json) {
    var dealsJson = json['result'] as List;

    List<Deal> dealsList = dealsJson.map((i) => Deal.fromJson(i)).toList();
    return DealsList(deals: dealsList);
  }
}

Future<DealsList> getDealsList() async {
  const url =
      'https://b24-jnhi2r.bitrix24.ru/rest/1/pe1gbzl0hiihhcjq/crm.deal.list';

  var data = <String, dynamic>{
    'order': {'ID': 'DESC'},
    'select': ['*', 'UF_*']
  };
  final response = await http.post(Uri.parse(url),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json; charset=UTF-8'});
  // final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return DealsList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error; ${response.reasonPhrase}');
  }
}
