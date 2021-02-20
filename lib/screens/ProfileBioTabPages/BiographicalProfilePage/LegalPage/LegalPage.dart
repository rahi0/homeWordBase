import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:homewardbase/screens/FileShowingPage/FileShowingPage.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/BioCommonWidgets/BioCommonWidgets.dart';
import 'package:http/http.dart' as http;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:homewardbase/screens/ProfileBioPage/ProfileBioPage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';

class LegalPage extends StatefulWidget {
  final caseId;
  LegalPage(this.caseId);
  @override
  _LegalPageState createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {
  bool isLoading = true;
  bool noData = false;

  bool isDocumentPressed = false;
  bool isDocItemPressed = false;
  bool isFileUploading = false;
  bool isDocAvailable = false;
  var uploadedDocData;
  var user;

  File file;
  var path = "";

  var legalData;
  var caseLog;
  var status;

  bool isLegalEdit = false;

  TextEditingController docController = TextEditingController();
  TextEditingController noteController = TextEditingController();

   ///////////////////// Date Picker Essentials Start ///////////////////////
  String dateToLegal = '';
  DateTime selectedDateTo = DateTime.now();

  Future<Null> _selectDateTo(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
              primaryColor: selectedColor,
              accentColor: selectedColor
            ),
            child: child,
          );
        },
        context: context,
        initialDate: selectedDateTo,
        firstDate: DateTime(1964, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateTo) {
      setState(() {
        selectedDateTo = picked;
        dateToLegal ="${DateFormat("dd-MM-yyyy").format(selectedDateTo)}";
      });
    }
  }
  ///////////////////// Date Picker Essentials End ///////////////////////
  


   @override
  void initState() {
    super.initState();
    _getLegalData();
    //menuSelected = 0;
  }


  Future <void>_getLegalData() async {

    setState(() {
      isLoading = true;
    });

   SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    user = json.decode(userJson);
    //print(user);

   var data = {
      'case_general_id': widget.caseId,
      'user_id': user['id']
    };

    print(data);
    var res = await CallApi().postData(data, 'get_legal_details');
    final body = json.decode(res.body);
    //var homePageData;
   // print(body);
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

     // print(body['case_legal_details']);
      //if (body != null) {
       store.dispatch(LegalInfoAction(body['case_legal_details'])); // update data in store...
       
       //print(store.state.biographicalInfoState);
       if (!mounted) return;
       setState(() {
         legalData = store.state.legalInfoState;
         caseLog = store.state.commonLogInfoState;
       });
       print(legalData);
    
    dateToLegal = legalData['date'] == null ? "" : "${DateFormat("dd-MM-yyyy").format(DateTime.parse(legalData['date']))}";//"${DateFormat("dd-MM-yyyy").format(DateTime.now())}";
    noteController.text = legalData['note'] == null ? "" : legalData['note'];
    status = legalData['right_status'] == null ? "" : legalData['right_status'];
    

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
    RefreshIndicator(
      onRefresh: _getLegalData,
      child: ScrollConfiguration(
              behavior: new ScrollBehavior()
                ..buildViewportChrome(context, null, AxisDirection.down),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            color: Color(0xFFF8F8FA),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 0),
                        child: Text(
                          "Legal",
                          style: TextStyle(
                              color: Color(0xff313131),
                              fontFamily: 'quicksand',
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            isLegalEdit == false
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLegalEdit = false;
                                      });
                                    },
                                    child: Container(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 5, bottom: 5, left: 5, right: 5),
                                        margin: EdgeInsets.only(top: 0, right: 10),
                                        decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(color: mainColor)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Cancel",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isLegalEdit) {
                                    _saveLegalData();
                                  } else {
                                    isLegalEdit = true;
                                  }
                                });
                              },
                              child: Container(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 5, right: 5),
                                  margin: EdgeInsets.only(top: 0),
                                  decoration: BoxDecoration(
                                      color: selectedColor,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: selectedColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      isLegalEdit == false
                                          ? Icon(Icons.edit,
                                              size: 11, color: Colors.white)
                                          : Container(),
                                      Text(
                                        isLegalEdit == false ? " Edit" : "Save",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontFamily: "quicksand",
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            "Parental Rights",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: mainColor,
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
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
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  "Status",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xff777D82),
                                      fontSize: 14,
                                      fontFamily: "quicksand",
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    _showStatusChoiceDialog();
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 2,
                                    margin: EdgeInsets.only(left: 7),
                                    padding: EdgeInsets.only(
                                      bottom: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: isLegalEdit
                                            ? BorderSide(
                                                width: 0.7,
                                                color: Color(0xff777D82),
                                              )
                                            : BorderSide.none,
                                      ),
                                    ),
                                    child: Text(
                                     // "fpsdfg",
                                      legalData['right_status'] == null ? "" : "${legalData['right_status']}",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color(0xff777D82),
                                        fontSize: 14,
                                        fontFamily: "quicksand",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
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
                        GestureDetector(
                          onTap: !isLegalEdit
                                      ? null
                                      : () {
                                          _selectDateTo(context);
                                          // print(dateTo);
                                        },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Date",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xff777D82),
                                      fontSize: 14,
                                      fontFamily: "quicksand",
                                      fontWeight: FontWeight.w500),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    margin: EdgeInsets.only(left: 7),
                                    padding: EdgeInsets.only(
                                      bottom: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: isLegalEdit
                                            ? BorderSide(
                                                width: 0.7,
                                                color: Color(0xff777D82),
                                              )
                                            : BorderSide.none,
                                      ),
                                    ),
                                    child: Text(
                                      //"//02-12-2015",
                                      "${dateToLegal}",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color(0xff777D82),
                                        fontSize: 14,
                                        fontFamily: "quicksand",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Container(
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
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Termination Order",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff777D82),
                                        fontSize: 14,
                                        fontFamily: "quicksand",
                                        fontWeight: FontWeight.w500),
                                  ),
                                   isLegalEdit == false
                                  ? Container()
                                  :
                                  legalData['url'] == null ? GestureDetector(
                                      onTap: () {
                                         _showUploadDocDialog();
                                      },
                                      child: Container(
                                        child: Text(
                                          "+ Add Document",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: selectedColor,
                                              fontSize: 11,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ) :
                                    GestureDetector(
                                                      onTap: (){
                                                        legalData['url'] = null;
                                                        legalData['url_type'] = null;
                                                        legalData['extension'] = null;
                                                        store.dispatch(LegalInfoAction(store.state.legalInfoState));
                                                      },
                                                      child: Container(
                                                          margin: EdgeInsets.only(
                                                              right: 10),
                                                          child: Icon(
                                                                    Icons.delete,
                                                                    size: 18,
                                                                    color: Color(
                                                                        0xffF9423A),
                                                                  ),
                                                        ),
                                                    ),
                                ],
                              ),
                              SizedBox(height: 10),
                              legalData['url'] != null ?
                              Row(
                                children: [
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {
                                       isLegalEdit ? null : 
                                       _launchURL(legalData['url']);
                                      // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => PdfScreen(legalData['url'])));
                                      },
                                      child: Container(
                                        height: 102,
                                       // width: MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.only(left: 20),
                                        decoration: BoxDecoration(
                                            color: Color(0xffECF0F3).withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(5)),
                                            child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 32,
                                          width: 36,
                                          decoration: BoxDecoration(
                                              color: Color(0xffF5FDFA).withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(15)),
                                          child: Image.asset("assets/image/copy.png"),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Text(
                                            "Termination Order.${legalData['extension']}",
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                color: selectedColor,
                                                fontSize: 14,
                                                fontFamily: 'quicksand',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : Container(
                              width:  MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    width: 44,
                                    decoration: BoxDecoration(
                                        color: Color(0xffF5FDFA).withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Image.asset("assets/image/copy.png"),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: Text(
                                      "No documents have been added.",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          color: Color(0xff707070),
                                          fontSize: 14,
                                          fontFamily: 'quicksand',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  isLegalEdit == false ? Container() :
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // isDocAvailable = true;
                                        _showUploadDocDialog();
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 10, bottom: 10, left: 70, right: 70),
                                      margin: EdgeInsets.only(top: 20),
                                      decoration: BoxDecoration(
                                          color: selectedColor,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: selectedColor)),
                                      child: Text(
                                        "Upload",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ],
                          ),
                        ),
                        Container(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 15, top: 0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "Notes:",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xff777D82),
                                          fontSize: 14,
                                          fontFamily: "quicksand",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: isLegalEdit == false ? Container(
                                      child: Text(
                                        legalData['note'] == null ? "--" : "${legalData['note']}",
                                      //  "Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit. Donec Nec Nulla Nisl. Aliquam Hendrerit Placerat Lectus, Sit Amet Posuere Diam Egestas.",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            color: Color(0xff777D82),
                                            fontSize: 14,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ) : Container(
                                           // margin: EdgeInsets.only(left: 7),
                                            child: TextField(
                                              readOnly: isLegalEdit ? false : true,
                                              maxLines: null,
                                               keyboardType: TextInputType.text,
                                               textCapitalization: TextCapitalization.sentences,
                                               controller: noteController,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Color(0xff777D82),
                                                fontSize: 14,
                                                fontFamily: "quicksand",
                                                fontWeight: FontWeight.w500,
                                              ),
                                              cursorColor: selectedColor,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding: null,
                                                focusedBorder: isLegalEdit
                                                    ? UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: selectedColor,
                                                        ),
                                                      )
                                                    : InputBorder.none,
                                                border: isLegalEdit
                                                    ? UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Color(0xff777D82),
                                                        ),
                                                      )
                                                    : InputBorder.none,
                                              ),
                                            ),
                                          )
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ////////////////////// Log Start ///////////////////////////////////////
                BioCommonLog(caseLog, user['id'])
                ////////////////////// Log End ////////////////////////////////////////
              ],
            ),
          ),
        ),
      ),
    );
  }

  

  /////////////////// show parental rights status choice dialog ui start //////////////////
  Future<Null> _showStatusChoiceDialog() async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: StatefulBuilder(builder: (context, setState) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.only(bottom: 10, top: 20),
                          child: Text(
                            "Status",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'quicksand',
                                color: mainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                          status = "Terminated";
                          Navigator.pop(context);
                        });
                        store.state.legalInfoState['right_status'] = "Terminated";
                        store.dispatch(BiographicalInfoAction(store.state.legalInfoState));
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 15, right: 15, top: 20, bottom: 20),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: status == "Terminated"
                                          ? mainColor
                                          : Color(0xffD4DDE3),
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.done,
                                    color: status == "Terminated"
                                        ? Colors.white
                                        : Color(0xffD4DDE3),
                                    size: 15,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            'Terminated',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Color(0xff060606),
                                                fontSize: 14,
                                                fontFamily: 'quicksand',
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              status = "Not Terminated";
                            });
                            Navigator.pop(context);
                            store.state.legalInfoState['right_status'] = "Not Terminated";
                            store.dispatch(BiographicalInfoAction(store.state.legalInfoState));
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 30),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: status == "Not Terminated"
                                          ? mainColor
                                          : Color(0xffD4DDE3),
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.done,
                                    color: status == "Not Terminated"
                                        ? Colors.white
                                        : Color(0xffD4DDE3),
                                    size: 15,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            'Not Terminated',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Color(0xff060606),
                                                fontSize: 14,
                                                fontFamily: 'quicksand',
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
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
              }));
        });
  }
  /////////////////// show parental rights status choice dialog ui end //////////////////
  


