import 'dart:ui';

import 'package:bitrix24/models/bitrix24.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactAddPage extends StatefulWidget {
  final Function() function;
  final String _webhook;
  const ContactAddPage(
      {Key? key, required String webhook, required this.function})
      : this._webhook = webhook,
        super(key: key);

  @override
  _ContactAddPageState createState() => _ContactAddPageState();
}

class _ContactAddPageState extends State<ContactAddPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _postController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _commentsController = TextEditingController();
  final _addressController = TextEditingController();

  final _nameFocus = FocusNode();
  final _secondNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _postFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _commentsFocus = FocusNode();

  void dispose() {
    _secondNameController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _postController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _commentsController.dispose();

    _nameFocus.dispose();
    _secondNameFocus.dispose();
    _lastNameFocus.dispose();
    _phoneFocus.dispose();
    _postFocus.dispose();
    _emailFocus.dispose();
    _addressFocus.dispose();
    _commentsFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        backgroundColor: Color(0xeeB1F2B36), //Color(0xddff7043),
        title: Text('Создание контакта'),
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
                        autofocus: true,
                        context: context,
                        currentFocus: _lastNameFocus,
                        nextFocus: _nameFocus,
                        controller: _lastNameController,
                        labelText: 'Фамилия'),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                      autofocus: true,
                      context: context,
                      currentFocus: _nameFocus,
                      nextFocus: _secondNameFocus,
                      controller: _nameController,
                      labelText: 'Имя *',
                      hintText: 'Контакт #',
                      validator: _validateName,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                        autofocus: true,
                        context: context,
                        currentFocus: _secondNameFocus,
                        nextFocus: _postFocus,
                        controller: _secondNameController,
                        labelText: 'Отчество'),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                        autofocus: true,
                        context: context,
                        currentFocus: _postFocus,
                        nextFocus: _phoneFocus,
                        controller: _postController,
                        labelText: 'Должность'),
                    SizedBox(
                      height: 15,
                    ),
                    getTextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.phone,
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
                      autofocus: true,
                      context: context,
                      currentFocus: _emailFocus,
                      nextFocus: _addressFocus,
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
                    ElevatedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: Text('Создать',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xeeB1F2B36)),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(18)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 2, color: Color(0xFFB151E26)),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      _showMessage(message: 'Контакт создан');
      Bitrix24 bitrix24 = Bitrix24(webhook: widget._webhook);
      bitrix24.crmContactAdd(
        comments: _commentsController.text,
        address: _addressController.text,
        name: _nameController.text,
        secondName: _secondNameController.text,
        lastName: _lastNameController.text,
        post: _postController.text,
        phone: _phoneController.text,
        email: _emailController.text,
      );

      widget.function();
      Navigator.pop(context);
      return;
    }
    _showMessage(
        message:
            'Форма заполнена некорректно. Пожалуйста, исправьте ошибки и продолжите.',
        isBad: true);
  }

  void _showMessage({required String message, bool isBad = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(60),
          ),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: isBad ? Colors.red : Colors.green,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: isBad ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 20),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Необходимо ввести имя контакта';
    }
    return null;
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

  TextFormField getTextFormField(
      {String? Function(String?)? validator,
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
    return TextFormField(
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
