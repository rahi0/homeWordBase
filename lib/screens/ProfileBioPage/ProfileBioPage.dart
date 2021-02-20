import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/AddMemberPage/AddMemberPage.dart';
import 'package:homewardbase/screens/AddNewPage/AddNewPage.dart';
import 'package:homewardbase/screens/HomePage/HomePage.dart';
import 'package:homewardbase/screens/LogEntryPage/LogEntryPage.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/BiographicalProfilePage.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/ConnectedPeoplePage/ConnectedPeoplePage.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/ProfileChatPage/ProfileChatPage.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/ProfileEventPage/ProfileEventPage.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/ProfileLogPage/ProfileLogPage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class ProfileBioPage extends StatefulWidget {
  final caseId;
  ProfileBioPage(this.caseId);
  @override
  _ProfileBioPageState createState() => _ProfileBioPageState();
}

class _ProfileBioPageState extends State<ProfileBioPage> {
  bool isLoading = true;
  bool noData = false;
  var caseData;
  var caseDataforNotif;


  ///////////////// Image Pick /////////////
  File _selectedFile;
  bool _inProcess = false;
  bool isFileUploading = false;

  Widget getImageWidget() {
    if (_selectedFile != null) {
      return Container(
         decoration: BoxDecoration(
         // color: selectedColor,
           borderRadius: BorderRadius.circular(100),
           image: DecorationImage(
             image: FileImage(
               _selectedFile,
               ),
               fit: BoxFit.cover
              )
           ),
          height: 63,
         width: 63,
        // child: Image.file(
        //   _selectedFile,
        //   width: 63,
        //   height: 63,
        //   fit: BoxFit.cover,
        // ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
         // color: selectedColor,
           borderRadius: BorderRadius.circular(100)),
          height: 63,
         width: 63,
      );
    }
  }

  getImage(ImageSource source) async {
      this.setState((){
        _inProcess = true;
      });
      File image = await ImagePicker.pickImage(source: source);
      if(image != null){
        File cropped = await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatio: CropAspectRatio(
                ratioX: 1, ratioY: 1),
            compressQuality: 100,
            maxWidth: 700,
            maxHeight: 700,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
              toolbarColor: selectedColor,
              toolbarTitle: "Crop Image",
              statusBarColor: selectedColor,
              backgroundColor: Colors.white,
              activeControlsWidgetColor: selectedColor,
              toolbarWidgetColor: Colors.white
            )
        );

        this.setState((){
          _selectedFile = cropped;
          _inProcess = false;
        });
      } else {
        this.setState((){
          _inProcess = false;
        });
      }
  }
  ///////////////// Image Pick /////////////






  @override
  void initState() {
    super.initState();
    _getCaseData();
    //menuSelected = 0;
  }



  _getCaseData() async {

    setState(() {
      isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    //print(user);

   var data = {
      'case_general_id': widget.caseId,
      'user_id': user['id']
    };

    print(data);
    var res = await CallApi().postData(data, 'get_case_general_by_id');
   // var res = await CallApi().getData('get_case_general_by_id/${widget.caseId}');
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
    else if (res.statusCode == 200 && body['caseGeneral'] != null) {

      print(body['caseGeneral']);
      if (body != null) {
       store.dispatch(CaseInfoAction(body)); // update data in store...
      // print(body['caseGeneral']);
      // print(store.state.homepageCaseState);
       if (!mounted) return;
       setState(() {
      caseData = store.state.caseInfoState['caseGeneral'];
      caseDataforNotif = store.state.caseInfoState;
      isLoading = false;
      });
     }
      
    //  store.dispatch(CaseGeneralAction(body['caseGeneral'])); // update data in store...
      //add the fresh copy in local storage
      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString(key, json.encode(body));
    }
    else if (res.statusCode == 200 && body['caseGeneral'] == null) {

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

/////////////////////////////////
 Container notificationCon(){
   return Container(
                                                  padding: EdgeInsets.all(5),
                                                  margin: EdgeInsets.only( left: 25, bottom: 0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffFFBA0D),
                                                      border: Border.all(
                                                          width: 0.5,
                                                          color: Colors.white),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: Icon(Icons.notifications,
                                                      size: 12,
                                                      color: Colors.white),
                                                );
 }
 //////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator()
      ),
    ) : Scaffold(
      backgroundColor: Color(0xFFF8F8FA),
      floatingActionButton: menuSelected == 0 || menuSelected == 3
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => menuSelected == 1
                            ? AddMemberPage(2, caseData) ////////// the 4 will be caseData to call case member api
                            : menuSelected == 2
                                ? AddNewPage(widget.caseId)
                                : LogEntryPage(widget.caseId))); 
              },
              child: Icon(
                Icons.add,
                size: 30,
              ),
              backgroundColor: selectedColor,
            ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            NestedScrollView(
              physics: BouncingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
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
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 0),
                            child: PopupMenuButton<int>(
                              onSelected: (selection) {
                                print("selection");
                                print(selection);
                                if (selection == 1) {
                                  _showCaseDialog(1);
                                } else {
                                  _showCaseDialog(2);
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              icon: Icon(
                                Icons.more_horiz,
                                size: 25,
                                color: Colors.black,
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: Text(
                                    "Leave Case",
                                    style: TextStyle(
                                        color: Color(0xFF5A5B5C),
                                        fontFamily: 'quicksand',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Text(
                                    "Close Case",
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
                  ),
                  SliverToBoxAdapter(
                      child: Container(
                    color: Color(0xFFFFFFFF),
                    child: Column(
                      children: <Widget>[
                        Center(
                          //////////////////////////////// Case Profile Picture Start ///////////////////////////
                          child:
                          (_inProcess)?Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(15),
                                height: 63,
                                width: 63,
                                child: CircularProgressIndicator(),
                              ):
                           GestureDetector(
                            onTap: (){
                              cameraDialog();
                            },
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 0),
                                  child: caseData['profile_picture'] == null
                                      ? Container(
                                        margin: EdgeInsets.only(left: 0),
                                          decoration: BoxDecoration(
                                              color: selectedColor,
                                              borderRadius: BorderRadius.circular(100)),
                                          height: 63,
                                          width: 63,
                                          child: Center(
                                              child: Text(
                                            "${caseData['first_name'][0].toUpperCase()}${caseData['last_name'][0].toUpperCase()}",
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
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        image: DecorationImage(
                                            image:
                                                NetworkImage(
                                                  CallApi().fileShowlurl +"${caseData['profile_picture']}"),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(100)),
                                    height: 63,
                                    width: 63,
                                  ),
                                ),

                                getImageWidget(),

                                // (_inProcess)?Container(
                                //     color: Colors.white,
                                //     height: 63,
                                //     width: 63,
                                //     child: CircularProgressIndicator(),
                                //   ):Container()
                              ],
                            ),
                          ),
                        //////////////////////////////// Case Profile Picture End ///////////////////////////
                        ),

                        //////////////////////////////// Upload Picture Button Start ///////////////////////////
                        _selectedFile == null ? Container() :
                        GestureDetector(
                        onTap: () {
                          isFileUploading ? null : _uploadFile();
                        },
                        child: Container(
                          //width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                               // bottomLeft: Radius.circular(5),
                              ),
                              border: Border.all(color: Colors.white)),
                          child: Container(
                              width: 100,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(7),
                              margin: EdgeInsets.only(top: 15, bottom: 0, left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: selectedColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text( isFileUploading ? "Uploading..." : "Upload",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isFileUploading ?11 : 13,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "quicksand"))),
                        ),
                      ),
                        //////////////////////////////// Upload Picture Button End ///////////////////////////
                        
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(
                              //"amar kofal",
                              "${caseData['first_name']} ${caseData['last_name']}",
                              style: TextStyle(
                                  color: mainColor,
                                  fontFamily: 'quicksand',
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                             caseData['placements'] == null ? "${caseData['age']}" : //"${(DateTime.now().difference(DateTime.parse((caseData['birthday']))).inDays/365).floor().toString()} yo" :
                             caseData['placements']['placement_type'] == null ? "${caseData['age']} yo" :
                              "${caseData['placements']['placement_type']} placement - ${caseData['age']} yo",
                              style: TextStyle(
                                  color: Color(0xff7A98A9),
                                  fontFamily: 'quicksand',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  height: 42,
                                    width: 45,
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          //////////////////// Tab 1 ////////////////////
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                menuSelected = 0;
                                                caseDataforNotif['notification_in_information'] = "no";
                                                store.dispatch(CaseInfoAction(store.state.caseInfoState));
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: menuSelected == 0
                                                          ? mainColor
                                                          : selectedColor,
                                                      borderRadius:
                                                          BorderRadius.circular(100)),
                                                  height: 39,
                                                  width: 39,
                                                  child: Image.asset("assets/image/menu.png"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // caseDataforNotif['notification_in_information'] != "yes"
                                      //       ? Container()
                                      //       : Positioned(
                                      //         right: 0,
                                      //         child: notificationCon(),
                                      //       ),
                                    ],
                                  ),
                                ),
                                //////////////////// Tab 1 ////////////////////

                                //////////////////// Tab 2 ////////////////////
                                Container(
                                //  color: Colors.blue,
                                  height: 42,
                                  width: 45,
                                  child: GestureDetector(
                                    onTap: () {
                                          setState(() {
                                            menuSelected = 1;
                                            caseDataforNotif['notification_in_member'] = "no";
                                            store.dispatch(CaseInfoAction(store.state.caseInfoState));
                                          });
                                        },
                                    child: Stack(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: menuSelected == 1
                                                      ? mainColor
                                                      : selectedColor,
                                                  borderRadius:
                                                      BorderRadius.circular(100)),
                                              height: 39,
                                              width: 39,
                                              child: Image.asset(
                                                  "assets/image/user.png"),
                                            ),
                                          ],
                                        ),
                                       caseDataforNotif['notification_in_member'] != "yes"
                                            ? Container()
                                            : Positioned(
                                              right: 0,
                                              child: notificationCon(),
                                            ),
                                      ],
                                    ),
                                  ),
                                ),
                                //////////////////// Tab 2 ////////////////////


                                //////////////////// Tab 3 ////////////////////
                                Container(
                                //  color: Colors.red,
                                  height: 42,
                                  width: 45,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        menuSelected = 2;
                                        caseDataforNotif['notification_in_appointment'] = "no";
                                        store.dispatch(CaseInfoAction(store.state.caseInfoState));
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: menuSelected == 2
                                                      ? mainColor
                                                      : selectedColor,
                                                  borderRadius:
                                                      BorderRadius.circular(100)),
                                              height: 39,
                                              width: 39,
                                              child: Image.asset(
                                                  "assets/image/calendar.png"),
                                            ),
                                          ],
                                        ),
                                        caseDataforNotif['notification_in_appointment'] != "yes"
                                        ? Container()
                                        : Positioned(
                                          right: 0,
                                          child: notificationCon(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //////////////////// Tab 3 ////////////////////

                                //////////////////// Tab 4 ////////////////////
                                Container(
                                  //color: Colors.black,
                                  height: 42,
                                  width: 45,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        menuSelected = 3;
                                        caseDataforNotif['notification_in_chat'] = "no";
                                        store.dispatch(CaseInfoAction(store.state.caseInfoState));
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: menuSelected == 3
                                                      ? mainColor
                                                      : selectedColor,
                                                  borderRadius:
                                                      BorderRadius.circular(100)),
                                              height: 39,
                                              width: 39,
                                              child: Image.asset("assets/image/chat.png"),
                                            ),
                                          ],
                                        ),
                                       caseDataforNotif['notification_in_chat'] != "yes"
                                        ? Container()
                                        : Positioned(
                                          right: 0,
                                          child: notificationCon(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //////////////////// Tab 4 ////////////////////


                                //////////////////// Tab 5 ////////////////////
                                Container(
                                  //color: Colors.brown,
                                  height: 42,
                                  width: 45,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        menuSelected = 4;
                                        caseDataforNotif['notification_in_log'] = "no";
                                        store.dispatch(CaseInfoAction(store.state.caseInfoState));
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: menuSelected == 4
                                                      ? mainColor
                                                      : selectedColor,
                                                  borderRadius:
                                                      BorderRadius.circular(100)),
                                              height: 39,
                                              width: 39,
                                              child: Image.asset("assets/image/time.png"),
                                            ),
                                          ],
                                        ),
                                        caseDataforNotif['notification_in_log'] != "yes"
                                        ? Container()
                                        : Positioned(
                                          right: 0,
                                          child: notificationCon(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //////////////////// Tab 5 ////////////////////
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ];
              },
              body: menuSelected == 0
                  ? BiographicalProfilePage(widget.caseId)
                  : menuSelected == 1
                      ? ConnectedPeoplePage(widget.caseId)
                      : menuSelected == 2
                          ? ProfileEventPage(widget.caseId)
                          : menuSelected == 3
                              ? ProfileChatPage(widget.caseId)
                              : ProfileLogPage(widget.caseId),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _showCaseDialog(number) async {
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
                          ? "assets/image/accept_removal.png"
                          : "assets/image/accept_close.png")),
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
                        ? "Do you really want to leave this case? You will not be able to join again without requesting to join."
                        : "Do you really want to close this case? Each active case member will have up to 7 days to reject this action. ",
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
                            Navigator.pop(context);
                            if (number == 1) {
                              leaveCaseButton();
                              // _showDoneDialog(1);
                            } else {
                              closeCaseButton();
                              // _showDoneDialog(2);
                            }
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
                              child: Text(number == 1 ? "Leave" : "Close",
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

  Future<Null> _showDoneDialog(number) async {
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
                          ? "assets/image/accept_removal.png"
                          : "assets/image/accept_close.png")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    number == 1
                        ? "You have left the case"
                        : "Case pending close",
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
                        ? "You have successfully left the case and will no longer have access to it. If this was a mistake, you will have to request to join again or be invited."
                        : "This case is now pending close. All active case members will have up to 7 days to reject this action.",
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
                     Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => HomePage()));
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