///////////////////////////////////// _showUploadDocDialog /////////////////////////////////////////
  Future<Null> _showUploadDocDialog() async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: StatefulBuilder(builder: (context, setState) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.only(bottom: 10, top: 20),
                          child: Text(
                            "Upload Document",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'quicksand',
                                color: mainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),


                        path == "ok"
                        ///////////////////////// LAst Step start//////////////////////////
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    file = null;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 15, right: 15, top: 20, bottom: 20),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        height: 40,
                                        width: 40,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Color(0xffF5FDFA)
                                                .withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Image.asset("assets/image/google-docs.png"),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "Termination Order",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Color(0xff060606),
                                                      fontSize: 14,
                                                      fontFamily: 'quicksand',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Text(
                                                  "Remove",
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                      color: Color(0xff003A5B),
                                                      fontSize: 11,
                                                      fontFamily: 'quicksand',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              /////////////////// LAst Step End/////////////////////////
                              :
                              /////////////////// First  Step Start/////////////////////////
                            
                                Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          initMultiFilePickUp();
                                          setState(() {
                                            path = "ok";
                                            //isDocItemPressed = false;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 10,
                                              bottom: 20),
                                          padding: EdgeInsets.only(
                                              top: 20, bottom: 20, right: 10),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: 32,
                                                width: 32,
                                                child: Image.asset(
                                                    "assets/image/document_add.png"),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Text(
                                                  "Upload Document",
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                      color: Color(0xff7A98A9),
                                                      fontSize: 11,
                                                      fontFamily: 'quicksand',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ///////////////////////First  Step End//////////////////////////
                                



                                  
                        //isDocumentPressed
                        isFileUploading
                            ? Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: selectedColor)),
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 20),
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 8, bottom: 8),
                                child: SpinKitWave(
                                    color: selectedColor.withOpacity(0.5)))
                            : path == "ok"
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        border:
                                            Border.all(color: Colors.white)),
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, top: 0),
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            //Navigator.pop(context);
                                            setState(() {
                                              Navigator.pop(context);
                                              path = "";
                                            });
                                          },
                                          child: Container(
                                              width: 100,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.only(
                                                  top: 0,
                                                  bottom: 20,
                                                  left: 0,
                                                  right: 2.5),
                                              decoration: BoxDecoration(
                                                color: Color(0xffF8F8F8),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text("Cancel",
                                                  style: TextStyle(
                                                      color: Color(0xff003A5B),
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          "quicksand"))),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                             _uploadFile();
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(10),
                                                margin: EdgeInsets.only(
                                                    top: 0,
                                                    bottom: 20,
                                                    left: 2.5,
                                                    right: 0),
                                                decoration: BoxDecoration(
                                                  color: selectedColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Text("+ Add",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "quicksand"))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                      ],
                    ),
                  ),
                );
              }));
        });
  }
