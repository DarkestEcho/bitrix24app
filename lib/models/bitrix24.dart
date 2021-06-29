import 'dart:convert';
import 'dart:math';

import 'package:bitrix24/models/contact.dart';
import 'package:bitrix24/models/deal.dart';
import 'package:bitrix24/models/lead.dart';
import 'package:http/http.dart' as http;

class Bitrix24 {
  final String _webhook;

  Bitrix24({required String webhook}) : this._webhook = webhook;

  Future<int> crmDealAdd({
    String? title,
    String? stageId,
    String? contactId,
    String? probability,
    String? currencyId,
    String? opportunity,
    String? comments,
  }) async {
    var data = <String, Map<String, String?>>{
      'fields': {
        "TITLE": title,
        "STAGE_ID": stageId,
        "CONTACT_ID": contactId,
        "PROBABILITY": probability,
        "CURRENCY_ID": currencyId,
        "OPPORTUNITY": opportunity,
        "COMMENTS": comments
      }
    };
    print(data);
    final response = await http.post(Uri.parse(_webhook + 'crm.deal.add'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return 0;
    } else {
      return 1;
    }
  }

  Future<int> crmLeadAdd({
    String? title,
    String? statusId,
    String? currencyId,
    String? opportunity,
    String? comments,
    String? name,
    String? secondName,
    String? lastName,
    String? post,
    String? phone,
    String? email,
  }) async {
    var data = <String, Map<String, dynamic>>{
      'fields': {
        "TITLE": title,
        "STATUS_ID": statusId,
        "CURRENCY_ID": currencyId,
        "OPPORTUNITY": opportunity,
        "COMMENTS": comments,
        "NAME": name,
        "SECOND_NAME": secondName,
        "LAST_NAME": lastName,
        "POST": post,
        "UF_CRM_1624918437422": phone,
        "UF_CRM_1624918449208": email,
      }
    };
    print(data);
    final response = await http.post(Uri.parse(_webhook + 'crm.lead.add'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return 0;
    } else {
      return 1;
    }
  }

  Future<int> crmContactAdd({
    required String name,
    String? secondName,
    String? lastName,
    String? post,
    String? phone,
    String? email,
    String? address,
    String? comments,
  }) async {
    var data = <String, Map<String, dynamic>>{
      'fields': {
        "COMMENTS": comments,
        "NAME": name,
        "SECOND_NAME": secondName,
        "LAST_NAME": lastName,
        "POST": post,
        "ADDRESS": address,
        "UF_CRM_1624968219167": phone,
        "UF_CRM_1624968168488": email,
      }
    };
    print(data);
    final response = await http.post(Uri.parse(_webhook + 'crm.contact.add'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return 0;
    } else {
      return 1;
    }
  }

  Future<int> crmLeadUpdate({
    required String id,
    String? title,
    String? statusId,
    String? currencyId,
    String? opportunity,
    String? comments,
    String? name,
    String? secondName,
    String? lastName,
    String? post,
    String? phone,
    String? email,
  }) async {
    var data = <String, dynamic>{
      'id': id,
      'fields': {
        "TITLE": title,
        "STATUS_ID": statusId,
        "CURRENCY_ID": currencyId,
        "OPPORTUNITY": opportunity,
        "COMMENTS": comments,
        "NAME": name,
        "SECOND_NAME": secondName,
        "LAST_NAME": lastName,
        "POST": post,
        "UF_CRM_1624918437422": phone,
        "UF_CRM_1624918449208": email,
      }
    };
    print(data);
    final response = await http.post(Uri.parse(_webhook + 'crm.lead.update'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return 0;
    } else {
      return 1;
    }
  }

  Future<int> crmContactUpdate({
    required String id,
    required String name,
    String? secondName,
    String? lastName,
    String? post,
    String? phone,
    String? email,
    String? address,
    String? comments,
  }) async {
    var data = <String, dynamic>{
      'id': id,
      'fields': {
        "COMMENTS": comments,
        "NAME": name,
        "SECOND_NAME": secondName,
        "LAST_NAME": lastName,
        "POST": post,
        "ADDRESS": address,
        "UF_CRM_1624968219167": phone,
        "UF_CRM_1624968168488": email,
      }
    };
    print(data);
    final response = await http.post(Uri.parse(_webhook + 'crm.contact.update'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return 0;
    } else {
      return 1;
    }
  }

  Future<int> crmDealUdpade({
    required String id,
    String? title,
    String? stageId,
    String? contactId,
    String? probability,
    String? currencyId,
    String? opportunity,
    String? comments,
  }) async {
    var data = <String, dynamic>{
      'id': id,
      'fields': {
        "TITLE": title,
        "STAGE_ID": stageId,
        "CONTACT_ID": contactId,
        "PROBABILITY": probability,
        "CURRENCY_ID": currencyId,
        "OPPORTUNITY": opportunity,
        "COMMENTS": comments
      }
    };
    print(data);
    final response = await http.post(Uri.parse(_webhook + 'crm.deal.update'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print(0);
      return 0;
    } else {
      print(response.reasonPhrase);
      return 1;
    }
  }

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
      String? searchValue,
      required Iterable<List> stageIdList}) async {
    var data;
    if (searchValue == null) {
      data = <String, dynamic>{
        'start': start.toString(),
        'order': {'DATE_MODIFY': 'DESC'},
        'select': ['*', 'UF_*'],
        'filter': {
          '!STAGE_ID': getStageIdList(stageIdList),
        }
      };
    } else {
      data = <String, dynamic>{
        'start': start.toString(),
        'order': {'DATE_MODIFY': 'DESC'},
        'select': ['*', 'UF_*'],
        'filter': {
          '!STAGE_ID': getStageIdList(stageIdList),
          '%TITLE': searchValue
        }
      };
    }

    final response = await http.post(Uri.parse(_webhook + 'crm.deal.list'),
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

  Future<LeadsList> crmLeadList(
      {required int start,
      LeadsList? leadsList,
      String? searchValue,
      required Iterable<List> statusIdList}) async {
    var data;
    if (searchValue == null) {
      data = <String, dynamic>{
        'start': start.toString(),
        'order': {'DATE_MODIFY': 'DESC'},
        'select': ['*', 'UF_*'],
        'filter': {'!STATUS_ID': getStatusIdList(statusIdList)}
      };
    } else {
      data = <String, dynamic>{
        'start': start.toString(),
        'order': {'DATE_MODIFY': 'DESC'},
        'select': ['*', 'UF_*'],
        'filter': {
          '!STATUS_ID': getStatusIdList(statusIdList),
          '%TITLE': searchValue
        }
      };
    }

    final response = await http.post(Uri.parse(_webhook + 'crm.lead.list'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      if (leadsList != null) {
        LeadsList newDealsList = LeadsList.fromJson(json.decode(response.body));
        newDealsList.deals.insertAll(0, leadsList.deals);

        return newDealsList;
      }
      return LeadsList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error; ${response.reasonPhrase}');
    }
  }

  Future<ContactList> crmContactList({
    required int start,
    ContactList? contactList,
    String? searchValue,
  }) async {
    var data;
    if (searchValue == null) {
      data = <String, dynamic>{
        'start': start.toString(),
        'order': {'DATE_MODIFY': 'DESC'},
        'select': ['*', 'UF_*'],
      };
    } else {
      data = <String, dynamic>{
        'start': start.toString(),
        'order': {'DATE_MODIFY': 'DESC'},
        'select': ['*', 'UF_*'],
        'filter': {'%NAME': searchValue}
      };
    }

    final response = await http.post(Uri.parse(_webhook + 'crm.contact.list'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      if (contactList != null) {
        ContactList newContactList =
            ContactList.fromJson(json.decode(response.body));
        newContactList.contacts.insertAll(0, contactList.contacts);

        return newContactList;
      }
      return ContactList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error; ${response.reasonPhrase}');
    }
  }

  Future<int> crmDealDelete({required String id}) async {
    final response = await http.post(Uri.parse(_webhook + 'crm.deal.delete'),
        body: jsonEncode({'id': id}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return 0;
    }
    return 1;
  }

  Future<int> crmLeadDelete({required String id}) async {
    final response = await http.post(Uri.parse(_webhook + 'crm.lead.delete'),
        body: jsonEncode({'id': id}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return 0;
    }
    return 1;
  }

  Future<int> crmContactDelete({required String id}) async {
    final response = await http.post(Uri.parse(_webhook + 'crm.contact.delete'),
        body: jsonEncode({'id': id}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return 0;
    }
    return 1;
  }
}