////////////////////////////////// Leave Case ///////////////////////////
 void leaveCaseButton() async {
   setState(() {
     isLoading = true;
   });

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userJson = localStorage.getString('user');
      var userData = json.decode(userJson);

      var data = {
                  "case_general_id": widget.caseId,
                  "user_id": userData['id'],
                };
       // print(data);
      var res = await CallApi().postData(data, 'leave_case');
      var body = json.decode(res.body);

      if(res.statusCode == 400){
        _errorDialog("Something went wrong");
        setState(() {
          isLoading = false;
        });
      }
      else if(res.statusCode == 200){
           _showDoneDialog(1);
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
 ////////////////////////////////// Leave Case ///////////////////////////
 
 ////////////////////////////////// Close Case ///////////////////////////
 void closeCaseButton() async {
   setState(() {
     isLoading = true;
   });

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userJson = localStorage.getString('user');
      var userData = json.decode(userJson);

      var data = {
                  "case_general_id": widget.caseId,
                  "user_id": userData['id'],
                };
       // print(data);
      var res = await CallApi().postData(data, 'close_case');
      var body = json.decode(res.body);

      if(res.statusCode == 400){
        _errorDialog("Something went wrong");
        setState(() {
          isLoading = false;
        });
      }
      else if(res.statusCode == 200){
           _showDoneDialog(2);
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
 ////////////////////////////////// Close Case ///////////////////////////

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
////////////// Errort Dialog End /////////

////////////// Camera Dialog STart //////////
  Future<Null> cameraDialog() async {
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
                  padding: EdgeInsets.only(top: 5),
                  child: Column(
                    children: [
                      Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.keyboard_arrow_left, size: 27,)), ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                          width: 45,
                          height: 45,
                          margin: EdgeInsets.all(10),
                          child: Image.asset("assets/image/photograph.png",
                          color: Color(0xff003A5B),
                          )),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 15, top: 10),
                  child: Text(
                    "Upload Profile Picture",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff003A5B),
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                ),
                Row(
                  children: [
                    ///////////////// Camera //////////////////
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          getImage(ImageSource.camera);
                          Navigator.pop(context);
                        },
                        child: Container(
                          //width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                               // bottomRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                              border: Border.all(color: Colors.white)),
                          child: Container(
                              width: 100,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only( top: 0, bottom: 20, left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: selectedColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text("Camera",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "quicksand"))),
                        ),
                      ),
                    ),
                     ///////////////// Camera //////////////////
                     
                     ///////////////// Gallery //////////////////
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          getImage(ImageSource.gallery);
                          Navigator.pop(context);
                        },
                        child: Container(
                          //width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                               // bottomLeft: Radius.circular(5),
                              ),
                              border: Border.all(color: Colors.white)),
                          child: Container(
                              width: 100,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(top: 0, bottom: 20, left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: selectedColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text("Gallery",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "quicksand"))),
                        ),
                      ),
                    ),
                     ///////////////// Gallery //////////////////
                  ],
                ),
              ],
            ),
          );
        });
  }
