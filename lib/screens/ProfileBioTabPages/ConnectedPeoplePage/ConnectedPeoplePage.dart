import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:homewardbase/screens/YourProfilePage/YourProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class ConnectedPeoplePage extends StatefulWidget {
  final caseId;
  ConnectedPeoplePage(this.caseId);
  @override
  _ConnectedPeoplePageState createState() => _ConnectedPeoplePageState();
}

class _ConnectedPeoplePageState extends State<ConnectedPeoplePage> {
  bool isLoading = true;
  var caseMemberData;
  var user;
  
    @override
  initState() {
    super.initState();
    _getHomeData();
  }


  _getHomeData() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    user = json.decode(userJson);
    
    var res = await CallApi().getData('get_all_members/${widget.caseId}');
    final body = json.decode(res.body);
   // print(body);
     if(body['status'] == 'Token is Expired'){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
    else if (res.statusCode == 200) {
       // homePageData = MainData.fromJson(body);
       store.dispatch(CaseMemberInfoAction(body)); // update data in store...
       if (!mounted) return;
      setState(() {
      caseMemberData = store.state.caseMemberInfoState;
      isLoading = false;
      });
      print("Data Saved");
    } 
    else if (res.statusCode == 400){
      print("some proble occoured");
      setState(() {
      isLoading = false;
      });
    }
    else{
      print("Something went wrong");
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
    Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: Color(0xFFF8F8FA),
          child: Column(
            children: <Widget>[

  ///////////////////////////////////////////// Current Member /////////////////////////////////////////////             
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[                    
                    Container(
                      margin: EdgeInsets.only(top: 0),
                      child: Text(
                        "Current",
                        style: TextStyle(
                            color: Color(0xff313131),
                            fontFamily: 'quicksand',
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    margin: EdgeInsets.only(top: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                        children: List.generate(caseMemberData['Current'].length, (index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push( context, MaterialPageRoute(  builder: (context) => YourProfilePage(caseMemberData['Current'][index]['user_info']['id'])));
                        },
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 15, right: 5),
                                child: Row(
                                  children: <Widget>[
                                    caseMemberData['Current'][index]['user_info']['profile_picture'] == null
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: selectedColor,
                                            borderRadius: BorderRadius.circular(100)),
                                        height: 45,
                                        width: 45,
                                        //margin: EdgeInsets.only(left: 20),
                                        child: Center(
                                            child: Text(
                                          "${caseMemberData['Current'][index]['user_info']['first_name'][0].toUpperCase()}${caseMemberData['Current'][index]['user_info']['last_name'][0].toUpperCase()}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w600),
                                        )),
                                      )
                                    :
                                    Container(
                                      padding: EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                          color: selectedColor,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/image/cp4.png"),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(100)),
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
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                      child: Text(
                                                        "${caseMemberData['Current'][index]['user_info']['first_name']} ${caseMemberData['Current'][index]['user_info']['last_name']}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: mainColor,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "quicksand",
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Text(
                                                      "${caseMemberData['Current'][index]['user_info']['user_type']}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: selectedColor,
                                                          fontSize: 9,
                                                          fontFamily:
                                                              "quicksand",
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              caseMemberData['Current'][index]['user_info']['organization'] == null ?
                                              "" : "${caseMemberData['Current'][index]['user_info']['organization']}",
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

                                    caseMemberData['Current'][index]['user_info']['id'] == user['id'] ?
                                    SizedBox(width: 50,) :
                                    Container(
                                      padding: EdgeInsets.all(0),
                                      margin: EdgeInsets.only(right: 0),
                                      child: PopupMenuButton<int>(
                                        onSelected: (selected) {
                                          _showRemoveRejectDialog(1, caseMemberData['Current'][index], index);
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Color(0xff707070)
                                              .withOpacity(0.3),
                                        ),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 1,
                                            child: Text(
                                              "Remove",
                                              style: TextStyle(
                                                  color: Color(0xFF5A5B5C),
                                                  fontFamily: 'quicksand',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                        offset: Offset(0, 100),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              caseMemberData['Current'].length - 1 == index
                                  ? Container()
                                  : Container(
                                      //height: 15,
                                      margin: EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          top: 15,
                                          bottom: 15),
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
                    }))),
              ),

 ///////////////////////////////////////////// Current Member End /////////////////////////////////////////////

///////////////////////////////////// Pending Member Start ///////////////////////////////////////////////////
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 0),
                      child: Text(
                        "Pending",
                        style: TextStyle(
                            color: Color(0xff313131),
                            fontFamily: 'quicksand',
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    margin: EdgeInsets.only(top: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                        children: List.generate(caseMemberData['Pending'].length, (index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push( context, MaterialPageRoute( builder: (context) => YourProfilePage(caseMemberData['Pending'][index]['user_info']['id'])));
                        },
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 15, right: 5),
                                child: Row(
                                  children: <Widget>[
                                    caseMemberData['Pending'][index]['user_info']['profile_picture'] == null
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: selectedColor,
                                            borderRadius: BorderRadius.circular(100)),
                                        height: 45,
                                        width: 45,
                                        //margin: EdgeInsets.only(left: 20),
                                        child: Center(
                                            child: Text(
                                          "${caseMemberData['Pending'][index]['user_info']['first_name'][0].toUpperCase()}${caseMemberData['Pending'][index]['user_info']['last_name'][0].toUpperCase()}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w600),
                                        )),
                                      )
                                    :
                                    Container(
                                      padding: EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                          color: selectedColor,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/image/cp2.png"),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(100)),
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
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                      child: Text(
                                                        "${caseMemberData['Pending'][index]['user_info']['first_name']} ${caseMemberData['Pending'][index]['user_info']['last_name']}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: mainColor,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "quicksand",
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Text(
                                                      "${caseMemberData['Pending'][index]['user_info']['user_type']}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: selectedColor,
                                                          fontSize: 9,
                                                          fontFamily:
                                                              "quicksand",
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Text(
                                              caseMemberData['Pending'][index]['user_info']['organization'] == null ? "" :
                                              "${caseMemberData['Pending'][index]['user_info']['organization']}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontSize: 12,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(0),
                                      margin: EdgeInsets.only(right: 0),
                                      child: PopupMenuButton<int>(
                                        onSelected: (selected) {
                                          if (caseMemberData['Pending'][index]['status'] == "PendingAdd") {
                                            if (selected == 2) {
                                              _showRemoveRejectDialog(2, caseMemberData['Pending'][index], index);
                                            } else {
                                              _acceptNewMemberInvite(caseMemberData['Pending'][index], index);
                                            }
                                          } else {
                                            // _showAcceptCancelDialog(2);
                                            cancelRemovelButton(caseMemberData['Pending'][index], index);
                                          }
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Color(0xff707070)
                                              .withOpacity(0.3),
                                        ),
                                        itemBuilder: (context) => caseMemberData['Pending'][index]['status'] == "PendingAdd"
                                            ? [
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: Text(
                                                    "Accept",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF5A5B5C),
                                                        fontFamily: 'quicksand',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 2,
                                                  child: Text(
                                                    "Reject",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF5A5B5C),
                                                        fontFamily: 'quicksand',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ]
                                            : [
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: Text(
                                                    "Cancel Removal",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF5A5B5C),
                                                        fontFamily: 'quicksand',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ],
                                        offset: Offset(0, 100),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5, left: 70),
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 14, right: 14),
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  caseMemberData['Pending'][index]['status'] == "PendingAdd" ?
                                  "Pending Add" : "Pending Removal",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontFamily: "quicksand",
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              caseMemberData['Pending'].length - 1 == index
                                  ? Container()
                                  : Container(
                                      //height: 15,
                                      margin: EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          top: 15,
                                          bottom: 5),
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
                    }))),
              ),
///////////////////////////////////// Pending Member End ///////////////////////////////////////////////////


///////////////////////////////////// Former Member Start ///////////////////////////////////////////////////
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 0),
                      child: Text(
                        "Former",
                        style: TextStyle(
                            color: Color(0xff313131),
                            fontFamily: 'quicksand',
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 90),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    margin: EdgeInsets.only(top: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                        children: List.generate(caseMemberData['Former'].length, (index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(  context, MaterialPageRoute( builder: (context) => YourProfilePage(caseMemberData['Former'][index]['user_info']['id'])));
                        },
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 15, right: 5),
                                child: Row(
                                  children: <Widget>[
                                     caseMemberData['Former'][index]['user_info']['profile_picture'] == null
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: selectedColor,
                                            borderRadius: BorderRadius.circular(100)),
                                        height: 45,
                                        width: 45,
                                        //margin: EdgeInsets.only(left: 20),
                                        child: Center(
                                            child: Text(
                                          "${caseMemberData['Former'][index]['user_info']['first_name'][0].toUpperCase()}${caseMemberData['Former'][index]['user_info']['last_name'][0].toUpperCase()}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w600),
                                        )),
                                      )
                                    :
                                    Container(
                                      padding: EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                          color: selectedColor,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/image/cp1.png"),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(100)),
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
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                      child: Text(
                                                        "${caseMemberData['Former'][index]['user_info']['first_name']} ${caseMemberData['Former'][index]['user_info']['last_name']}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: mainColor,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "quicksand",
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Text(
                                                      "${caseMemberData['Former'][index]['user_info']['user_type']}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: selectedColor,
                                                          fontSize: 9,
                                                          fontFamily:
                                                              "quicksand",
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Text(
                                              caseMemberData['Former'][index]['user_info']['organization'] == null ? "" :
                                              "${caseMemberData['Former'][index]['user_info']['organization']}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontSize: 12,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              caseMemberData['Former'].length - 1 == index
                                  ? Container()
                                  : Container(
                                      //height: 15,
                                      margin: EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          top: 15,
                                          bottom: 5),
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
                    }))),
              ),
///////////////////////////////////// Former Member End ///////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _showRemoveRejectDialog(number, caseUser, index) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5),
                      ),
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                      width: 55,
                      height: 55,
                      margin: EdgeInsets.all(15),
                      child: Image.asset(number == 1
                          ? "assets/image/delete.png"
                          : "assets/image/unsuccess.png")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    "Are you sure?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff003A5B),
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Text(
                    number == 1
                        ? "Do you really want to remove ${caseUser['user_info']['first_name']} ${caseUser['user_info']['last_name']} from the case? ${caseUser['user_info']['first_name']} will be notified and can reject this action."
                        : "Do you really want to reject ${caseUser['user_info']['first_name']} ${caseUser['user_info']['last_name']}'s request to join this case?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff7A98A9),
                        fontWeight: FontWeight.w400,
                        fontSize: 11),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(
                                top: 0, bottom: 20, left: 0, right: 2.5),
                            decoration: BoxDecoration(
                              color: Color(0xffF8F8F8),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text("Cancel",
                                style: TextStyle(
                                    color: Color(0xff003A5B),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "quicksand"))),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            //Navigator.pop(context);
                            number == 1 ? removeMemberButton(caseUser, index) : _rejectNewCaseInvite(caseUser, index);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  top: 0, bottom: 20, left: 2.5, right: 0),
                              decoration: BoxDecoration(
                                color: Color(0xffF9423A),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(number == 1 ? "Remove" : "Reject",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "quicksand"))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<Null> _showAcceptCancelDialog(number) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5),
                      ),
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                      width: 55,
                      height: 55,
                      margin: EdgeInsets.all(15),
                      child: Image.asset(number == 1
                          ? "assets/image/success.png"
                          : "assets/image/delete.png")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    number == 1 ? "Success" : "Removal canceled",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff003A5B),
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: Text(
                    number == 1
                        ? "Philippa Jordan has been successfully added to this case"
                        : "Removal was successfully canceled.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff7A98A9),
                        fontWeight: FontWeight.w400,
                        fontSize: 11),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                        border: Border.all(color: Colors.white)),
                    child: Container(
                        width: 100,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(
                            top: 0, bottom: 20, left: 30, right: 30),
                        decoration: BoxDecoration(
                          color: selectedColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text("Done",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                fontFamily: "quicksand"))),
                  ),
                ),
              ],
            ),
          );
        });
  }

 ////////////////////////////////// remove Member ///////////////////////////
 void removeMemberButton(caseUserRemove, index) async {
   setState(() {
     isLoading = true;
   });
   Navigator.pop(context);

      var data = {
                  "id": caseUserRemove['id'],
                  "case_general_id": widget.caseId,
                  "user_id": user['id'],
                  "member_id": caseUserRemove['member_id'],
                };

         print(data);
      var res = await CallApi().postData(data, 'remove_from_case');
       var body = json.decode(res.body);
       print(body);

       if(res.statusCode == 400){
        _errorDialog("Something went wrong");
        setState(() {
          isLoading = false;
        });
      }
      else if(res.statusCode == 200){
         //  _showDoneDialog(1);

        for(var d in store.state.caseMemberInfoState['Current']){
        if(d['id'] == caseUserRemove['id']){
          store.state.caseMemberInfoState['Current'][index]['status'] = "PendingRemoval";
          store.state.caseMemberInfoState['Current'].remove(caseUserRemove);
          store.state.caseMemberInfoState['Pending'].add(caseUserRemove);
          store.dispatch(CaseMemberInfoAction(store.state.caseMemberInfoState));
          break;
        }
      }
          setState(() {
          isLoading = false;
        });
      }
      else{
        _errorDialog("Something went wrong");
        setState(() {
          isLoading = false;
        });
      }
   
 }
 ////////////////////////////////// remove Member ///////////////////////////
 

  ////////////////////////////////// Cancel removel Member ///////////////////////////
 void cancelRemovelButton(caseCencelRemovel, index) async {
   setState(() {
     isLoading = true;
   });

      var data = {
                  "id": caseCencelRemovel['id'],
                  "case_general_id": widget.caseId,
                  "member_id": caseCencelRemovel['member_id'],
                };

         print(data);
         
      var res = await CallApi().postData(data, 'cancel_removal');
       var body = json.decode(res.body);
       print(body);

       if(res.statusCode == 400){
        _errorDialog("Something went wrong");
        setState(() {
          isLoading = false;
        });
      }
      else if(res.statusCode == 200){

        for(var d in store.state.caseMemberInfoState['Pending']){
        if(d['id'] == caseCencelRemovel['id']){
          store.state.caseMemberInfoState['Pending'][index]['status'] = "Current";
          store.state.caseMemberInfoState['Pending'].remove(caseCencelRemovel);
          store.state.caseMemberInfoState['Current'].add(caseCencelRemovel);
          store.dispatch(CaseMemberInfoAction(store.state.caseMemberInfoState));
          break;
        }
      }
      _showAcceptCancelDialog(2);
          setState(() {
          isLoading = false;
        });
      }
      else{
        _errorDialog("Something went wrong");
        setState(() {
          isLoading = false;
        });
      }
   
 }
 ////////////////////////////////// Cancel removel Member ///////////////////////////
 

 ////////////////////////  Accept New Member Invite STart  //////////////////////
  
  void _acceptNewMemberInvite(newMemberRequesT, index) async {
    setState(() {
      isLoading = true;
    });
    var data = {
      'newMemberRequest_id': newMemberRequesT['id'],
      'user_id': newMemberRequesT['user_id'],
      'case_general_id': newMemberRequesT['case_general_id']
    };

    print(data);

    var res = await CallApi().postData(data, 'accept_pending_add');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode != 200) {
      // show error msg
       _errorDialog("Something went wrong");
        setState(() {
      isLoading = false;
    });
    } else if (res.statusCode == 200 && body['msg'] == "Already Accepted"){
     // print(body['msg']);
     _errorDialog(body['msg']);
      setState(() {
      isLoading = false;
    });
    }
    else if (res.statusCode == 200 && body['success'] == true){


      for(var d in store.state.caseMemberInfoState['Pending']){
        if(d['id'] == newMemberRequesT['id']){
          store.state.caseMemberInfoState['Pending'][index]['status'] = "Current";
          store.state.caseMemberInfoState['Pending'].remove(newMemberRequesT);
          store.state.caseMemberInfoState['Current'].add(newMemberRequesT);
          store.dispatch(CaseMemberInfoAction(store.state.caseMemberInfoState));
          break;
        }
      }
      
      for(var d in store.state.homepageCaseState['newMemberRequest']){
        if(d['id'] == newMemberRequesT['id']){
          print(newMemberRequesT['id']);
          store.state.homepageCaseState['newMemberRequest'].remove(newMemberRequesT);
          store.dispatch(HomepageCaseAction(store.state.homepageCaseState));
          break;
        }
      }

      _showAcceptCancelDialog(1);
      setState(() {
      isLoading = false;
    });
    }else{
      _errorDialog("Something went wrong");
      setState(() {
      isLoading = false;
    });
    }
  }
