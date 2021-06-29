import 'package:bitrix24/models/bitrix24.dart';
import 'package:bitrix24/models/contact.dart';

import 'package:bitrix24/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactViewPage extends StatefulWidget {
  final Function() function;
  final String _webhook;
  final Contact contact;
  const ContactViewPage({
    Key? key,
    required this.contact,
    required String webhook,
    required this.function,
  })  : this._webhook = webhook,
        super(key: key);

  @override
  _ContactViewPageState createState() => _ContactViewPageState();
}

class _ContactViewPageState extends State<ContactViewPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _postController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _commentsController = TextEditingController();
  final _dateCreateController = TextEditingController();
  final _dateModifyController = TextEditingController();
  final _idController = TextEditingController();
  final _addressController = TextEditingController();

  final _nameFocus = FocusNode();
  final _secondNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _postFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _idFocus = FocusNode();
  final _addressFocus = FocusNode();

  final _commentsFocus = FocusNode();
  final _dateCreateFocus = FocusNode();
  final _dateModifyFocus = FocusNode();

  void dispose() {
    _addressController.dispose();
    _secondNameController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _postController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _commentsController.dispose();
    _dateCreateController.dispose();
    _dateModifyController.dispose();
    _idController.dispose();

    _addressFocus.dispose();
    _nameFocus.dispose();
    _secondNameFocus.dispose();
    _lastNameFocus.dispose();
    _phoneFocus.dispose();
    _postFocus.dispose();
    _emailFocus.dispose();
    _commentsFocus.dispose();
    _dateCreateFocus.dispose();
    _dateModifyFocus.dispose();
    _idFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  bool isEdit = false;
  Bitrix24 bitrix24 = Bitrix24(webhook: webhook);

  @override
  Widget build(BuildContext context) {
    Map<String, String> dateTime =
        bitrix24.dateParser(widget.contact.dataCreate!);
    Map<String, String> modifyDateTime =
        bitrix24.dateParser(widget.contact.dateModify!);
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
                      value: widget.contact.id,
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
                      value: widget.contact.lastName,
                      autofocus: true,
                      context: context,
                      currentFocus: _lastNameFocus,
                      nextFocus: _nameFocus,
                      controller: _lastNameController,
                      labelText: 'Фамилия',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                      value: widget.contact.name,
                      autofocus: true,
                      context: context,
                      currentFocus: _nameFocus,
                      nextFocus: _secondNameFocus,
                      controller: _nameController,
                      labelText: 'Имя',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                      value: widget.contact.secondName,
                      autofocus: true,
                      context: context,
                      currentFocus: _secondNameFocus,
                      nextFocus: _postFocus,
                      controller: _secondNameController,
                      labelText: 'Отчество',
                    ),
                    // getDropdownButtonFormField(),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                      value: widget.contact.post,
                      autofocus: true,
                      context: context,
                      currentFocus: _postFocus,
                      nextFocus: _phoneFocus,
                      controller: _postController,
                      labelText: 'Должность',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                      value: widget.contact.phone,
                      autofocus: true,
                      context: context,
                      currentFocus: _phoneFocus,
                      nextFocus: _emailFocus,
                      controller: _phoneController,
                      labelText: 'Телефон',
                      inputFormatters: [
                        // FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter(RegExp(r'^[()\d\+]+'),
                            allow: true),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                      value: widget.contact.email,
                      autofocus: true,
                      context: context,
                      currentFocus: _emailFocus,
                      nextFocus: _commentsFocus,
                      controller: _emailController,
                      labelText: 'Email',
                      validator: _validateEmail,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                      autofocus: true,
                      context: context,
                      currentFocus: _addressFocus,
                      nextFocus: _commentsFocus,
                      controller: _addressController,
                      labelText: 'Адрес',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                      value: "${dateTime['date']} ${dateTime['time']}",
                      context: context,
                      currentFocus: _dateCreateFocus,
                      controller: _dateCreateController,
                      labelText: 'Дата создания',
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
                      value: widget.contact.comments,
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
                            onPressed: () => _submitForm(),
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

  String? _validateEmail(String? value) {
    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return null;
    }
    if (!_emailController.text.contains('@') || !value.contains('.')) {
      return 'Неправильный email-адрес';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      _showMessage(message: 'Сохранено');
      Bitrix24 bitrix24 = Bitrix24(webhook: widget._webhook);
      bitrix24.crmLeadUpdate(
        id: widget.contact.id,
        name: _nameController.text,
        secondName: _secondNameController.text,
        lastName: _lastNameController.text,
        post: _postController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        comments: _commentsController.text,
      );

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
        suffixIcon: GestureDetector(
          child: Icon(
            Icons.delete_outline,
            // color: Colors.red,
          ),
          onTap: () => controller.clear(),
        ),
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
