import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utilities/funcAndData.dart';
import '../widgets/historyBody.dart';
import '../screens/history_not_arrived_page.dart';
import '../../main.dart';

class HistoryBooking extends StatelessWidget {
  const HistoryBooking({required this.filial});
  final String filial;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtils.darkgreenColor,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotArrived(filial: filial)));
            },
            child: Text('Не пришедшие',style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w300, color: ColorsUtils.whiteColor),),
          ),
        ],
      ),
      body: HistoryBodyWidget(filial: filial),
    );
  }
}
