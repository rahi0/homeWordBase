import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/FileShowingPage/FileShowingPage.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:homewardbase/screens/YourProfilePage/YourProfilePage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';


class EventDetailsPage extends StatefulWidget {
  final appointmentId;
  EventDetailsPage(this.appointmentId);
  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  bool isLoading = true;
  bool noData = false;
  var appointmentData;


   @override
  void initState() {
    super.initState();
    _getMedicalData();
  }


  _getMedicalData() async {

    setState(() {
      isLoading = true;
    });
   
    var res = await CallApi().getData('get_appointment_details/${widget.appointmentId}');
    final body = json.decode(res.body);
    //var homePageData;
    print(body);
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

       store.dispatch(AppointmentDetailsInfoAction(body['appointment_details'])); // update data in store...
       
       //print(store.state.biographicalInfoState);
       if (!mounted) return;
       setState(() {
         appointmentData = store.state.appointmentDetailsInfoState;
       });
       print(appointmentData);


    setState(() {
      isLoading = false;
      });
    }
    else if (res.statusCode == 400) {
      print("beng amar");
      setState(() {
      noData = true;
      isLoading = false;
      });
    }
    
    else{
      print("else o asi");
      setState(() {
      isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator()
      ),
    ) :
    Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(right: 0, left: 0),
                    child: Icon(Icons.chevron_left,
                        color: Colors.black, size: 25)),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    "Details",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "quicksand",
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.only(right: 0, left: 0),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: "quicksand",
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20, top: 25, right: 20),
              child: Text(
                appointmentData['title'] == null ? "":
                "${appointmentData['title']}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: mainColor,
                    fontFamily: "quicksand",
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 15, right: 20),
              child: Text(
                "Date",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 5, right: 20),
              child: Text(
                '${DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd").parse(appointmentData['from_date']))} ${appointmentData['from_time']} to ${DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd").parse(appointmentData['to_date']))} ${appointmentData['to_time']}',
               // " ${DateFormat("dd-MM-yyyy").format(appointmentData['from_date'])} 08:00 AM to 20-03-2020 08:00 PM",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 25, right: 20),
              child: Text(
                "Location",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 5, right: 20),
              child: Text(
                appointmentData['location'] == null ? "":
                "${appointmentData['location']}",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 25, right: 20),
              child: Text(
                "Description",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 5, right: 20),
              child: Text(
                appointmentData['description'] == null ? "":
                "${appointmentData['description']}",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),

            appointmentData['people'].length == 0 ?
            Container() :
            Container(
              margin: EdgeInsets.only(left: 20, top: 35, right: 20),
              child: Text(
                "People",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                  children: List.generate(appointmentData['people'].length, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push( context,MaterialPageRoute( builder: (context) => YourProfilePage(appointmentData['people'][index]['people_info']['id'])));
                  },
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 0, right: 5), 
                          child: Row(
                            children: <Widget>[

                              appointmentData['people'][index]['people_info']['profile_picture'] == null
                                              ? Container(
                                                margin: EdgeInsets.only(left: 20),
                                                  decoration: BoxDecoration(
                                                      color: selectedColor,
                                                      borderRadius: BorderRadius.circular(100)),
                                                  height: 45,
                                                  width: 45,
                                                  child: Center(
                                                      child: Text(
                                                    "${appointmentData['people'][index]['people_info']['first_name'][0].toUpperCase()}${appointmentData['people'][index]['people_info']['last_name'][0].toUpperCase()}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontFamily: "quicksand",
                                                        fontWeight: FontWeight.w600),
                                                  )),
                                                )
                               :
                              Container(
                                padding: EdgeInsets.all(24),
                                margin: EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                    color: selectedColor,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/image/pm1.png"),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(100)),
                                height: 45,
                                width: 45,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                                child: Text(
                                                  "${appointmentData['people'][index]['people_info']['first_name']} ${appointmentData['people'][index]['people_info']['last_name']}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: mainColor,
                                                      fontSize: 15,
                                                      fontFamily: "quicksand",
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, right: 30),
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 10,
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                  color: Color(0xffDCF7EE)
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                appointmentData['people'][index]['people_info']['user_type'] == null ? "" :
                                                "${appointmentData['people'][index]['people_info']['user_type']}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: selectedColor,
                                                    fontSize: 9,
                                                    fontFamily: "quicksand",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        appointmentData['people'][index]['people_info']['organization'] == null ? "" :
                                       "${appointmentData['people'][index]['people_info']['organization']}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: 12,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        appointmentData['people'].length - 1 == index
                            ? Container()
                            : Container(
                                //height: 15,
                                margin: EdgeInsets.only(
                                    left: 0, right: 0, top: 15, bottom: 15),
                                child: Divider(
                                  color: Colors.black,
                                  height: 2,
                                  thickness: 0.1,
                                  //indent: 20,
                                  endIndent: 0,
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              })),
            ),
            appointmentData['attachments'].length == 0 ?
            Container() :
            Container(
              margin: EdgeInsets.only(left: 20, top: 35, right: 20),
              child: Text(
                "Attachment",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 40, top: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Wrap(
                  children: List.generate(appointmentData['attachments'].length, (index) {
                    return GestureDetector(
                      onTap: (){
                        appointmentData['attachments'][index]['extension'] == "pdf" ?
                        _launchURL(appointmentData['attachments'][index]['url']) :
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => FullScreenImage(appointmentData['attachments'][index]['url'])));
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            appointmentData['attachments'][index]['extension'] == "pdf" ?
                             Container(
                               height: 95,
                              width: 80,
                              decoration: BoxDecoration(
                              color: Color(0xffECF0F3),
                              borderRadius:BorderRadius.circular(5)),
                              child: Image.asset(
                                      "assets/image/pdf.png",
                                      fit: BoxFit.contain,
                                     ),
                              ) :
                              Container(
                              height: 95,
                              width: 105,
                              decoration: BoxDecoration(
                                        color: Color(0xffECF0F3),
                                        borderRadius:BorderRadius.circular(5) ),
                                       child: appointmentData['attachments'][index]['url'] == null ?
                                       Container() :
                                       Hero(
                                         tag: '${appointmentData['attachments'][index]['url']}',
                                          child: Image.network(
                                                      CallApi().fileShowlurl +'${appointmentData['attachments'][index]['url']}',
                                                      fit: BoxFit.contain,
                                                      loadingBuilder: (context, child, progress){
                                                        return progress == null ?
                                                        child : LinearProgressIndicator();
                                                     },
                                                     ),
                                                    ),
                                           ),
                            SizedBox(height: 5),
                            Container(
                              width: appointmentData['attachments'][index]['extension'] == "pdf" ? 80 : 105,
                              child: Text(
                                appointmentData['attachments'][index]['doc_name'] == null ? "" :
                                "${appointmentData['attachments'][index]['doc_name']}",
                                style: TextStyle(
                                    color: Color(0xff354D5B),
                                    fontFamily: "quicksand",
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  /////////////////// pdf launch //////////////
  _launchURL(urlsecondPart) async {
    var url = CallApi().fileShowlurl+"${urlsecondPart}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  /////////////////// pdf launch //////////////
}
