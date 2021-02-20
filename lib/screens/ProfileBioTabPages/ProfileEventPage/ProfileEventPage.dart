import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/main.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/EventDetailsPage/EventDetailsPage.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:intl/intl.dart';

class ProfileEventPage extends StatefulWidget {
  final caseId;
  ProfileEventPage(this.caseId);
  @override
  _ProfileEventPageState createState() => _ProfileEventPageState();
}

class _ProfileEventPageState extends State<ProfileEventPage> {
  bool isLoading = true;
  bool noAppoitmrntData = false;

  var appointmentData;

  List monYearList = [];
  List dayList = [];
  List dayList1 = [];
  List allList = [];
  List finalList = [];
  List newList = [];
  List eventList = [
    {
      'id': '8',
      'month': 'August 2020',
      'day': '02',
      'year': '2020',
      'weekDay': 'Sun',
      'details': "Appointment for Doctor's consultation",
      'stTime': '08:00 AM',
      'endTime': '11:00 AM',
      'pic': 'assets/image/pin.png',
    },
    {
      'id': '9',
      'month': 'August 2020',
      'day': '02',
      'year': '2020',
      'weekDay': 'Sun',
      'details': "Appointment for Doctor's consultation",
      'stTime': '08:00 AM',
      'endTime': '11:00 AM',
      'pic': 'assets/image/pin.png',
    },
    {
      'id': '1',
      'month': 'July 2020',
      'day': '29',
      'year': '2020',
      'weekDay': 'Wed',
      'details': "Appointment for Doctor's consultation",
      'stTime': '08:00 AM',
      'endTime': '11:00 AM',
      'pic': 'assets/image/pin.png',
    },
    {
      'id': '2',
      'month': 'July 2020',
      'day': '25',
      'year': '2020',
      'weekDay': 'Thu',
      'details': 'Doctor Appointment',
      'stTime': '01:30 PM',
      'endTime': '02:00 PM',
      'pic': 'assets/image/stethoscope.png',
    },
    {
      'id': '3',
      'month': 'July 2020',
      'day': '25',
      'year': '2020',
      'weekDay': 'Thu',
      'details': 'Doctor Appointment',
      'stTime': '08:00 AM',
      'endTime': '11:00 AM',
      'pic': 'assets/image/teeth.png',
    },
    {
      'id': '4',
      'month': 'June 2020',
      'day': '28',
      'year': '2020',
      'weekDay': 'Sun',
      'details': 'Casa home visit',
      'stTime': '08:00 AM',
      'endTime': '11:00 AM',
      'pic': 'assets/image/pin.png',
    },
    {
      'id': '5',
      'month': 'June 2020',
      'day': '28',
      'year': '2020',
      'weekDay': 'Sun',
      'details': 'Doctor Appointment',
      'stTime': '01:30 PM',
      'endTime': '02:00 PM',
      'pic': 'assets/image/stethoscope.png',
    },
    {
      'id': '6',
      'month': 'June 2020',
      'day': '28',
      'year': '2020',
      'weekDay': 'Sun',
      'details': 'Doctor Appointment',
      'stTime': '08:00 AM',
      'endTime': '11:00 AM',
      'pic': 'assets/image/teeth.png',
    },
    {
      'id': '7',
      'month': 'June 2020',
      'day': '25',
      'year': '2020',
      'weekDay': 'Thu',
      'details': 'Casa home visit',
      'stTime': '08:00 AM',
      'endTime': '11:00 AM',
      'pic': 'assets/image/pin.png',
    },
  ];

  var today = "";
  var currentDate = "";
  var currentMonth = "";
  var currentYear = "";
  var currentWeekDay = "";
  var lastID = "";

  @override
  initState() {
    super.initState();
    _getAppointmentsData();
    
  }


