import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_version/get_version.dart';
import 'package:flutter/services.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/Drawerr/Drawerr.dart';
import 'package:homewardbase/screens/HomePage/HomePage.dart';
import 'package:homewardbase/screens/NotificationPage/NotificationPage.dart';
import 'package:homewardbase/screens/SecurityPage/SecurityPage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _projectVersion = '', _projectCode = '';
  bool isLoading = true;
  bool isPressed = false;
  var userData;
  var roleIndex;
  List<DropdownMenuItem<String>> _dropDownRoleItems;
  List arrRole = [
    "Foster/adoptive parent",
    "Caseworker",
    "CASA/GAL",
    "Attorney ad litem",
    "Residential facility worker",
    "Other",
  ];
  String valRole = "", valState = "",roleType = "",fname,lname, org,city,
      state, email = "",mobile = "", homeNum = "", officeNum = "";
  bool emailCorrect = true,
      phoneCorrect = true,
      homePhoneCorrect = true,
      officePhoneCorrect = true,
      isOtherempty = false;
      bool isFName = true;
      bool isLName = true;
      bool isCity = true;
      bool isState = true;
      bool isPhone = true;
  TextEditingController fNameController;
  TextEditingController lNameController;
  TextEditingController orgController;
  TextEditingController cityController;
  TextEditingController stateController;
  TextEditingController optemailController;
  TextEditingController mobNumController;
  TextEditingController officeNumController;
  TextEditingController homeNumController;
  TextEditingController roleTypeController;

  @override
  initState() {
    super.initState();
    initPlatformState();
    initPlatformState();
    _getUser();
  }


  void _getUser() async {
    setState(() {
      isLoading = true;
      //currentDrawer = 'profile';
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    //print(user);
    setState(() {
     // userData = user;
      userData = store.state.userInfoState;
    });
    print(userData);

    fNameController = TextEditingController(text:'${userData['first_name'] == null ? '' : userData['first_name']}');
    lNameController = TextEditingController( text:'${userData['last_name'] == null ? '' : userData['last_name']}');
    orgController = TextEditingController(text:'${userData['organization'] == null ? '' : userData['organization']}');
    cityController = TextEditingController(text:'${userData['city'] == null ? '' : userData['city']}');
    stateController = TextEditingController(text:'${userData['state'] == null ? '' : userData['state']}');
    optemailController = TextEditingController(text:'${userData['optional_email'] == null ? userData['email'] : userData['optional_email']}');
    mobNumController = TextEditingController(text:'${userData['mobile'] == null ? '' : userData['mobile']}');
    homeNumController = TextEditingController(text:'${userData['home_phone'] == null ? '' : userData['home_phone']}');
    officeNumController = TextEditingController(text:'${userData['office_phone'] == null ? '' : userData['office_phone']}');
    roleTypeController = TextEditingController(text: userData['user_type'] == "Foster/adoptive parent" ? "" : userData['user_type'] == 'Caseworker' ? "" :
     userData['user_type'] =='CASA/GAL' ? '' :  userData['user_type'] =='Attorney ad litem' ? '' :
     userData['user_type'] == 'Residential facility worker' ? '' : "${userData['user_type']}");
    //valRole = userData['user_type'];
    //var search = arrRole.indexOf(userData['user_type']);
    // print("object");
    // print(search);
   // roleIndex = int.parse(search);
    _dropDownRoleItems = getDropDownRoleItems();
    valRole = userData['user_type'] == "Foster/adoptive parent" ? "Foster/adoptive parent" : userData['user_type'] == 'Caseworker' ? "Caseworker" :
     userData['user_type'] =='CASA/GAL' ? 'CASA/GAL' :  userData['user_type'] =='Attorney ad litem' ? 'Attorney ad litem' :
     userData['user_type'] == 'Residential facility worker' ? 'Residential facility worker' :
         _dropDownRoleItems[5].value ; //: _dropDownRoleItems[arrRole.indexOf(userData['user_type'])].value;
    
    setState(() {
      isLoading = false;
    });
  }

  List<DropdownMenuItem<String>> getDropDownRoleItems() {
    ////////drop down button
    List<DropdownMenuItem<String>> items = new List();
    for (String roleList in arrRole) {
      items.add(new DropdownMenuItem(
          value: roleList,
          child: new Text(
            roleList,
            textAlign: TextAlign.end,
            style: TextStyle(
                color: Color(0xff000000),
                fontFamily: 'quicksand',
                fontSize: 15,
                fontWeight: FontWeight.w400),
          )));
    }
    return items;
  }

  initPlatformState() async {
    String projectVersion;
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }

    String projectCode;
    try {
      projectCode = await GetVersion.projectCode;
    } on PlatformException {
      projectCode = 'Failed to get build number.';
    }

    if (!mounted) return;

    setState(() {
      _projectVersion = projectVersion;
      _projectCode = projectCode;
    });
  }

  ////////////////// Error Container Start //////////////
    Container errorCon(String title){
        return Container(
                      margin: EdgeInsets.only(
                          left: 22, right: 20, top: 5, bottom: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.error,
                            color: Colors.redAccent,
                            size: 14,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 3),
                              child: Text(
                                title,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: "quicksand",
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
      }
//////////////Error container end //////////////


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
          height: 90,
         width: 90,
        // child: Image.file(
        //   _selectedFile,
        //   width: 90,
        //   height: 90,
        //   fit: BoxFit.cover,
        // ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
         // color: selectedColor,
           borderRadius: BorderRadius.circular(100)),
          height: 90,
         width: 90,
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
  Widget build(BuildContext context) {
    return isLoading ? Container(
      child: Center(child: CircularProgressIndicator(),),
    ) : Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF8F8FA),
      //backgroundColor: selectedColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: selectedColor,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(right: 10, left: 5),
            child: Image.asset("assets/image/drawer.png"),
            height: 25,
          ),
        ),
      ),
      drawer: Drawerr(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              color: selectedColor,
              padding: EdgeInsets.only(bottom: 30),
              child: Column(
                children: <Widget>[
                  SizedBox(height:20),

                  ///////////////// Picture Button Start //////////////////////////
                  Center(
                    child: GestureDetector(
                      onTap: (){
                              cameraDialog();
                            },
                      child: Stack(
                        children: <Widget>[
                          userData['profile_picture'] == null ? 
                          Container(
                            height: 90,
                              width: 90,
                              color: selectedColor,
                          ) :
                          Container(
                            margin: EdgeInsets.only(left: 0),
                            child: Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                  color: selectedColor,
                                  image: DecorationImage(
                                      image:NetworkImage(
                                                  CallApi().fileShowlurl +"${userData['profile_picture']}"),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(100)),
                              height: 90,
                              width: 90,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 0),
                            child: Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(100)),
                              height: 90,
                              width: 90,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 0),
                            child: Container(
                              padding: EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0)),
                              height: 90,
                              width: 90,
                              child: Center(
                                  child:
                                      Image.asset("assets/image/photograph.png")),
                            ),
                          ),
                          getImageWidget(),
                        ],
                      ),
                    ),
                  ),
                   ///////////////// Picture Button End //////////////////////////
                   

                   //////////////////////////////// Upload Picture Button Start ///////////////////////////
                        _selectedFile == null ? Container() :
                        GestureDetector(
                        onTap: () {
                          isFileUploading ? null : _uploadFile();
                        },
                        child: Container(
                          //width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: selectedColor,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                               // bottomLeft: Radius.circular(5),
                              ),
                              border: Border.all(color: selectedColor)),
                          child: Container(
                              width: 100,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(7),
                              margin: EdgeInsets.only(top: 15, bottom: 0, left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text( isFileUploading ? "Uploading..." : "Upload",
                                  style: TextStyle(
                                      color: selectedColor,
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
                        "${userData['first_name']} ${userData['last_name']}",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'quicksand',
                            fontSize: 19,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "${userData['user_type']}",
                        style: TextStyle(
                            color: Color(0xffffffff),
                            fontFamily: 'quicksand',
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Color(0xFFF8F8FA),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.15),
                            borderRadius: BorderRadius.circular(5)),
                        margin: EdgeInsets.only(left: 20, right: 10, top: 20),
                        padding: EdgeInsets.only(top: 9, bottom: 5, right: 10),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    fname = value;
                                  });
                                },
                                controller: fNameController,
                                autofocus: false,
                                style: TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 15,
                                    fontFamily: 'quicksand',
                                    fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                                  hintText: "Enter First Name",
                                  hintStyle: TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 15,
                                      fontFamily: 'quicksand',
                                      fontWeight: FontWeight.w400),
                                  labelStyle: TextStyle(
                                      color: Color(0xff959595),
                                      fontSize: 15,
                                      fontFamily: 'quicksand',
                                      fontWeight: FontWeight.w400),
                                  labelText: "First Name",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.15),
                            borderRadius: BorderRadius.circular(5)),
                        margin: EdgeInsets.only(left: 10, right: 20, top: 20),
                        padding: EdgeInsets.only(top: 9, bottom: 5, right: 10),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    lname = value;
                                  });
                                },
                                controller: lNameController,
                                autofocus: false,
                                style: TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 15,
                                    fontFamily: 'quicksand',
                                    fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                                  hintText: "Enter Last Name",
                                  hintStyle: TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 15,
                                      fontFamily: 'quicksand',
                                      fontWeight: FontWeight.w400),
                                  labelStyle: TextStyle(
                                      color: Color(0xff959595),
                                      fontSize: 15,
                                      fontFamily: 'quicksand',
                                      fontWeight: FontWeight.w400),
                                  labelText: "Last Name",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