////////////// Camera Dialog End //////////


// /////////////////////// Upload File //////////////////
  
  Future<void> _uploadFile() async {

    setState(() {
      isFileUploading = true;
    });


    _getToken() async {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        print(localStorage.getString('token'));
        return localStorage.getString('token');       
    }
    

    String fileName = _selectedFile.path.split('/').last;
      FormData dataa = FormData.fromMap({
          "profile_picture": await MultipartFile.fromFile(_selectedFile.path, filename: fileName,),
          'case_general_id': widget.caseId
      });

      Dio dio = new Dio();
      ///// Add header to dio
      dio.options.headers["Authorization"] = 'Bearer ' + await _getToken();
      //// parsing url
      var uri = Uri.parse( CallApi().fileCallurl+"case_profile_picture_upload");
      //// posting image
       dio.post("$uri", data: dataa)
       .then((response) {
         print(response);
           if(response.data['result']['status'] == 'Token is Expired'){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                  else 
                if (response.statusCode != 200) {
                  print("Oise na Upload");
                  _errorDialog("Something went wrong");
                  setState(() {
                     isFileUploading = false;
                  });
                } else if(response.statusCode == 200) {
                  print("Oise Upload");
                  print(response.data['result']['profile_picture']);
                  setState(() {
                    caseData['profile_picture'] = response.data['result']['profile_picture'];
                     isFileUploading = false;
                     _selectedFile = null;
                    });
                    store.dispatch(CaseInfoAction(store.state.caseInfoState)); // update data in store...
                }
                else{
                  print("Oise na Upload");
                  _errorDialog("Something went wrong");
                  setState(() {
                     isFileUploading = false;
                  });
                }

       });
       //.then((response) => print(response.statusCode))
      // .catchError((error) => print(error));
      
      // final body = json.decode(res.body);

    
  

   }
//   /////////////////////// Upload File //////////////////
}