///////////////////////////////////// _showUploadDocDialog /////////////////////////////////////////



  //////////////////// File Picker ///////////////////////////////////
  Future initMultiFilePickUp() async {
    var filePicked = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf']
    );
    // var file = await ImagePicker.pickImage(
    //     source: ImageSource.gallery, imageQuality: 80);
    print(filePicked);
    path = filePicked.path;

    if (filePicked != null) {
      file = filePicked;
      print(file);
      print("file");
      
    }else{
      print("not selected");
    }

    setState(() {
      isDocItemPressed = false;
    });
  }
/////////////////////////// File Picker End /////////////////////
  
  /////////////////////// Upload File //////////////////
  
  Future<void> _uploadFile() async {

    setState(() {
      isFileUploading = true;
    });

   // print(path);
   // print(file);

    _getToken() async {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        print(localStorage.getString('token'));
        return localStorage.getString('token');       
    }
     // open a bytestream
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead())); 
      // get file length
      var length = await file.length();
      // string to uri
      var uri = Uri.parse( CallApi().fileCallurl+"upload_file");
      // create multipart request
      var request = new http.MultipartRequest("POST", uri);
      // multipart that takes file
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: "tt.txt");
      // add file to multipart
      request.headers['authorization'] = 'Bearer ' + await _getToken();
      request.files.add(multipartFile);
      // send
      var response = await request.send();
      print(response.statusCode);

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        //print(value); 
        final body = json.decode(value);
        print(body);
      //  print(body['success']);
      //    if(body['status'] == 'Token is Expired'){
      //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      // }
    //   else 
    if (response.statusCode != 200) {
      print("Something went wrong");
      setState(() {
          // isDocumentPressed = true;
          // isDocAvailable = true;
          isFileUploading = false;
      });
       Navigator.pop(context);
    } else if(response.statusCode == 200 && body['success'] == true) {
      print("Oise Upload");
      
      setState(() {
          uploadedDocData = body;
          // isDocumentPressed = true;
          // isDocAvailable = true;
          isFileUploading = false;
        });
     refresh();
     Navigator.pop(context);
      //print(uploadedDocData);
    }
    else{
      print("Oise na Upload");
      setState(() {
          // isDocumentPressed = true;
          // isDocAvailable = true;
          isFileUploading = false;
      });
       Navigator.pop(context);
    }


  });

    //  var url = Uri.parse("http://10.0.2.2:8000/api/upload_file");
    //   var request = new http.MultipartRequest("POST", url);
    //   Uint8List _bytesData =
    //       Base64Decoder().convert(path.toString().split(",").last);
    //   List<int> _selectedFile = _bytesData;

    //   request.files.add(http.MultipartFile.fromBytes('file', _selectedFile,
    //       contentType: new MediaType('application', 'octet-stream'),
    //       filename: "text_upload.txt"));

    //   request.send().then((response) {
    //     print("test");
    //     print(response.statusCode);
    //     if (response.statusCode == 200) print("Uploaded!");
    //   });

  }
  /////////////////////// Upload File //////////////////


  
  //////////////////////Refresh ////////////////////////
  void refresh() {
      setState(() {
      //  isDocumentPressed = false;
       legalData['url'] = uploadedDocData['pic'];
       legalData['url_type'] = uploadedDocData['type'];
       legalData['extension'] = uploadedDocData['extension'];
       store.dispatch(LegalInfoAction(store.state.legalInfoState));
        path = "";
       // isDocItemPressed = false;
      });
      print(legalData);
  }
  //////////////////////Refresh ////////////////////////
  


