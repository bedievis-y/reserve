import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utilities/funcAndData.dart';

class NotBodyArrived extends StatefulWidget {
  const NotBodyArrived({required this.filial});
  final String filial;
  @override
  State<NotBodyArrived> createState() => _NotBodyArrivedState();
}

class _NotBodyArrivedState extends State<NotBodyArrived> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: StreamBuilder(
        stream: DataBase.db
            .collection('Did not come')
            .doc(Func.returnDataNow())
            .collection(Func.returnSubcollection(widget.filial))
            .orderBy('created date')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print(!snapshot.hasData || snapshot.data!.docs.isEmpty);
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Брони отсутствовали',
                style: TextStyle(
                    fontSize: 22.sp, color: ColorsUtils.darkgreenColor),
              ),
            );
          }
          return Container(
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  key: Key(snapshot.data!.docs[index].id),
                  padding: EdgeInsets.only(top: 5.r),
                  child: Card(
                    color: ColorsUtils.darkgreenColor,
                    child: Container(
                      padding: EdgeInsets.all(15.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${snapshot.data?.docs[index].get('name')}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 24.sp,
                                    color: ColorsUtils.whiteColor),
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage("assets/img/bg-tiime.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Text(
                                    '${snapshot.data?.docs[index].get('number table')}',
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        color: ColorsUtils.darkgreenColor)),
                              ),
                            ],
                          ),
                          Text(
                              'Время: ${snapshot.data?.docs[index].get('arrival time')}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 22.sp,
                                  color: ColorsUtils.whiteColor)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              'Кол-во персон: ${snapshot.data?.docs[index].get('count')}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 22.sp,
                                  color: ColorsUtils.whiteColor)),
                          TextButton(
                            onPressed: () {
                              _makePhoneCall(
                                  snapshot.data?.docs[index].get('phone number'));
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(0)),
                            ),
                            child: Text(
                                '${snapshot.data?.docs[index].get('phone number')}',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: ColorsUtils.whiteColor,
                                  fontWeight: FontWeight.w300,
                                )),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(5.r),
                            decoration: BoxDecoration(
                              color: Colors.green,
                            ),
                            child: Text(
                                '${snapshot.data?.docs[index].get('created date')}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 22.sp,
                                    color: ColorsUtils.whiteColor)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}
