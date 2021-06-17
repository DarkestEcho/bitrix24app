import 'dart:convert';

import 'package:bitrix24/models/deal.dart';
import 'package:http/http.dart' as http;

class Bitrix24 {
  final String _weebhook;

  Bitrix24({required String weebhook}) : this._weebhook = weebhook;

  void crmDealAdd() {}

  Map<String, String> currency = {
    'RUB': 'руб.',
    'USD': '\$',
    'EUR': '€',
    'UAH': 'грн.',
    'BYN': 'б.руб.'
  };

  String getCurrencyName(String currencyId) {
    return currency[currencyId] ?? currencyId;
  }

  Map<String, String> dateParser(String preParserDate) {
    int dividerInd = preParserDate.indexOf('T');
    String tempDate = preParserDate.substring(0, dividerInd);
    String date =
        '${tempDate.substring(8, 10)}.${tempDate.substring(5, 7)}.${tempDate.substring(0, 4)}';

    String time = preParserDate.substring(dividerInd + 1, dividerInd + 6);
    return {'date': date, 'time': time};
  }

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

  Future<int> crmDealDelete({required String id}) async {
    final response = await http.post(Uri.parse(_weebhook + 'crm.deal.delete'),
        body: jsonEncode({'id': id}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return 0;
    }
    return 1;
  }
}