////////////////////////  Accept New Member Invite End /////////////////////////



////////////////////////  Reject New case Invite STart  //////////////////////
  
  void _rejectNewCaseInvite(newMemberRequesT, index) async {
    setState(() {
      isLoading = true;
    });
    Navigator.pop(context);
    var data = {
      'newMemberRequest_id': newMemberRequesT['id']
    };

    print(data);

    var res = await CallApi().postData(data, 'reject_pending_add');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode != 200) {
      // show error msg
      _errorDialog("Something went wrong");
        setState(() {
      isLoading = false;
    });
    } else if (res.statusCode == 200 && body['success'] == true){
      for(var d in store.state.caseMemberInfoState['Pending']){
        if(d['id'] == newMemberRequesT['id']){
          store.state.caseMemberInfoState['Pending'].remove(newMemberRequesT);
          store.dispatch(CaseMemberInfoAction(store.state.caseMemberInfoState));
          break;
        }
      }
      for(var d in store.state.homepageCaseState['newMemberRequest']){
        if(d['id'] == newMemberRequesT['id']){
          print(newMemberRequesT['id']);
          store.state.homepageCaseState['newMemberRequest'].remove(newMemberRequesT);
          store.dispatch(HomepageCaseAction(store.state.homepageCaseState));
          break;
        }
      }
      setState(() {
      isLoading = false;
    });
    }else{
      _errorDialog("Something went wrong");
      setState(() {
      isLoading = false;
    });
    }
  }