/////////////////////////////
                isFName == false || isLName == false ? errorCon(" First name & last name required") : Container(),
/////////////////////////////
            Container(
              color: Color(0xFFF8F8FA),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.15),
                    borderRadius: BorderRadius.circular(5)),
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 10, top: 5),
                      child: Text(
                        "Role",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff959595),
                            fontSize: 11.5,
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Container(
                      height: 33,
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: DropdownButtonHideUnderline(
                        child: Container(
                          child: DropdownButton(
                            //icon: Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            // iconDisabledColor:
                            //     Color(0xFF008990),
                            iconEnabledColor: Color(0xff003A5B),
                            // iconSize: 40,

                            //hint: Text('Select Situation'),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xff003A5B),
                            ),
                            value: valRole,
                            items: _dropDownRoleItems,
                            icon: Icon(
                              Icons.expand_more,
                              size: 15,
                              color: Color(0xff707070),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                valRole = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              color: Color(0xFFF8F8FA),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.15),
                    borderRadius: BorderRadius.circular(5)),
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    valRole != "Other"
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                roleType = value;
                                if (roleType == ""){
                              setState(() {
                                isOtherempty = true;
                              });
                                }else{
                                  isOtherempty = false;
                                }
                              });
                            },
                            controller: roleTypeController,
                            autofocus: false,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                color: Color(0xff003A5B).withOpacity(0.6),
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: "Enter Your Role",
                              hintStyle: TextStyle(
                                  color: Color(0xff003A5B).withOpacity(0.6),
                                  fontSize: 15,
                                  fontFamily: 'quicksand',
                                  fontWeight: FontWeight.w600),
                              labelStyle:TextStyle(
                            color: Color(0xff959595),
                            fontSize: 15,
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w400),
                              labelText: "Your Role",
                              contentPadding:
                                  EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    )
                    ),
                  ],
                ),
              ),
            ),
