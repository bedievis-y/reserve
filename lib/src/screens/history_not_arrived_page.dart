import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utilities/funcAndData.dart';
import '../widgets/historyBody.dart';
import '../widgets/notArrivedBody.dart';
import '../../main.dart';

class NotArrived extends StatelessWidget {
  const NotArrived({required this.filial});
  final String filial;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtils.darkgreenColor,
      ),
      body: NotBodyArrived(filial: filial),
    );
  }
}