import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../main.dart';
import '../utilities/func.dart';
import '../utilities/colors.dart';


class AddPerson extends StatefulWidget {
  const AddPerson({required this.filial});
  final String filial;

  @override
  State<AddPerson> createState() => _AddPersonMilliyState();
}

class _AddPersonMilliyState extends State<AddPerson> {
  TimeOfDay time = TimeOfDay(hour: 20, minute: 10);

  String _userTable = '1';
  String _userName = '';
  String _userNumber = '';
  String _userPersons = '1';
  late String _userTime = '${time.hour}:${time.minute.toString().padLeft(2, '0')}';

  List<String> _tableMilliy = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
  ];
  List<String> _tableWest = [
    '100',
    '101',
    '102',
    '103',
    '104',
    '105',
    '106',
    '107',
    '108',
    '109',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtils.darkgreenColor,
        title: Text(
          'Введите данные для брони',
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20.r),
          children: [
            TextFormField(
              onChanged: (String value) {
                _userName = value;
              },
              decoration: inputdecoration('Имя'),
              inputFormatters: [
                LengthLimitingTextInputFormatter(15),
              ],
              validator: (val) => val!.isEmpty ? 'Введите имя' : null,
            ),
            SizedBox(
              height: 10.h,
            ),
            TextFormField(
              onChanged: (var value) {
                _userNumber = '+998' + value;
              },
              decoration: inputdecoration('Номер телефона', prefixText: '+998 '),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(9),
                FilteringTextInputFormatter(RegExp(r'^[()\d -]{1,9}$'),
                    allow: true),
              ],
              validator: (val) =>
                  _validatePhoneNumber(val!) ? null : 'Введите корректно номер',
            ),
            SizedBox(
              height: 15.h,
            ),
            SizedBox(
              height: 15.h,
            ),
            textFiled(text: 'Количество персон'),
            SizedBox(
              height: 10,
            ),
            DropdownButton<String>(
              menuMaxHeight: 300.h,
              value: _userPersons,
              iconSize: 20.r,
              elevation: 16,
              style: TextStyle(
                  fontSize: 24.sp, color: ColorsUtils.darkgreenColor),
              underline: Container(
                height: 2,
                color: ColorsUtils.darkgreenColor,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _userPersons = newValue!;
                });
              },
              items: <String>[
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '10',
              ].map<DropdownMenuItem<String>>(
                (String _userPersons) {
                  return DropdownMenuItem<String>(
                    value: _userPersons,
                    child: Text(_userPersons),
                  );
                },
              ).toList(),
            ),
            SizedBox(
              height: 15.h,
            ),
            textFiled(text: 'Выберите время и стол'),
            SizedBox(
              height: 10.h,
            ),
            Container(
              height: 50.h,
              child: ElevatedButton(
                onPressed: () async {
                  TimeOfDay? newTime =
                      await showTimePicker(context: context, initialTime: time);
                  if (newTime == null) return;

                  setState(() {
                    time = newTime;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(0, 47, 47, 50),
                  ),
                ),
                child: Text(
                  '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            DropdownButton(
              menuMaxHeight: 300.h,
              iconSize: 20.r,
              elevation: 16,
              style: TextStyle(
                  fontSize: 24.sp, color: ColorsUtils.darkgreenColor),
              underline: Container(
                height: 2,
                color: ColorsUtils.darkgreenColor,
              ),
              value: _userTable,
              onChanged: (String? newValue) {
                setState(() {
                  _userTable = newValue!;
                });
              },
              items: _tableSelection(widget.filial).map<DropdownMenuItem<String>>((_userTable) {
                return DropdownMenuItem<String>(
                  child: Text(_userTable),
                  value: _userTable,
                );
              }).toList(),
            ),
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150.w,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: () {
                      _submitForm();
                      Func.nowDate();
                    },
                    child: Text(
                      'Подтвердить',
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                ),
                Container(
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red,
                      ),
                    ),
                    child: Text(
                      'Отмена',
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  InputDecoration inputdecoration(String labelText, {String prefixText = ''}) {
    return InputDecoration(
      prefixText: prefixText,
      labelText: labelText,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide:
              BorderSide(color: ColorsUtils.darkgreenColor, width: 2.0)),
    );
  }

  _tableSelection(filial) {
    if (filial == 'milliy') {
      return _tableMilliy;
    } else {
      return _tableWest;
    }
  }

  _submitForm() {
    if (_formKey.currentState!.validate()) {
      addCollection();
      Navigator.pop(context);
    }
  }

  Future<String> addCollection() async {
    Func.returnData(widget.filial);
    var result = await Func.returnData(widget.filial).add({
      'name': _userName,
      'number': _userNumber,
      'time': _userTime,
      'count': _userPersons,
      'numberTable': _userTable,
      'date': Func.nowDate(),
      'created_date': Func.nowTime()
    });
    await addMultipleCollection(id: result.id);
    return 'Success';
  }

  Future<String?> addMultipleCollection({String? id}) async {
    Func.returnData(widget.filial);

    Func.returnData(widget.filial)
        .doc(id)
        .collection(Func.returnSubcollection(widget.filial))
        .add({
      'name': _userName,
      'number': _userNumber,
      'time': _userTime,
      'count': _userPersons,
      'numberTable': _userTable,
      'date': Func.nowDate(),
      'created_date': Func.nowTime()
    });
  }

  bool _validatePhoneNumber(String input) {
    final _phoneExp = RegExp(r'\d\d\d\d\d\d\d\d\d$');
    return _phoneExp.hasMatch(input);
  }
}

Widget textFiled({required String text}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: ColorsUtils.darkgreenColor),
  );
}

// 


