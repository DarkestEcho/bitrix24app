import 'dart:convert';

import 'package:bitrix24/models/deal.dart';
import 'package:http/http.dart' as http;

class Bitrix24 {
  final String _weebhook;

  Bitrix24({required String weebhook}) : this._weebhook = weebhook;

  void crmDealAdd() {}

  Future<DealsList> crmDealList(
      {required int start,
      DealsList? dealsList,
      required Iterable<List> stageIdList}) async {
    var data = <String, dynamic>{
      'start': start.toString(),
      'order': {'DATE_MODIFY': 'DESC'},
      'select': ['*', 'UF_*'],
      'filter': {'!STAGE_ID': getStageIdList(stageIdList)}
    };
    print(getStageIdList(stageIdList));
    final response = await http.post(Uri.parse(_weebhook + 'crm.deal.list'),
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
}
