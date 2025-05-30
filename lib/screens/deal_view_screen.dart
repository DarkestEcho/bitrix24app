import 'package:bitrix24/models/bitrix24.dart';
import 'package:bitrix24/models/deal.dart';
import 'package:bitrix24/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DealViewPage extends StatefulWidget {
  final Function() function;
  final String _webhook;
  final Deal deal;
  const DealViewPage({
    Key? key,
    required this.deal,
    required String webhook,
    required this.function,
  })  : this._webhook = webhook,
        super(key: key);

  @override
  _DealViewPageState createState() => _DealViewPageState();
}

class _DealViewPageState extends State<DealViewPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _oppController = TextEditingController();

  final _probController = TextEditingController();
  final _contactController = TextEditingController();
  final _commentsController = TextEditingController();
  final _dateCreateController = TextEditingController();
  final _dateModifyController = TextEditingController();
  final _idController = TextEditingController();

  final _titleFocus = FocusNode();
  final _oppFocus = FocusNode();

  final _probFocus = FocusNode();
  final _contactFocus = FocusNode();
  final _commentsFocus = FocusNode();
  final _dateCreateFocus = FocusNode();
  final _dateModifyFocus = FocusNode();
  final _idFocus = FocusNode();

  Map<String, String> _currencies = {
    'RUB': 'Российский рубль',
    'USD': 'Доллар США',
    'EUR': 'Евро',
    'UAH': 'Гривна',
    'BYN': 'Белорусский рубль'
  };

  Map<String, String> _stages = {
    'NEW': 'Новая',
    'PREPARATION': 'Подготовка документов',
    'PREPAYMENT_INVOICE': 'Счет на предоплату',
    'EXECUTING': 'В работе',
    'FINAL_INVOICE': 'Финальный счет',
    'WON': 'Сделка успешна',
    'LOSE': 'Сделка провалена'
  };

  void dispose() {
    _titleController.dispose();
    _oppController.dispose();
    _probController.dispose();
    _contactController.dispose();
    _commentsController.dispose();
    _dateCreateController.dispose();
    _dateModifyController.dispose();
    _idController.dispose();

    _titleFocus.dispose();
    _oppFocus.dispose();
    _probFocus.dispose();
    _contactFocus.dispose();
    _commentsFocus.dispose();
    _dateCreateFocus.dispose();
    _dateModifyFocus.dispose();
    _idFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _titleController.text = widget.deal.title;
    _oppController.text = widget.deal.opportunity.toString();
    _probController.text = widget.deal.probability ?? '';
    _contactController.text = widget.deal.contactId ?? '';
    _commentsController.text = widget.deal.comments ?? '';

    _selectedCurrency = widget.deal.currencyId;
    _stages.forEach((key, value) {
      if (value == widget.deal.stageId) {
        this._selectedStage = key;
      }
    });
    super.initState();
  }

  String _selectedCurrency = 'RUB';
  String _selectedStage = 'NEW';

  bool isEdit = false;
  Bitrix24 bitrix24 = Bitrix24(webhook: webhook);

  @override
  Widget build(BuildContext context) {
    Map<String, String> createDateTime =
        bitrix24.dateParser(widget.deal.dataCreate!);
    Map<String, String> modifyDateTime =
        bitrix24.dateParser(widget.deal.dateModify!);
    return Scaffold(
      // backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        backgroundColor: Color(0xeeB1F2B36), //Color(0xddff7043),
        title: Text(''),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isEdit = !isEdit;
                });
              },
              icon: Icon(isEdit ? Icons.edit_off : Icons.edit)),
          SizedBox(
            width: 18,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/wp_3_rocks.jpg'),
                      fit: BoxFit.cover)),
              // color: Colors.white10,
              child: Container(
                color: Colors.white70,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: [
                    getTextFormField(
                      value: widget.deal.id,
                      context: context,
                      currentFocus: _idFocus,
                      controller: _idController,
                      labelText: 'ID',
                      isEnabled: false,
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    getTextFormField(
                        value: _titleController.text, //widget.deal.title,
                        autofocus: true,
                        context: context,
                        currentFocus: _titleFocus,
                        nextFocus: _oppFocus,
                        controller: _titleController,
                        labelText: 'Название',
                        hintText: 'Сделка #'),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                      value: _oppController.text,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp(r'^[\d\.]+'),
                            allow: true),
                      ],
                      context: context,
                      currentFocus: _oppFocus,
                      nextFocus: _contactFocus,
                      controller: _oppController,
                      labelText: 'Сумма',
                      validator: _validateOpportunity,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getDropdownButtonFormField(
                      // width: 186,
                      items: _currencies,
                      labelText: 'Валюта',
                    ),

                    SizedBox(
                      height: 15,
                    ),
                    getDropdownButtonFormField(
                      // width: 148,
                      items: _stages,
                      labelText: 'Стадия',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                        value: _contactController.text,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp(r'^[\d]+'),
                              allow: true),
                        ],
                        context: context,
                        currentFocus: _contactFocus,
                        controller: _contactController,
                        nextFocus: _probFocus,
                        labelText: 'Контакт',
                        hintText: 'Id контакта'),
                    SizedBox(
                      height: 15,
                    ),
                    // getDropdownButtonFormField(),
                    getTextFormField(
                      value: _probController.text,
                      context: context,
                      currentFocus: _probFocus,
                      controller: _probController,
                      labelText: 'Вероятность',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp(r'^[\d]+'),
                            allow: true),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                      value:
                          "${createDateTime['date']} ${createDateTime['time']}",
                      context: context,
                      currentFocus: _dateCreateFocus,
                      controller: _dateCreateController,
                      labelText: 'Дата начала',
                      isEnabled: false,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                      value:
                          "${modifyDateTime['date']} ${modifyDateTime['time']}",
                      context: context,
                      currentFocus: _dateModifyFocus,
                      controller: _dateModifyController,
                      labelText: 'Дата изменения',
                      isEnabled: false,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                      value: _commentsController.text,
                      context: context,
                      minLines: 1,
                      maxLines: 4,
                      currentFocus: _commentsFocus,
                      controller: _commentsController,
                      labelText: 'Комментарий',
                      inputFormatters: [LengthLimitingTextInputFormatter(150)],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    isEdit
                        ? ElevatedButton(
                            onPressed: () {
                              _submitForm();
                            },
                            child: Text('Сохранить',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xeeB1F2B36)),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(18)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 2, color: Color(0xFFB151E26)),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateOpportunity(String? value) {
    if (value == null) {
      return null;
    }

    List<String> list = value.split(RegExp(""));
    int c = 0;
    list.forEach((element) {
      if (element == '.') {
        c++;
      }
    });

    if (c > 1) {
      return 'Значение введено некорректно';
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      _showMessage(message: 'Сохранено');
      Bitrix24 bitrix24 = Bitrix24(webhook: widget._webhook);
      bitrix24.crmDealUdpade(
          id: widget.deal.id,
          title: _titleController.text,
          opportunity: _oppController.text,
          stageId: _selectedStage,
          contactId: _contactController.text,
          comments: _commentsController.text,
          probability: _probController.text,
          currencyId: _selectedCurrency);

      widget.function();
      Navigator.pop(context);
      return;
    }
    _showMessage(
        message:
            'Форма заполнена некорректно. Пожалуйста, исправьте ошибки и продолжите.',
        isBad: true);

    // _showMessage(message: 'Форма заполнена некорректно ', isBad: true);
  }

  Container getDropdownButtonFormField(
      {required String labelText,
      required Map<String, String> items,
      double? width}) {
    return Container(
      // width: 200,
      margin: width == null ? null : EdgeInsets.only(right: width),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black87),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFFB151E26), width: 2.0),
          ),
        ),
        items: items.values.map((item) {
          return DropdownMenuItem(
            child: Text(item),
            value: item,
          );
        }).toList(),
        onChanged: isEdit
            ? (currency) {
                print(currency);
                setState(
                  () {
                    items.forEach((key, value) {
                      if (value == currency) {
                        if (labelText == 'Валюта')
                          this._selectedCurrency = key;
                        else
                          this._selectedStage = key;
                      }
                    });
                  },
                );
              }
            : null,
        value: labelText == 'Валюта'
            ? items[this._selectedCurrency]
            : items[this._selectedStage],

        // validator: (val) {
        //   return val == null ? 'Please select a country' : null;
        // },
      ),
    );
  }

  void _showMessage({required String message, bool isBad = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(60),
          ),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: isBad ? Colors.red : Colors.green,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: isBad ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20),
        ),
      ),
    );
  }

  TextFormField getTextFormField(
      {String? value,
      bool? isEnabled,
      String? Function(String?)? validator,
      TextInputType? keyboardType,
      bool autofocus = false,
      required String labelText,
      String? hintText,
      required BuildContext context,
      required FocusNode currentFocus,
      FocusNode? nextFocus,
      required TextEditingController controller,
      int? minLines,
      int? maxLines,
      List<TextInputFormatter>? inputFormatters}) {
    controller.text = value ?? '';
    return TextFormField(
      enabled: isEnabled ?? isEdit,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      // minLines: minLines ?? 1,
      maxLines: maxLines ?? 1,
      // style: TextStyle(color: Colors.red),
      focusNode: currentFocus,
      autofocus: autofocus,
      onFieldSubmitted: (_) {
        _fieldFocusChange(context, currentFocus, nextFocus);
      },
      controller: controller,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.only(left: 10),
        labelText: '  $labelText',
        hintText: hintText,
        // prefixIcon: Icon(Icons.edit_rounded),
        suffixIcon: isEdit
            ? GestureDetector(
                child: Icon(
                  Icons.delete_outline,
                  // color: Colors.red,
                ),
                onTap: () => controller.clear(),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.black54, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Color(0xFFB151E26), width: 2.0),
        ),
      ),
      // validator: _validateName,
    );
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode? nextFocus) {
    currentFocus.unfocus();
    if (nextFocus == null) return;
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