// ////////////////////////////////////////
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   File _selectedFile;
//   bool _inProcess = false;

//   Widget getImageWidget() {
//     if (_selectedFile != null) {
//       return Image.file(
//         _selectedFile,
//         width: 250,
//         height: 250,
//         fit: BoxFit.cover,
//       );
//     } else {
//       return Image.asset(
//         "assets/placeholder.jpg",
//         width: 250,
//         height: 250,
//         fit: BoxFit.cover,
//       );
//     }
//   }

//   getImage(ImageSource source) async {
//       this.setState((){
//         _inProcess = true;
//       });
//       File image = await ImagePicker.pickImage(source: source);
//       if(image != null){
//         File cropped = await ImageCropper.cropImage(
//             sourcePath: image.path,
//             aspectRatio: CropAspectRatio(
//                 ratioX: 1, ratioY: 1),
//             compressQuality: 100,
//             maxWidth: 700,
//             maxHeight: 700,
//             compressFormat: ImageCompressFormat.jpg,
//             androidUiSettings: AndroidUiSettings(
//               toolbarColor: Colors.deepOrange,
//               toolbarTitle: "RPS Cropper",
//               statusBarColor: Colors.deepOrange.shade900,
//               backgroundColor: Colors.white,
//             )
//         );

//         this.setState((){
//           _selectedFile = cropped;
//           _inProcess = false;
//         });
//       } else {
//         this.setState((){
//           _inProcess = false;
//         });
//       }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               getImageWidget(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   MaterialButton(
//                       color: Colors.green,
//                       child: Text(
//                         "Camera",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       onPressed: () {
//                         getImage(ImageSource.camera);
//                       }),
//                   MaterialButton(
//                       color: Colors.deepOrange,
//                       child: Text(
//                         "Device",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       onPressed: () {
//                         getImage(ImageSource.gallery);
//                       })
//                 ],
//               )
//             ],
//           ),
//           (_inProcess)?Container(
//             color: Colors.white,
//             height: MediaQuery.of(context).size.height * 0.95,
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           ):Center()
//         ],
//       )
//     );
//   }
// }