////////////////////////  Reject New case Invite End /////////////////////////


 ////////////// Error Dialog STart //////////
  Future<Null> _errorDialog(title) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5),
                      ),
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      margin: EdgeInsets.all(15),
                      child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff003A5B),
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                      ),
                ),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.only(
                //         topRight: Radius.circular(5),
                //         topLeft: Radius.circular(5),
                //       ),
                //       color: Colors.white,
                //       border: Border.all(color: Colors.white)),
                //   padding: EdgeInsets.only(bottom: 10, top: 10),
                //   child: Text(
                //     title,
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //         fontFamily: 'quicksand',
                //         color: Color(0xff003A5B),
                //         fontWeight: FontWeight.bold,
                //         fontSize: 19),
                //   ),
                // ),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   decoration: BoxDecoration(
                //       color: Colors.white,
                //       border: Border.all(color: Colors.white)),
                //   padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                //   child: Text(
                //     number == 1
                //         ? "You have already sent a request to this case"
                //         : "You are already a member to this case",
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //         fontFamily: 'quicksand',
                //         color: Color(0xff7A98A9),
                //         fontWeight: FontWeight.w400,
                //         fontSize: 11),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                        border: Border.all(color: Colors.white)),
                    child: Container(
                        width: 100,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(
                            top: 0, bottom: 20, left: 30, right: 30),
                        decoration: BoxDecoration(
                          color: selectedColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text("Done",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                fontFamily: "quicksand"))),
                  ),
                ),
              ],
            ),
          );
        });
  }
////////////// Errort Dialog End //////////

}