//////////////////////Save LigalDAta Start////////////////////////
   Future<void> _saveLegalData() async {
    setState(() {
      isLoading = true;
    });

    // if(fNameController.text == ""){
    //   isFNameBlank = true;
    //   isLoading = false;
    // }
    // else if(lNameController.text == ""){
    //   isLNameBlank = true;
    //   isLoading = false;
    // }
    // else if(isDatePicked != true){
    //   isDateBlank = true;
    //   isLoading = false;
    // }
    //  else {
    //   setState(() {
    //     isFNameBlank = false;
    //     isLNameBlank = false;
    //     isDateBlank = false;
    //   });

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userJson = localStorage.getString('user');
      var userData = json.decode(userJson);


      var data = {
                  "case_general_id": legalData['case_general_id'],
                  "user_id": userData['id'],
                  "legal_info": {
                          "right_status": status,
                          "date": DateFormat("yyyy-MM-dd").format(DateTime.parse("${DateFormat("dd-MM-yyyy").parse(dateToLegal)}")),
                          "note": noteController.text,
                          "url": legalData['url'],
                          "url_type": legalData['url_type'],
                          "extension": legalData['extension']
                      }
                };
               // DateFormat("yyyy-MM-dd").format(DateTime.parse(apiPlacementDate))

       // print(data);
       // _errorDialog("Something went wrong!");




      var res = await CallApi().postData(data, 'post_LegalInformation');
       var body = json.decode(res.body);
       print(body);
    
   if(body['status'] == 'Token is Expired'){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
      else if (res.statusCode != 200) {

     _errorDialog("Something went wrong!");
      setState(() {
      isLegalEdit = false;
      isLoading = false;
      });
    }
    else if (res.statusCode == 200) {

     // print(body['case_legal_details']);
      //if (body != null) {
       store.dispatch(LegalInfoAction(body['LegalInformation'])); // update data in store...
       
       //print(store.state.biographicalInfoState);
       if (!mounted) return;
       setState(() {
         legalData = store.state.legalInfoState;
       });
       print(legalData);
    
    dateToLegal = legalData['date'] == null ? "" : "${DateFormat("dd-MM-yyyy").format(DateTime.parse(legalData['date']))}";//"${DateFormat("dd-MM-yyyy").format(DateTime.now())}";
    noteController.text = legalData['note'] == null ? "" : legalData['note'];
    status = legalData['right_status'] == null ? "" : legalData['right_status'];
    

    setState(() {
      isLegalEdit = false;
      isLoading = false;
      });
    }
    else if (res.statusCode == 400) {
      _errorDialog("Something went wrong!");
      setState(() {
      noData = true;
      isLegalEdit = false;
      isLoading = false;
      });
    }
    
    else{
      _errorDialog("Something went wrong!");
      setState(() {
      isLegalEdit = false;
      isLoading = false;
      });
    }

  // setState(() {
  //   isLegalEdit = false;
  //   isLoading = false;
  // });
  
  }
/////////////////////Save Ligal End ////////////////////////




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
                      width: 55,
                      height: 55,
                      margin: EdgeInsets.all(15),
                      child: Image.asset("assets/image/accept_removal.png")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
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








