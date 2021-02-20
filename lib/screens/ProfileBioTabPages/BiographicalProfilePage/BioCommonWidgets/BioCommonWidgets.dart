import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/screens/FileShowingPage/FileShowingPage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';


class BioCommonLog extends StatelessWidget {
  final caseLog;
  final userId;
  BioCommonLog(this.caseLog, this.userId);

  @override
  Widget build(BuildContext context) {
    return 
     ////////////////////// Log Start ///////////////////////////////////////
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only( top: 15, bottom: 15),
              margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Log",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 14,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () {
                            menuSelected = 4;
                            Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ProfileBioPage()));
                          },
                          child: Text(
                            "See More",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: selectedColor,
                                fontSize: 11,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //height: 15,
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 0),
                    child: Divider(
                      color: Colors.black,
                      height: 2,
                      thickness: 0.1,
                      //indent: 20,
                      endIndent: 0,
                    ),
                  ),
                  Column(
                      children: List.generate( caseLog.length, (index) {
                    return Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 5, right: 10, bottom: 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      margin:
                          EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, top: 10, right: 10, bottom: 10),
                            margin:
                                EdgeInsets.only(left: 10, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                color: selectedColor,
                                borderRadius: BorderRadius.circular(100)),
                            child: Image.asset(
                              caseLog[index]['LogType'] == "Event" ?
                              'assets/image/calendar2.png' : caseLog[index]['LogType'] == "Update" ? 'assets/image/redo.png' : 'assets/image/money.png',
                              height: 14,
                              width: 14,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        right:
                                            caseLog[index]['LogType'] == "Log"
                                                ? 150
                                                : 100),
                                    child: Text(
                                      caseLog[index]['LogType'] == "Event" ? 
                                      'An event "${caseLog[index]['message']}" took place' :
                                      caseLog[index]['LogType'] == "Update" ? 

                                       userId == caseLog[index]['user_info']['id'] ?
                                     "You${caseLog[index]['message']}" : 
                                     "${caseLog[index]['user_info']['first_name']} ${caseLog[index]['message']}" : 

                                     userId == caseLog[index]['user_info']['id'] ?
                                     "You added to the log" :
                                     "${caseLog[index]['user_info']['first_name']} ${caseLog[index]['user_info']['last_name']} added to the log",
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: 12,
                                          fontFamily: "quicksand",
                                          fontWeight: caseLog[index]['seen'] == 0
                                              ? FontWeight.w700
                                              : FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "${DateFormat("dd/MM/yyyy").format(DateTime.parse(caseLog[index]['created_at']))}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color(0xff003A5B),
                                              fontSize: 12,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w400),
                                        ),
                                        caseLog[index]['LogType'] == "Log"
                                            ? Container(
                                                child: Row(
                                                 children: List.generate(caseLog[index]['log_tags'].length, (ind){
                                                    return Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.25),
                                                  borderRadius: BorderRadius.circular( 100)),
                                                  padding: EdgeInsets.only(left: 5, top: 5,right: 5,bottom: 5),
                                                  margin: EdgeInsets.only(left: 0,top: 0,right: 5),
                                                  child: Image.asset(
                                                 // caseLog[index]['log_tags'].length >= 1 &&
                                                  caseLog[index]['log_tags'][ind]['tag'] == "Biographical" ?
                                                   'assets/image/growth1.png' :
                                                  caseLog[index]['log_tags'][ind]['tag'] == "Medical" ?
                                                   'assets/image/stetho.png' :
                                                   caseLog[index]['log_tags'][ind]['tag'] == "Dental" ?
                                                   'assets/image/teeth1.png' :
                                                   caseLog[index]['log_tags'][ind]['tag'] == "Therapy" ?
                                                   'assets/image/feather1.png' :
                                                   caseLog[index]['log_tags'][ind]['tag'] == "Education" ?
                                                   'assets/image/lesson1.png' :
                                                   caseLog[index]['log_tags'][ind]['tag'] == "Legal" ?
                                                   'assets/image/legal.png' :
                                                   'assets/image/calendar1.png',
                                                    height: 8,
                                                  width: 8,
                                                      ),
                                                    );
                                                  })
                                                ),
                                              )
                                            : 
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.25),
                                                  borderRadius: BorderRadius.circular( 100)),
                                                  padding: EdgeInsets.only(left: 5, top: 5,right: 5,bottom: 5),
                                                  margin: EdgeInsets.only(left: 10,top: 0,right: 5),
                                                  child: Image.asset(
                                                  caseLog[index]['tag'] == "Biographical" ?
                                                   'assets/image/growth1.png' :
                                                   caseLog[index]['tag'] == "Medical" ?
                                                   'assets/image/stetho.png' :
                                                   caseLog[index]['tag'] == "Dental" ?
                                                   'assets/image/teeth1.png' :
                                                   caseLog[index]['tag'] == "Therapy" ?
                                                   'assets/image/feather1.png' :
                                                   caseLog[index]['tag'] == "Education" ?
                                                   'assets/image/lesson1.png' :
                                                   caseLog[index]['tag'] == "Legal" ?
                                                   'assets/image/legal.png' :
                                                   'assets/image/calendar1.png',
                                                    height: 8,
                                                  width: 8,
                                                      ),
                                                    ),
                                      ],
                                    ),
                                  ),
                                  caseLog[index]['LogType'] == "Log"
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              top: 15, right: 10),
                                          child: Text(
                                            caseLog[index]['description'] == null ? "" : "${caseLog[index]['description']}",
                                            //'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur tincidunt nulla nec rhoncus luctus. Morbi bibendum neque ut nunc accumsan, eget condimentum metus efficitur. Nullam eleifend volutpat est, a auctor nibh mollis sed. Integer sit amet purus ac diam mollis interdum ac ac metus. Etiam dictum mauris nec luctus pellentesque. ''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur tincidunt nulla nec rhoncus luctus. Morbi bibendum neque ut nunc accumsan, eget condimentum metus efficitur. Nullam eleifend volutpat est, a auctor nibh mollis sed. Integer sit amet purus ac diam mollis interdum ac ac metus. Etiam dictum mauris nec luctus pellentesque. ',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                color: Color(0xff003A5B),
                                                fontSize: 12,
                                                fontFamily: "quicksand",
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      : Container(),
                                  caseLog[index]['LogType'] == "Log"
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              bottom: 0, top: 15),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            child: Wrap(
                                              children: List.generate(
                                                  caseLog[index]['log_documents'].length, (ind) {
                                                return GestureDetector(
                                                  onTap: (){
                                                    caseLog[index]['log_documents'][ind]['extension'] == "pdf" ?
                                                    _launchURL(caseLog[index]['log_documents'][ind]['url']) :
                                                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => FullScreenImage(caseLog[index]['log_documents'][ind]['url'])));
                                                   
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 0, right: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        caseLog[index]['log_documents'][ind]['extension'] == "pdf" ?
                                                        Container(
                                                          height: 95,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                              color: Color(0xffECF0F3),
                                                              borderRadius:BorderRadius.circular(5)
                                                              ),
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
                                                              borderRadius:BorderRadius.circular(5)
                                                              ),
                                                          child: caseLog[index]['log_documents'][ind]['url'] == null ?
                                                          Container() :
                                                          Hero(
                                                            tag: '${caseLog[index]['log_documents'][ind]['url']}',
                                                            child: Image.network(
                                                                    CallApi().fileShowlurl +
                                                                    '${caseLog[index]['log_documents'][ind]['url']}',
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
                                                          child: Text(
                                                            "${caseLog[index]['log_documents'][ind]['doc_name']}.${caseLog[index]['log_documents'][ind]['extension']}",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff354D5B),
                                                                fontFamily:
                                                                    "quicksand",
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
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
                                      : Container(),
                                  caseLog.length - 1 == index
                                      ? Container()
                                      : Container(
                                          //height: 15,
                                          margin: EdgeInsets.only(
                                              left: 0,
                                              right: 0,
                                              top: 20,
                                              bottom: 0),
                                          child: Divider(
                                            color: Color(0xFF000000),
                                            height: 2,
                                            thickness: 0.1,
                                            //indent: 20,
                                            endIndent: 0,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
                ],
              ),
            );
            ////////////////////// Log End ////////////////////////////////////////
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
