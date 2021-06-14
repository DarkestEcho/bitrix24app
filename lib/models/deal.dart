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
}