  _getAppointmentsData() async {

    setState(() {
      isLoading = true;
      DateTime dateTimeNow = DateTime.now();

      currentDate = DateFormat.d().format(dateTimeNow);
      currentMonth = DateFormat.MMMM().format(dateTimeNow);
      currentYear = DateFormat.y().format(dateTimeNow);
      currentWeekDay = DateFormat.E().format(dateTimeNow);

      today = currentMonth + " " + currentYear;
    });

    var res = await CallApi().getData('get_all_appointments/${widget.caseId}');
    final body = json.decode(res.body);
    //print(body);
     if(body['status'] == 'Token is Expired'){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
      else if (res.statusCode != 200) {

      print("Something went wrong");
      setState(() {
      isLoading = false;
      });
    }
    else if (res.statusCode == 200) {

       store.dispatch(AppointmentInfoAction(body)); // update data in store...
       if (!mounted) return;
       setState(() {
         appointmentData = store.state.appointmentInfoState;
       });
       //print(store.state.biographicalInfoState);
      if(appointmentData['all_appointments'].length != 0){
         if (!mounted) return;
       setState(() {
         

         ///////////////////////
         int isCurrentAvailable = 0;

      for (int i = 0; i < appointmentData['all_appointments'].length; i++) {
        if (currentDate.length == 1) {
          currentDate = "0" + currentDate;
        }
      //  print("currentDate + " " + currentMonth + " " + currentYear");
        print(currentDate + " " + currentMonth + " " + currentYear);
     //   print("eventList[i]['day'] + " " + eventList[i]['month']");
     //   print(eventList[i]['day'] + " " + eventList[i]['month']);
        if (currentDate + " " + currentMonth + " " + currentYear !=
            appointmentData['all_appointments'][i]['day'].toString() + " " + appointmentData['all_appointments'][i]['month']) {
          isCurrentAvailable = 1;
          print("isCurrentAvailable");
          print(isCurrentAvailable);
        }
        lastID = appointmentData['all_appointments'][i]['id'].toString();
      }

      List tempList = [];
      int lID = int.parse(lastID);

      if (isCurrentAvailable == 1) {
        tempList = appointmentData['all_appointments'];
        appointmentData['all_appointments'] = [];
        appointmentData['all_appointments'].add(
          {
            'id': '${lID + 1}',
            'month': '$currentMonth $currentYear',
            'day': '$currentDate',
            'year': '$currentYear',
            'weekDay': '$currentWeekDay',
            'title': '',
            'from_time': '',
            'to_time': '',
            'type': '',
          },
        );
        for (int i = 0; i < tempList.length; i++) {
          appointmentData['all_appointments'].add(
            {
              'id': '${tempList[i]['id']}',
              'month': '${tempList[i]['month']}',
              'day': '${tempList[i]['day']}',
              'year': '${tempList[i]['year']}',
              'weekDay': '${tempList[i]['weekDay']}',
              'title': '${tempList[i]['title']}',
              'from_time': '${tempList[i]['from_time']}',
              'to_time': '${tempList[i]['to_time']}',
              'type': '${tempList[i]['type']}',
            },
          );
        }
      }
         ///////////////////////
       });
      // print(appointmentData);
//////////////////////////////////////////////////////
       for (int i = 0; i < appointmentData['all_appointments'].length; i++) {
      if (!monYearList.contains("${appointmentData['all_appointments'][i]['month']}")) {
        monYearList.add("${appointmentData['all_appointments'][i]['month']}");
      }
    }

    List day = [];

    for (int i = 0; i < monYearList.length; i++) {
      dayList = [];
      day = [];
      for (int j = 0; j < appointmentData['all_appointments'].length; j++) {
        String monDate = "${appointmentData['all_appointments'][j]['month']}";
        if (monYearList[i] == monDate) {
          if (!day.contains(appointmentData['all_appointments'][j]['day'])) {
            day.add(appointmentData['all_appointments'][j]['day']);
            dayList.add({
              'day': appointmentData['all_appointments'][j]['day'],
              'weekDay': appointmentData['all_appointments'][j]['weekDay'],
              'title': appointmentData['all_appointments'][j]['title'],
            });
          }
        }
      }

      allList.add({'dayWeek': monYearList[i], 'list': dayList});
    }

    for (int x = 0; x < allList.length; x++) {
      for (int i = 0; i < allList[x]['list'].length; i++) {
        dayList1 = [];
        for (int j = 0; j < appointmentData['all_appointments'].length; j++) {
          if (allList[x]['list'][i]['day'] == appointmentData['all_appointments'][j]['day'] &&
              allList[x]['dayWeek'] == appointmentData['all_appointments'][j]['month']) {
            dayList1.add(
              {
                'id': appointmentData['all_appointments'][j]['id'],
                'month': appointmentData['all_appointments'][j]['month'],
                'day': appointmentData['all_appointments'][j]['day'],
                'year': appointmentData['all_appointments'][j]['year'],
                'weekDay': appointmentData['all_appointments'][j]['weekDay'],
                'title': appointmentData['all_appointments'][j]['title'],
                'from_time': appointmentData['all_appointments'][j]['from_time'],
                'to_time': appointmentData['all_appointments'][j]['to_time'],
                'type': appointmentData['all_appointments'][j]['type'],
              },
            );
          }
        }

        finalList.add({
          'dayWeek': allList[x]['dayWeek'],
          'day1': allList[x]['list'][i]['day'],
          'weekDay': allList[x]['list'][i]['weekDay'],
          'title': allList[x]['list'][i]['title'],
          'list1': dayList1
        });
      }
    }

    List checkingList = [];

    for (int i = 0; i < monYearList.length; i++) {
      checkingList = [];
      for (int j = 0; j < finalList.length; j++) {
        if (monYearList[i] == finalList[j]['dayWeek']) {
          checkingList.add({
            'dayWeek': finalList[j]['dayWeek'],
            'day1': finalList[j]['day1'],
            'weekDay': finalList[j]['weekDay'],
            'title': finalList[j]['title'],
            'list1': finalList[j]['list1']
          });
        }
      }
      newList.add({'monthDate': monYearList[i], 'info': checkingList});
    }
      }
      else {
        noAppoitmrntData = true;
      }

    // print("allList");
    // print(allList);

    // print("finalList");
    // print(finalList);

    //print("newList");
    //print(newList);
//////////////////////////////////////////////////////

    setState(() {
      isLoading = false;
      });
    }
    else if (res.statusCode == 400) {
      print("beng amar");
      setState(() {
      noAppoitmrntData = true;
      isLoading = false;
      });
    }
    
    else{
      print("else o asi");
      setState(() {
      isLoading = false;
      });
    }


// setState(() {
//       isLoading = false;
//       });
    
  }




  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator()
      ),
    ) :
    Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [

            /////////////////////////////// Today Start ////////////////////////////////
            Container(
                            margin: EdgeInsets.only(bottom: 15, top: 20),
                            child: Row(
                              crossAxisAlignment:
                                  appointmentData['today'].length == 0
                                      ? CrossAxisAlignment.center
                                      : CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                        margin: EdgeInsets.only(left: 20, top: 10),
                                        padding: EdgeInsets.only(top: appointmentData['today'].length == 0 ? 0 : 20),
                                        child: Text(
                                          "Today",
                                          style: TextStyle(
                                              color: Color(0xff272755),
                                              fontSize: 10,
                                              fontFamily: 'quicksand',
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                appointmentData['today'].length == 0
                                    ? Container(
                                        width: MediaQuery.of(context).size.width - 80,
                                        padding: EdgeInsets.only(
                                            left: 15, top: 15, bottom: 15, right: 15),
                                        margin: EdgeInsets.only(
                                            left:  13.5, top: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Container(
                                          child: Text(
                                            "Nothing Scheduled today",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Color(0xff003A5B),
                                                fontSize: 14,
                                                fontFamily: 'quicksand',
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      )
                                    : Column(
                                      children: List.generate(appointmentData['today'].length, (index){
                                        return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    EventDetailsPage(appointmentData['today'][index]['id'])));
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width - 80,
                                                        padding: EdgeInsets.only(
                                                            left: 15,
                                                            top: 15,
                                                            bottom: 15,
                                                            right: 15),
                                                        margin: EdgeInsets.only(
                                                            left:  20,
                                                            top: 10),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    10)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Container(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <Widget>[
                                                                    Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Container(
                                                                            child: Text(
                                                                              "${appointmentData['today'][index]['title']}",
                                                                              textAlign:
                                                                                  TextAlign.start,
                                                                              style: TextStyle(
                                                                                  color: Color(
                                                                                      0xff003A5B),
                                                                                  fontSize: 14,
                                                                                  fontFamily:
                                                                                      'quicksand',
                                                                                  fontWeight:
                                                                                      FontWeight
                                                                                          .w500),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                     Container(
                                                                            margin: EdgeInsets
                                                                                .only(
                                                                                    top: 5),
                                                                            child: Text(
                                                                              "${appointmentData['today'][index]['from_time']} - ${appointmentData['today'][index]['to_time']}",
                                                                              textAlign:
                                                                                  TextAlign
                                                                                      .justify,
                                                                              style: TextStyle(
                                                                                  color: Color(
                                                                                      0xff354D5B),
                                                                                  fontSize:
                                                                                      12,
                                                                                  fontFamily:
                                                                                      'quicksand',
                                                                                  fontWeight:
                                                                                      FontWeight
                                                                                          .w400),
                                                                            ),
                                                                          ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                             Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        color: Color(
                                                                                0xffDCF7EE)
                                                                            .withOpacity(
                                                                                0.5),
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                    15)),
                                                                    child: Image.asset(
                                                                      appointmentData['today'][index]['type'] == 'Biographical' ?
                                                                      'assets/image/growth.png' :
                                                                      appointmentData['today'][index]['type'] == 'Medical' ?
                                                                      'assets/image/stethoscope.png' :
                                                                      appointmentData['today'][index]['type'] == 'Dental' ?
                                                                      'assets/image/teeth.png' :
                                                                      appointmentData['today'][index]['type'] == 'Therapy' ?
                                                                      'assets/image/feather.png' :
                                                                      appointmentData['today'][index]['type'] == 'Education' ?
                                                                      'assets/image/lesson.png' :
                                                                      appointmentData['today'][index]['type'] == 'Legal' ?
                                                                      'assets/image/hammer.png' :
                                                                      'assets/image/pin.png'
                                                                        ),
                                                                  )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                      }),
                                    )
                              ],
                            ),
                          ),
            /////////////////////////////// Today End //////////////////////////////////
            
            /////////////////////////////// All Start //////////////////////////////////
            noAppoitmrntData ? Container():
            Container(
              child: Column(
                children: List.generate(newList.length, (index) {
                  return Container(
                    margin:
                        EdgeInsets.only(bottom: newList.length - 1 == index ? 70 : 0),
                    child: Column(
                      children: <Widget>[
                         Container(
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Text(
                                        newList[index]['monthDate'],
                                        style: TextStyle(
                                            color: Color(0xff171725),
                                            fontSize: 15,
                                            fontFamily: 'quicksand',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        //height: 15,
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20, top: 5),
                                        child: Divider(
                                          color: Colors.black,
                                          height: 2,
                                          thickness: 0.15,
                                          //indent: 20,
                                          endIndent: 0,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                        Column(
                            children:
                                List.generate(newList[index]['info'].length, (ind1) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Row(
                              crossAxisAlignment:  CrossAxisAlignment.start,
                              children: <Widget>[
                                newList[index]['monthDate'] == today &&
                                        newList[index]['info'][ind1]['day1'] ==
                                            currentDate &&
                                        newList[index]['info'][ind1]['weekDay'] ==
                                            currentWeekDay
                                    ? Container()
                                    : Column(
                                        children: <Widget>[
                                          Container(
                                            margin:
                                                EdgeInsets.only(left: 20, top: 10),
                                            child: Text(
                                              newList[index]['info'][ind1]['weekDay'],
                                              style: TextStyle(
                                                  color: Color(0xff272755),
                                                  fontSize: 10,
                                                  fontFamily: 'quicksand',
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                EdgeInsets.only(left: 20, top: 10),
                                            child: Text(
                                              newList[index]['info'][ind1]['day1'],
                                              style: TextStyle(
                                                  color: Color(0xff272755),
                                                  fontSize: 19,
                                                  fontFamily: 'quicksand',
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                newList[index]['info'][ind1]['list1'].length == 1 &&
                                        newList[index]['info'][ind1]['list1'][0]
                                                ['title'] ==
                                            ""
                                    ? Container()
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(
                                            newList[index]['info'][ind1]['list1']
                                                .length, (ind2) {
                                          return newList[index]['info'][ind1]['list1']
                                                      [ind2]['title'] ==
                                                  ""
                                              ? Container()
                                              : GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) =>EventDetailsPage(newList[index]['info'] [ind1]['list1'][ ind2]['id'])));
                                                  },
                                                  child: Container(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        80,
                                                    padding: EdgeInsets.only(
                                                        left: 15,
                                                        top: 15,
                                                        bottom: 15,
                                                        right: 15),
                                                    margin: EdgeInsets.only(
                                                        left: newList[index][
                                                                        'monthDate'] ==
                                                                    today &&
                                                                newList[index]['info']
                                                                            [ind1]
                                                                        ['day1'] ==
                                                                    currentDate &&
                                                                newList[index]['info']
                                                                            [ind1]
                                                                        ['weekDay'] ==
                                                                    currentWeekDay
                                                            ? 13.5
                                                            : 20,
                                                        top: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Row(
                                                                  children: <Widget>[
                                                                    Expanded(
                                                                      child: Container(
                                                                        child: Text(
                                                                          newList[index]['info']
                                                                                      [ind1]
                                                                                  ['list1'][
                                                                              ind2]['title'],
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          style: TextStyle(
                                                                              color: Color(
                                                                                  0xff003A5B),
                                                                              fontSize: 14,
                                                                              fontFamily:
                                                                                  'quicksand',
                                                                              fontWeight:
                                                                                  FontWeight
                                                                                      .w500),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                newList[index]['info'][
                                                                                    ind1]
                                                                                [
                                                                                'list1'][ind2]
                                                                            [
                                                                            'title'] ==
                                                                        ""
                                                                    ? Container()
                                                                    : Container(
                                                                        margin: EdgeInsets
                                                                            .only(
                                                                                top: 5),
                                                                        child: Text(
                                                                          newList[index]['info'][ind1]['list1']
                                                                                      [
                                                                                      ind2]
                                                                                  [
                                                                                  'from_time'] +
                                                                              " - " +
                                                                              newList[index]
                                                                                      [
                                                                                      'info'][ind1]['list1'][ind2]
                                                                                  [
                                                                                  'to_time'],
                                                                          textAlign:
                                                                              TextAlign
                                                                                  .justify,
                                                                          style: TextStyle(
                                                                              color: Color(
                                                                                  0xff354D5B),
                                                                              fontSize:
                                                                                  12,
                                                                              fontFamily:
                                                                                  'quicksand',
                                                                              fontWeight:
                                                                                  FontWeight
                                                                                      .w400),
                                                                        ),
                                                                      ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        newList[index]['info'][ind1]['list1'][ind2]['title'] ==
                                                                ""
                                                            ? Container()
                                                            : Container(
                                                                height: 40,
                                                                width: 40,
                                                                padding:
                                                                    EdgeInsets.all(
                                                                        10),
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                            0xffDCF7EE)
                                                                        .withOpacity(
                                                                            0.5),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                15)),
                                                                child: Image.asset(
                                                                      newList[index]['info'][ind1]['list1'][ind2]['type'] == 'Biographical' ?
                                                                      'assets/image/growth.png' :
                                                                      newList[index]['info'][ind1]['list1'][ind2]['type'] == 'Medical' ?
                                                                      'assets/image/stethoscope.png' :
                                                                      newList[index]['info'][ind1]['list1'][ind2]['type'] == 'Dental' ?
                                                                      'assets/image/teeth.png' :
                                                                      newList[index]['info'][ind1]['list1'][ind2]['type'] == 'Therapy' ?
                                                                      'assets/image/feather.png' :
                                                                      newList[index]['info'][ind1]['list1'][ind2]['type'] == 'Education' ?
                                                                      'assets/image/lesson.png' :
                                                                      newList[index]['info'][ind1]['list1'][ind2]['type'] == 'Legal' ?
                                                                      'assets/image/hammer.png' :
                                                                      'assets/image/pin.png'
                                                                    ),
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                        }))
                              ],
                            ),
                          );
                        }))
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
