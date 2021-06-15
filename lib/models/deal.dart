class Deal {
  final int id;

  String title;
  String typeId;
  String stageId;
  int? probability;
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
        typeId: json['TYPE_ID'],
        stageId: json['STAGE_ID'],
        currencyId: json['CURRENCY_ID'],
        opportunity: json['OPPORTUNITY'],
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