/////////////////////////////
                isOtherempty == true ? errorCon("Role type required") : Container(),
/////////////////////////////
            Container(
              color: Color(0xFFF8F8FA),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.15),
                      borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  padding: EdgeInsets.only(top: 15, bottom: 5, right: 10),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              org = value;
                            });
                          },
                          controller: orgController,
                          autofocus: false,
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            hintText: "Enter Organization",
                            hintStyle: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w400),
                            labelStyle: TextStyle(
                                color: Color(0xff959595),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w400),
                            labelText: "Organization",
                            contentPadding:
                                EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              color: Color(0xFFF8F8FA),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.15),
                      borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  padding: EdgeInsets.only(top: 15, bottom: 5, right: 10),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              city = value;
                            });
                          },
                          controller: cityController,
                          autofocus: false,
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            hintText: "Enter City",
                            hintStyle: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w400),
                            labelStyle: TextStyle(
                                color: Color(0xff959595),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w400),
                            labelText: "City",
                            contentPadding:
                                EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
/////////////////////////////
                isCity == false ? errorCon("City name required") : Container(),
/////////////////////////////
            Container(
              color: Color(0xFFF8F8FA),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.15),
                      borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  padding: EdgeInsets.only(top: 15, bottom: 5, right: 10),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              state = value;
                            });
                          },
                          controller: stateController,
                          autofocus: false,
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            hintText: "Enter State",
                            hintStyle: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w400),
                            labelStyle: TextStyle(
                                color: Color(0xff959595),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w400),
                            labelText: "State",
                            contentPadding:
                                EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              color: Color(0xFFF8F8FA),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.15),
                      borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  padding: EdgeInsets.only(top: 15, bottom: 5, right: 10),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              email = value;
                              if (email.contains('@') && email.contains(".")) {
                                emailCorrect = true;
                              } else {
                                emailCorrect = false;
                              }
                            });
                          },
                          controller: optemailController,
                          autofocus: false,
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            hintText: "Enter Email",
                            hintStyle: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w400),
                            labelStyle: TextStyle(
                                color: Color(0xff959595),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w400),
                            labelText: "Email",
                            contentPadding:
                                EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      email == ""
                          ? Container()
                          : Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: emailCorrect
                                      ? selectedColor
                                      : Colors.redAccent.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                emailCorrect ? Icons.done : Icons.close,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                    ],
                  )),
            ),
            Container(
              color: Color(0xFFF8F8FA),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.15),
                      borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  padding: EdgeInsets.only(top: 15, bottom: 5, right: 10),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              mobile = value;
                              if (!mobile.contains(new RegExp(r'[a-zA-Z]'))) {
                                phoneCorrect = true;
                              } else {
                                phoneCorrect = false;
                              }
                            });
                          },
                          controller: mobNumController,
                          autofocus: false,
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            hintText: "(---) --- ---",
                            hintStyle: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w400),
                            labelStyle: TextStyle(
                                color: Color(0xff959595),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w400),
                            labelText: "Mobile",
                            contentPadding:
                                EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      mobile == ""
                          ? Container()
                          : Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: phoneCorrect
                                      ? selectedColor
                                      : Colors.redAccent.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                phoneCorrect ? Icons.done : Icons.close,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                    ],
                  )),
            ),
/////////////////////////////
                isPhone == false ? errorCon(" Phone number is required") : Container(),
/////////////////////////////
            Container(
              color: Color(0xFFF8F8FA),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.15),
                      borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  padding: EdgeInsets.only(top: 15, bottom: 5, right: 10),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              officeNum = value;
                              if (!officeNum
                                  .contains(new RegExp(r'[a-zA-Z]'))) {
                                officePhoneCorrect = true;
                              } else {
                                officePhoneCorrect = false;
                              }
                            });
                          },
                          controller: officeNumController,
                          autofocus: false,
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            hintText: "(---) --- ---",
                            hintStyle: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w400),
                            labelStyle: TextStyle(
                                color: Color(0xff959595),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w400),
                            labelText: "Office",
                            contentPadding:
                                EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      officeNum == ""
                          ? Container()
                          : Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: officePhoneCorrect
                                      ? selectedColor
                                      : Colors.redAccent.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                officePhoneCorrect ? Icons.done : Icons.close,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                    ],
                  )),
            ),
            Container(
              color: Color(0xFFF8F8FA),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.15),
                      borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  padding: EdgeInsets.only(top: 15, bottom: 5, right: 10),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              homeNum = value;
                              if (!homeNum.contains(new RegExp(r'[a-zA-Z]'))) {
                                homePhoneCorrect = true;
                              } else {
                                homePhoneCorrect = false;
                              }
                            });
                          },
                          controller: homeNumController,
                          autofocus: false,
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            hintText: "(---) --- ---",
                            hintStyle: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w400),
                            labelStyle: TextStyle(
                                color: Color(0xff959595),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w400),
                            labelText: "Home",
                            contentPadding:
                                EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      homeNum == ""
                          ? Container()
                          : Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: homePhoneCorrect
                                      ? selectedColor
                                      : Colors.redAccent.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                homePhoneCorrect ? Icons.done : Icons.close,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                    ],
                  )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Color(0xFFF8F8FA),
        child: Wrap(
          children: <Widget>[
            Container(
              //height: 15,
              margin: EdgeInsets.only(left: 0, right: 0, top: 5),
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 0.1,
                //indent: 20,
                endIndent: 0,
              ),
            ),
            GestureDetector(
              onTap: isPressed ? null : updateButton,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  margin: EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: selectedColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Update",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: "quicksand",
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  void updateButton() async {
    setState(() {
      isPressed = true;
     // emailBlank = true;
    });

    if (fname == "") {
      setState(() {
         isFName = false;
         isPressed = false;
      });
    } else if(lname == "") {
      setState(() {
         isLName = false;
         isPressed = false;
      });
    } 
     else if(valRole == "Other" && roleTypeController.text == "") {
      setState(() {
         isOtherempty = true;
         isPressed = false;
      });
    } 
    else if(city == "") {
      setState(() {
         isCity = false;
         isPressed = false;
      });
    } 
    else {
      setState(() {
        isFName = true;
        isLName= true;
        isCity = true;
        isState = true;
        isPhone = true;
        isOtherempty = false;
      });

      var data = {
          'first_name': fNameController.text ,
          "last_name": lNameController.text,
          "email": userData['email'],
          "optional_email": optemailController.text,
          "organization": orgController.text,
          "city": cityController.text,
          "state": stateController.text,
          "mobile" : mobNumController.text,
          "home_phone": homeNumController.text,
          "office_phone": officeNumController.text,
          "profile_picture" : "image",
          "user_type" : valRole != "Other" ? valRole : roleTypeController.text,
        };
       // print(data);


      var res = await CallApi().postData(data, 'profile_update');
      var body = json.decode(res.body);
      print("body");
      print(body);

     if (res.statusCode != 200) {

      setState(() {
          isPressed = false;
        });

        print("Something went wrong");
    }
    else  if (res.statusCode == 200){

      var token = body['token'];
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.setString('user', json.encode(body['User']));
     // print(body['User']);
     store.state.userInfoState = body['User'];
      setState(() {
          isPressed = false;
        });
        store.dispatch(new UserInfoAction(store.state.userInfoState));

     Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => HomePage()));

    }

     
     }
  }

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
          //'case_general_id': widget.caseId
      });

      Dio dio = new Dio();
      ///// Add header to dio
      dio.options.headers["Authorization"] = 'Bearer ' + await _getToken();
      //// parsing url
      var uri = Uri.parse( CallApi().fileCallurl+"profile_picture_update");
      //// posting image
       dio.post("$uri", data: dataa)
       .then((response) async {
         
          //  if(response['status'] == 'Token is Expired'){
          //           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
          //         }
          //         else 
          
                if (response.statusCode != 200) {
                  print("Oise na Upload");
                  _errorDialog("Something went wrong");
                  setState(() {
                     isFileUploading = false;
                  });
                } else if(response.statusCode == 200) {
                  print("Oise Upload");
                  print(response.data);
                  SharedPreferences localStorage = await SharedPreferences.getInstance();
                  localStorage.remove('user');
                  localStorage.setString('user', json.encode(response.data['User']));
                // print(body['User']);
                setState(() {
                     isFileUploading = false;
                     _selectedFile = null;
                    });
                  store.dispatch(new UserInfoAction(response.data['User']));
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => MyProfilePage()));
                  
                }
                else{
                  print("Oise na Upload");
                  _errorDialog("Something went wrong");
                  setState(() {
                     isFileUploading = false;
                  });
                }

       })
       //.then((response) => print(response.statusCode))
       .catchError((error) => print(error));
      
      // final body = json.decode(res.body);

    
  

   }
//   /////////////////////// Upload File //////////////////



}
