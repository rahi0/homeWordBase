import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

//import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/FileShowingPage/FileShowingPage.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/BioCommonWidgets/BioCommonWidgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:homewardbase/screens/AddPlacementPage/AddPlacementPage.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:homewardbase/screens/ProfileBioPage/ProfileBioPage.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/addKinshipScreen.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/addSiblingsScreen.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/generalEthnicitySelectionScreen.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/generalLanguagesSelectionScreen.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/generalRaceSelectionScreen.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/placementAddPeopleScreen.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/placementTypeSelectionScreen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';

class BiographicalPage extends StatefulWidget {
  final caseId;
  BiographicalPage(this.caseId);
  @override
  _BiographicalPageState createState() => _BiographicalPageState();
}

class _BiographicalPageState extends State<BiographicalPage> {


  bool isLoading = true;
  bool noData = false;
  bool isByEmail = false;
  bool isFileUploading = false;
  var caseBiodata;
  var caseLog;
  var user;

  // List siblingsList = [];
   List kinshipList = [];

  List games = [];
  

  List documentList = [];
  var uploadedDocData;
  

  List emailListData = [];

  List arrPeople = [
    "Select People From List",
  ];

  //bool isEditPOpen = false;
  bool isEditOpen = false;
  bool isDocAvailable = false;
  bool isinterestPressed = false;
  bool isDocumentPressed = false;
  bool isDocItemPressed = false;

  String interests = "", doc = "", path = "", valPeople = "";
  TextEditingController interestsController = new TextEditingController();
  TextEditingController docController = new TextEditingController();
  // for general card
  TextEditingController placeOfBirthController = new TextEditingController();
  TextEditingController ssnController =
      new MaskedTextController(mask: '000-00-0000');

  // // for placement card
  TextEditingController placementNameController = new TextEditingController();
  TextEditingController placementAddressController =
      new TextEditingController();
  TextEditingController placementPhoneController =
      new MaskedTextController(mask: '(000) 000-0000');
  TextEditingController placementEmailController = new TextEditingController();

  List<DropdownMenuItem<String>> _dropDownPeopleItems;

  File file;

  List<DropdownMenuItem<String>> getDropDownPeopleItems() {
    ////////drop down button
    List<DropdownMenuItem<String>> items = new List();
    for (String peopleList in arrPeople) {
      items.add(new DropdownMenuItem(
          value: peopleList,
          child: new Text(
            peopleList,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: mainColor,
                fontFamily: 'quicksand',
                fontSize: 12,
                fontWeight: FontWeight.w500),
          )));
    }
    return items;
  }

  ///////////////////// Date Picker Essentials Start ///////////////////////
  String dateToGeneral = '';
  String dateToPlacement = '';
  DateTime selectedDateTo = DateTime.now();
  var dateTextController = new TextEditingController();
  String apiGenDate;
  String apiPlacementDate;

  Future<Null> _selectDateTo(BuildContext context, var dateFrom) async {
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
        dateFrom == 'general'
            ? apiGenDate = "${selectedDateTo}" : apiPlacementDate = "$selectedDateTo";
        dateFrom == 'general'
            ? dateToGeneral =
                "${DateFormat("MM-dd-yyyy").format(selectedDateTo)}"
            : dateToPlacement =
                "${DateFormat("MM-dd-yyyy").format(selectedDateTo)}";
        
      });
    }
  }
  ///////////////////// Date Picker Essentials End ///////////////////////

  //////////////////////// general text field container start /////////////////////////
  Container genTextFieldCon(
      TextEditingController controller, TextInputType tit, TextCapitalization capital) {
    return Container(
      margin: EdgeInsets.only(left: 7),
      child: TextField(
        readOnly: isEditOpen ? false : true,
        maxLines: null,
        keyboardType: tit,
        controller: controller,
        textCapitalization: capital,
        textAlign: TextAlign.right,
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
          focusedBorder: isEditOpen
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: selectedColor,
                  ),
                )
              : InputBorder.none,
          border: isEditOpen
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff777D82),
                  ),
                )
              : InputBorder.none,
        ),
      ),
    );
  }
  //////////////////////// general text field container end /////////////////////////
 
  @override
  void initState() {
    super.initState();
    _getBioData();
    //menuSelected = 0;
  }


  _getBioData() async {

    setState(() {
      isLoading = true;
      siblingsList = []; ///////////// have to fill it after getting response
      kinshipList = [];
          documentList = [];
          games = [];
          documentList = [];
          documentList = [];
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
    var res = await CallApi().postData(data, 'get_biographical_details');
    //var res = await CallApi().getData('get_biographical_details/${widget.caseId}');
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
    else if (res.statusCode == 200 && body['caseBiographical'] != null) {

      print(body['caseBiographical'].length);
      //if (body != null) {
       store.dispatch(BiographicalInfoAction(body['caseBiographical'])); // update data in store...
       store.dispatch(CommonLogAction(body['Logs'])); // update data in store...
      // print(body['caseBiographical']);
       //print(store.state.biographicalInfoState);
       if (!mounted) return;
       setState(() {
         caseBiodata = store.state.biographicalInfoState;
         caseLog = store.state.commonLogInfoState;
       });
     // }
    //   setState(() {
    //   caseBiodata = body['caseBiographical'];
    //  // isLoading = false;
    //   });

    //  store.dispatch(CaseGeneralAction(body['caseGeneral'])); // update data in store...
      //add the fresh copy in local storage
      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString(key, json.encode(body));
      // dateOfBirthController.text = '02-12-2015';
    dateToGeneral = caseBiodata['birthday'] != null ? "${DateFormat("MM-dd-yyyy").format(DateTime.parse(caseBiodata['birthday']))}"  : "${DateFormat("MM-dd-yyyy").format(DateTime.now())}";
    apiGenDate = caseBiodata['birthday'] != null ? caseBiodata['birthday']  : "${DateTime.now()}";
    dateToPlacement =  caseBiodata['placements'] == null ? '' : caseBiodata['placements']['created_at'] == null ? '' : "${DateFormat("MM-dd-yyyy").format(DateTime.parse(caseBiodata['placements']['created_at']))}" ; //"${DateFormat("dd-MM-yyyy").format(DateTime.now())}";
    apiPlacementDate =  caseBiodata['placements'] == null ? null : caseBiodata['placements']['created_at'] == null ? null : caseBiodata['placements']['created_at'] ; //"${DateFormat("dd-MM-yyyy").format(DateTime.now())}";
    placeOfBirthController.text = caseBiodata['place_of_birth'] != null ? caseBiodata['place_of_birth'] : "";
    ssnController.text =  caseBiodata['ssn'] != null ? caseBiodata['ssn'] : '';
    //genListLanguage =  caseBiodata['language'] != null ? caseBiodata['language'] : '';
    if(caseBiodata['language'].length  >= 1){
      for(var i = 0; i < caseBiodata['language'].length; i++){
      genListLanguage = [];
      genListLanguage.add(caseBiodata['language'][i]['language']);
    }
    }else{
      genListLanguage = [];
    }
    genRace =  caseBiodata['race'] != null ? caseBiodata['race'] : '';
    genEthnicity =  caseBiodata['ethnicity'] != null ? caseBiodata['ethnicity'] : '';
    games =  caseBiodata['activities'] != null ? caseBiodata['activities'] : [];
    games.add({"title": "add_people"});

    placementNameController.text = caseBiodata['placements'] == null ? '' : caseBiodata['placements']['placement_name'] == null ? '' : caseBiodata['placements']['placement_name'];
    placementAddressController.text = caseBiodata['placements'] == null ? '' : caseBiodata['placements']['address'] == null ? '' : caseBiodata['placements']['address'];
    placementPhoneController.text = caseBiodata['placements'] == null ? '' : caseBiodata['placements']['phone_number'] == null ? '' : caseBiodata['placements']['phone_number'];
    placementEmailController.text = caseBiodata['placements'] == null ? '' : caseBiodata['placements']['email'] == null ? '' : caseBiodata['placements']['email'];
    placementType = caseBiodata['placements'] == null ? '' : caseBiodata['placements']['placement_type'] == null ? '' : caseBiodata['placements']['placement_type'];
    
    for (var x in caseBiodata['siblings']) {
        siblingsList.add({
          'id' : x['id'],
          'name' : x['name'],
          'address': x['address'],
          'phone_number': x['phone_number'],
          'email': x['email'],
          'gender': x['gender'],
          'relation': x['relation'],
          'note': x['note'],
          'status': x['status'],
          'placement_type' : x['placement_type'],
          'contact_name' : x['contact_name'],
          'birthday': x['birthday']
          });
      }
      print(siblingsList);
    //  // return siblingsList;

    for (var y in caseBiodata['kinships']) {
        kinshipList.add({
          'id' : y['id'],
          'name' : y['name'],
          'address': y['address'],
          'phone_number': y['phone_number'],
          'email': y['email'],
          'relation': y['relation'],
          'note': y['note'],
          'contact_name': y['contact_name'],
          });
      }
      print(kinshipList);
    //  // return kinshipList;


    for (var z in caseBiodata['case_documents']) {
        documentList.add({
          'id': z['id'],
          'doc_type': z['doc_type'],
          'doc_name': z['doc_name'],
          'url': z['url'],
          'url_type': z['url_type'],
          'extension':z['extension'],
          });
      }
      print(documentList);
    //  // return kinshipList;

    
    _dropDownPeopleItems = getDropDownPeopleItems();
    valPeople = _dropDownPeopleItems[0].value;

    setState(() {
      //caseBiodata = body['caseBiographical'][0];
      isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator()
      ),
    ) :
    SingleChildScrollView(
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
                      "Biographical",
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
                        isEditOpen == false
                            ? Container()
                            :
                            ////////////////////// cancel button start //////////////////////
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isEditOpen = false;
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
                        ////////////////////// cancel button end //////////////////////

                        ////////////////////// save/edit button start //////////////////////
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isEditOpen) {
                                 _saveBioData();
                                //isEditOpen = false;
                              } else {
                                isEditOpen = true;
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
                                  isEditOpen == false
                                      ? Icon(Icons.edit,
                                          size: 11, color: Colors.white)
                                      : Container(),
                                  Text(
                                    isEditOpen == false ? " Edit" : "Save",
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
                        ////////////////////// save/edit button end //////////////////////
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
                        "General",
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
                              "Date of birth",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff777D82),
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: !isEditOpen
                                  ? null
                                  : () {
                                      _selectDateTo(context, 'general');
                                      // print(dateTo);
                                    },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                margin: EdgeInsets.only(left: 7),
                                padding: EdgeInsets.only(
                                  bottom: 5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: isEditOpen
                                        ? BorderSide(
                                            width: 0.7,
                                            color: Color(0xff777D82),
                                          )
                                        : BorderSide.none,
                                  ),
                                ),
                                child: Text(
                                  // "02-12-2015",
                                  dateToGeneral,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Color(0xff777D82),
                                    fontSize: 14,
                                    fontFamily: "quicksand",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // genTextFieldCon(dateOfBirthController,
                              //     TextInputType.datetime),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              "Place of birth",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff777D82),
                                  fontSize: 14,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          isEditOpen == false ? Text(
                            placeOfBirthController.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff777D82),
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w500),
                          ) :
                          Flexible(
                            child: genTextFieldCon(
                                placeOfBirthController, TextInputType.text, TextCapitalization.words),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              "Languages",
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
                              onTap: !isEditOpen
                                  ? null
                                  : () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GeneralLanguagesSelectionScreen())).then((value) {
                                                    setState(() {
                                                        // refresh state
                                                      });
                                                    }); 
                                    },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                margin: EdgeInsets.only(left: 7),
                                padding: EdgeInsets.only(
                                  bottom: 5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: isEditOpen
                                        ? BorderSide(
                                            width: 0.7,
                                            color: Color(0xff777D82),
                                          )
                                        : BorderSide.none,
                                  ),
                                ),
                                child: Text(
                                  genListLanguage.toString().replaceAll('[', '').replaceAll(']', ''),
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
                          // Flexible(
                          //   child: genTextFieldCon(
                          //       languagesController, TextInputType.text),
                          // ),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              "Race",
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
                              onTap: !isEditOpen
                                  ? null
                                  : () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GeneralRaceSelectionScreen())).then((value) {
                                                    setState(() {
                                                        // refresh state
                                                      });
                                                    }); 
                                    },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                margin: EdgeInsets.only(left: 7),
                                padding: EdgeInsets.only(
                                  bottom: 5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: isEditOpen
                                        ? BorderSide(
                                            width: 0.7,
                                            color: Color(0xff777D82),
                                          )
                                        : BorderSide.none,
                                  ),
                                ),
                                child: Text(
                                  genRace,
                                  //genlistRace.toString().replaceAll('[', '').replaceAll(']', ''),
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
                          // Flexible(
                          //   child: genTextFieldCon(
                          //       raceController, TextInputType.text),
                          // ),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              "Ethnicity",
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
                              onTap: !isEditOpen
                                  ? null
                                  : () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GeneralEthnicitySelectionScreen())).then((value) {
                                                    setState(() {
                                                        // refresh state
                                                      });
                                                    }); 
                                    },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                margin: EdgeInsets.only(left: 7),
                                padding: EdgeInsets.only(
                                  bottom: 5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: isEditOpen
                                        ? BorderSide(
                                            width: 0.7,
                                            color: Color(0xff777D82),
                                          )
                                        : BorderSide.none,
                                  ),
                                ),
                                child: Text(
                                  genEthnicity,
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
                          // Flexible(
                          //   child: genTextFieldCon(
                          //       ethnicityController, TextInputType.text),
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 0, right: 0, top: 15, bottom: 15),
                      child: Divider(
                        color: Colors.black,
                        height: 2,
                        thickness: 0.1,
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
                              "SSN",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff777D82),
                                  fontSize: 14,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                         isEditOpen == false ? Text(
                            ssnController.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff777D82),
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w500),
                          ) :
                          Flexible(
                            child: genTextFieldCon(ssnController,
                                TextInputType.numberWithOptions(), TextCapitalization.none),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Activities & Interests",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff777D82),
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                      child: Wrap(
                          children: List.generate(games.length, (index) {
                        return games[index]['title'] == "add_people"
                            ? isEditOpen == false
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      _showAddInterestsDialog();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 17,
                                            right: 17),
                                        margin: EdgeInsets.only(top: 0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: selectedColor)),
                                        child: Wrap(
                                          children: <Widget>[
                                            Text(
                                              "+ Add",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: selectedColor,
                                                  fontSize: 12,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                            : GestureDetector(
                                onTap: isEditOpen == false ? null :() {
                                  setState(() {
                                    games.removeAt(index);
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 17, right: 17),
                                    margin: EdgeInsets.only(top: 0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Color(0xfff1f1f1))),
                                    child: isEditOpen == false
                                        ? Text(
                                            "${games[index]['title']}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xff333333),
                                                fontSize: 12,
                                                fontFamily: "quicksand",
                                                fontWeight: FontWeight.w400),
                                          )
                                        : Wrap(
                                            children: <Widget>[
                                              Text(
                                                "${games[index]['title']}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color(0xff333333),
                                                    fontSize: 12,
                                                    fontFamily: "quicksand",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child:
                                                    Icon(Icons.close, size: 10),
                                              )
                                            ],
                                          ),
                                  ),
                                ),
                              );
                      })),
                    ),
                  ],
                ),
              ),
            ),


             ///////////////////////// Upload Documant Start ////////////////////////////
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
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
                          "Documents",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 14,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        isEditOpen == false
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  _showUploadDocDialog();  
                                },
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
                      ],
                    ),
                  ),
                  Container(
                    //height: 15,
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 15),
                    child: Divider(
                      color: Colors.black,
                      height: 2,
                      thickness: 0.1,
                      //indent: 20,
                      endIndent: 0,
                    ),
                  ),
                  caseBiodata['case_documents'].length != 0
                      ? Container(
                          margin: EdgeInsets.only(top: 0),
                          child: Column(
                              children:
                                  List.generate(caseBiodata['case_documents'].length, (index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  top: index == 0 ? 0 : 20),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    width: 40,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color:
                                            Color(0xffF5FDFA).withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Image.asset(
                                      caseBiodata['case_documents'][index]['doc_type'] == "security"
                                        ? "assets/image/birth_certificate.png"
                                        : caseBiodata['case_documents'][index]['doc_type'] == "birth"
                                        ? "assets/image/security_card.png"
                                        : "assets/image/google-docs.png"),
                                  ),

                                  ///////////////////////// view Button Start /////////////////////
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        caseBiodata['case_documents'][index]['extension'] == "pdf" ?
                                        _launchURL(caseBiodata['case_documents'][index]['url']) :
                                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => FullScreenImage(caseBiodata['case_documents'][index]['url'])));
                                      },
                                      child: Container(
                                        //color: Colors.red,
                                        margin: EdgeInsets.only(left: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                "${caseBiodata['case_documents'][index]['doc_name']}.${caseBiodata['case_documents'][index]['extension']}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xff060606),
                                                    fontSize: 14,
                                                    fontFamily: 'quicksand',
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(
                                                "View",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    color: Color(0xff003A5B),
                                                    fontSize: 11,
                                                    fontFamily: 'quicksand',
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  ///////////////////////// view Button End /////////////////////
                                  isEditOpen == false
                                      ? Container()
                                      : GestureDetector(
                                        onTap: (){
                                          removeDocument(caseBiodata['case_documents'][index], index);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(right: 0),
                                            child: Icon(
                                                                Icons.delete,
                                                                size: 18,
                                                                color: Color(
                                                                    0xffF9423A),
                                                              ),
                                            // Text(
                                            //   "trash",
                                            //   maxLines: 1,
                                            //   overflow: TextOverflow.ellipsis,
                                            //   textAlign: TextAlign.center,
                                            //   style: TextStyle(
                                            //       color: Color(0xffF9423A),
                                            //       fontSize: 12,
                                            //       fontFamily: "quicksand",
                                            //       fontWeight: FontWeight.w400),
                                            // ),
                                          ),
                                      ),
                                ],
                              ),
                            );
                          })),
                        )
                      : Container(
                          child: Column(
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
                              isEditOpen == false ? Container() :
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

            ///////////////////////// Upload Documant  End ////////////////////////////
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Placement",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: mainColor,
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w500),
                          ),
                          isEditOpen == false
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    _showPlacementDialog();
                                  },
                                  child: Container(
                                    height: 19,
                                    width: 19,
                                    child: Image.asset("assets/image/move.png"),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              "Placement Name",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff777D82),
                                  fontSize: 14,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          isEditOpen == false ? Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 50),
                              child: Text(
                                placementNameController.text,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Color(0xff23272A),
                                    fontSize: 14,
                                    fontFamily: "quicksand",
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ) :
                          Flexible(
                            child: genTextFieldCon(
                                placementNameController, TextInputType.text, TextCapitalization.sentences),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              "Address",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff777D82),
                                  fontSize: 14,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          isEditOpen == false ? Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 50),
                              child: Text(
                                placementAddressController.text,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Color(0xff23272A),
                                    fontSize: 14,
                                    fontFamily: "quicksand",
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ) :
                          Flexible(
                            child: genTextFieldCon(
                                placementAddressController, TextInputType.text, TextCapitalization.words),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              "Placement Type",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff777D82),
                                  fontSize: 14,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: !isEditOpen
                                  ? null
                                  : () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlacementTypeSelectionScreen())).then((value) {
                                                    setState(() {
                                                      ////refresh state
                                                    });
                                                  });
                                    },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                margin: EdgeInsets.only(left: 7),
                                padding: EdgeInsets.only(
                                  bottom: 5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: isEditOpen
                                        ? BorderSide(
                                            width: 0.7,
                                            color: Color(0xff777D82),
                                          )
                                        : BorderSide.none,
                                  ),
                                ),
                                child: Text(
                                  placementType,
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              "Date Placed",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff777D82),
                                  fontSize: 14,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: !isEditOpen
                                  ? null
                                  : () {
                                      _selectDateTo(context, 'placement');
                                      // print(dateTo);
                                    },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                margin: EdgeInsets.only(left: 7),
                                padding: EdgeInsets.only(
                                  bottom: 5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: isEditOpen
                                        ? BorderSide(
                                            width: 0.7,
                                            color: Color(0xff777D82),
                                          )
                                        : BorderSide.none,
                                  ),
                                ),
                                child: Text(
                                  // "02-12-2015",
                                  dateToPlacement,
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Days at Placement",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff777D82),
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w400),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 50),
                              child: Text(
                                //"${DateTime.now().difference(DateTime.parse((DateFormat("yyyy-MM-dd").format(DateFormat("yyyy-MM-dd").parse(dateToPlacement))))).inDays}",
                                "${DateTime.now().difference(DateFormat("MM-dd-yyyy").parse(dateToPlacement)).inDays}",
                               // "126",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Color(0xff23272A),
                                    fontSize: 14,
                                    fontFamily: "quicksand",
                                    fontWeight: FontWeight.w400),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              "Placement Phone Number",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff777D82),
                                  fontSize: 14,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          isEditOpen == false ? Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 50),
                              child: Text(
                                placementPhoneController.text,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Color(0xff23272A),
                                    fontSize: 14,
                                    fontFamily: "quicksand",
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ) :
                          Flexible(
                            child: genTextFieldCon(
                                placementPhoneController, TextInputType.phone, TextCapitalization.none),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              "Placement Email",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff777D82),
                                  fontSize: 14,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          isEditOpen == false ? Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 50),
                              child: Text(
                               placementEmailController.text,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Color(0xff23272A),
                                    fontSize: 14,
                                    fontFamily: "quicksand",
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ) :
                          Flexible(
                            child: genTextFieldCon(placementEmailController,
                                TextInputType.emailAddress, TextCapitalization.none),
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


                    /////////////////////// People at placement //////////////////////
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "People at Placement",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff777D82),
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w500),
                          ),
                          isEditOpen == false
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    _showAddPeopleDialog();
                                  },
                                  child: Container(
                                    child: Text(
                                      "+ Add People",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: selectedColor,
                                          fontSize: 11,
                                          fontFamily: "quicksand",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),

                    
                    Container(
                      //height: 15,
                      margin: EdgeInsets.only(
                          left: 0, right: 0, top: 15, bottom: 0),
                      child: Divider(
                        color: Colors.black,
                        height: 2,
                        thickness: 0.1,
                        //indent: 20,
                        endIndent: 0,
                      ),
                    ),
                    caseBiodata['people_of_placements'].length == 0
                        ? Container(
                            margin: EdgeInsets.only(top: 0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  width: 44,
                                  decoration: BoxDecoration(
                                      color: Color(0xffF5FDFA).withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Image.asset("assets/image/idea.png"),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Text(
                                    "No people are associated with this case.",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        color: Color(0xff707070),
                                        fontSize: 14,
                                        fontFamily: 'quicksand',
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),

                                isEditOpen == false ? Container() : GestureDetector(
                                  onTap: () {
                                    _showAddPeopleDialog();
                                    // setState(() {
                                    //   isPlacementAvailable = true;
                                    // });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 70,
                                        right: 70),
                                    margin: EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border:
                                            Border.all(color: selectedColor)),
                                    child: Text(
                                      "Add",
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
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                                children: List.generate(caseBiodata['people_of_placements'].length,
                                    (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    //checkPotentialList.add(index);
                                  });
                                },
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding:
                                            EdgeInsets.only(left: 0, right: 5),
                                        child: Row(
                                          children: <Widget>[
                                            caseBiodata['people_of_placements'][index]['people_info']['profile_picture'] == null
                                              ? Container(
                                                margin: EdgeInsets.only(left: 20),
                                                  decoration: BoxDecoration(
                                                      color: selectedColor,
                                                      borderRadius: BorderRadius.circular(100)),
                                                  height: 45,
                                                  width: 45,
                                                  child: Center(
                                                      child: Text(
                                                    "${caseBiodata['people_of_placements'][index]['people_info']['first_name'][0].toUpperCase()}${caseBiodata['people_of_placements'][index]['people_info']['last_name'][0].toUpperCase()}",
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
                                                          "assets/image/pm2.png"),
                                                      fit: BoxFit.cover
                                                      ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              height: 45,
                                              width: 45,
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:20),
                                                              child: Text(
                                                                "${caseBiodata['people_of_placements'][index]['people_info']['first_name']} ${caseBiodata['people_of_placements'][index]['people_info']['last_name']}",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color:
                                                                        mainColor,
                                                                    fontSize:
                                                                        15,
                                                                    fontFamily:
                                                                        "quicksand",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 5,
                                                                    right: 30),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5,
                                                                    bottom: 5,
                                                                    left: 10,
                                                                    right: 10),
                                                            decoration: BoxDecoration(
                                                                color: Color(
                                                                        0xffDCF7EE)
                                                                    .withOpacity(
                                                                        0.5),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Text(
                                                              "${caseBiodata['people_of_placements'][index]['people_info']['user_type']}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color:
                                                                      selectedColor,
                                                                  fontSize: 9,
                                                                  fontFamily:
                                                                      "quicksand",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      caseBiodata['people_of_placements'][index]['people_info']['organization'] == null ? "" :
                                                      "${caseBiodata['people_of_placements'][index]['people_info']['organization']}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: mainColor,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              "quicksand",
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            isEditOpen == false
                                                ? Container()
                                                : GestureDetector(
                                                  onTap: (){
                                                    removePlacementPeople(caseBiodata['people_of_placements'][index], index); 
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
                                      ),
                                      caseBiodata['people_of_placements'].length - 1 == index
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
                            })),
                          ),
                  ],
                ),
              ),
            ),
            ///////////////////// People at placement end////////////////////
            
///////////////////////////////////// Sibling Start ///////////////////////////////////
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              margin: EdgeInsets.only(left: 20, right: 20),
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
                          "Siblings",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 14,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        isEditOpen == false
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddSiblingScreen()));
                                },
                                child: Text(
                                  "+ Add Siblings",
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
                        EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 15),
                    child: Divider(
                      color: Colors.black,
                      height: 2,
                      thickness: 0.1,
                      //indent: 20,
                      endIndent: 0,
                    ),
                  ),
                  caseBiodata['siblings'].length != 0
                      ? Container(
                          margin: EdgeInsets.only(top: 0),
                          child: Column(
                              children: List.generate(caseBiodata['siblings'].length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  //checkPotentialList.add(index);
                                });
                              },
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.only(left: 0, right: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Text(
                                                            "${caseBiodata['siblings'][index]['name']}",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color:
                                                                    mainColor,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    "quicksand",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  right: 30),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  bottom: 5,
                                                                  left: 10,
                                                                  right: 10),
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                      0xffDCF7EE)
                                                                  .withOpacity(
                                                                      0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Text(
                                                           "${caseBiodata['siblings'][index]['gender']}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color:
                                                                    selectedColor,
                                                                fontSize: 9,
                                                                fontFamily:
                                                                    "quicksand",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    "${caseBiodata['siblings'][index]['placement_type']} - ${(DateTime.now().difference(DateTime.parse((caseBiodata['siblings'][index]['birthday']))).inDays/365).floor().toString()} yo",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: mainColor,
                                                        fontSize: 12,
                                                        fontFamily: "quicksand",
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          isEditOpen == false
                                              ? Container()
                                              : 
                                              ////////////////// remove Sibling Button /////////
                                              GestureDetector(
                                                onTap: (){
                                                  removeSibling(caseBiodata['siblings'][index], index);
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

                                                 ////////////////// remove Sibling Button /////////
                                        ],
                                      ),
                                    ),
                                    Container(
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
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              "Contact Name",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff777D82),
                                                  fontSize: 14,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),

                                          isEditOpen ?
                                              Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(left: 7),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                           if(value == ""){
                                                              setState(() {
                                                              caseBiodata['siblings'][index]['contact_name'] = siblingsList[index]['contact_name'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                              caseBiodata['siblings'][index]['contact_name'] = value;
                                                          });
                                                            }
                                                        },
                                                      readOnly: isEditOpen ? false : true,
                                                      maxLines: null,
                                                      keyboardType: TextInputType.text,
                                                     // controller: siblingContactNameController,
                                                      textAlign: TextAlign.right,
                                                      textCapitalization: TextCapitalization.words,
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
                                                        hintText: caseBiodata['siblings'][index]['contact_name'] == null ? "" : "${caseBiodata['siblings'][index]['contact_name']}",
                                                        focusedBorder: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: selectedColor,
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                        border: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Color(0xff777D82),
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                              ) : 
                                          Expanded(
                                            child:Container(
                                              margin: EdgeInsets.only(left: 50),
                                              child: Text(
                                                caseBiodata['siblings'][index]['contact_name'] == null ? "--" : "${caseBiodata['siblings'][index]['contact_name']}",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Color(0xff23272A),
                                                    fontSize: 14,
                                                    fontFamily: "quicksand",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
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
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              "Address",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff777D82),
                                                  fontSize: 14,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          isEditOpen ?
                                              Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(left: 7),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                           if(value == ""){
                                                              setState(() {
                                                              caseBiodata['siblings'][index]['address'] = siblingsList[index]['address'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                              caseBiodata['siblings'][index]['address'] = value;
                                                          });
                                                            }
                                                        },
                                                      readOnly: isEditOpen ? false : true,
                                                      maxLines: null,
                                                      keyboardType: TextInputType.text,
                                                      textCapitalization: TextCapitalization.words,
                                                     // controller: siblingContactNameController,
                                                      textAlign: TextAlign.right,
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
                                                        hintText: caseBiodata['siblings'][index]['address'] == null ? "" : "${caseBiodata['siblings'][index]['address']}",
                                                        focusedBorder: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: selectedColor,
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                        border: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Color(0xff777D82),
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                              ) :  Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 50),
                                              child: Text(
                                                caseBiodata['siblings'][index]['address'] == null ? "--" : "${caseBiodata['siblings'][index]['address']}",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Color(0xff23272A),
                                                    fontSize: 14,
                                                    fontFamily: "quicksand",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
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
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              "Phone Number",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff777D82),
                                                  fontSize: 14,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),

                                          isEditOpen ?
                                              Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(left: 7),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                           if(value == ""){
                                                              setState(() {
                                                              caseBiodata['siblings'][index]['phone_number'] = siblingsList[index]['phone_number'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                              caseBiodata['siblings'][index]['phone_number'] = value;
                                                          });
                                                            }
                                                        },
                                                      readOnly: isEditOpen ? false : true,
                                                      maxLines: null,
                                                      keyboardType: TextInputType.number,
                                                     // controller: siblingContactNameController,
                                                      textAlign: TextAlign.right,
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
                                                        hintText: caseBiodata['siblings'][index]['phone_number'] == null ? "" : "${caseBiodata['siblings'][index]['phone_number']}",
                                                        focusedBorder: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: selectedColor,
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                        border: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Color(0xff777D82),
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                              ) :
                                          Flexible(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 50),
                                              child: Text(
                                                caseBiodata['siblings'][index]['phone_number'] == null ? "--" : "${caseBiodata['siblings'][index]['phone_number']}",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Color(0xff23272A),
                                                    fontSize: 14,
                                                    fontFamily: "quicksand",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
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
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              "Email",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff777D82),
                                                  fontSize: 14,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),

                                          isEditOpen ?
                                              Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(left: 7),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                           if(value == ""){
                                                              setState(() {
                                                              caseBiodata['siblings'][index]['email'] = siblingsList[index]['email'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                              caseBiodata['siblings'][index]['email'] = value;
                                                          });
                                                            }
                                                        },
                                                      readOnly: isEditOpen ? false : true,
                                                      maxLines: null,
                                                      keyboardType: TextInputType.emailAddress,
                                                      textCapitalization: TextCapitalization.none,
                                                     // controller: siblingContactNameController,
                                                      textAlign: TextAlign.right,
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
                                                        hintText: caseBiodata['siblings'][index]['email'] == null ? "" : "${caseBiodata['siblings'][index]['email']}",
                                                        focusedBorder: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: selectedColor,
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                        border: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Color(0xff777D82),
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                              ) :
                                          Flexible(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 50),
                                              child: Text(
                                                caseBiodata['siblings'][index]['email'] == null ? "--" : "${caseBiodata['siblings'][index]['email']}",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Color(0xff23272A),
                                                    fontSize: 14,
                                                    fontFamily: "quicksand",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
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
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              "Notes",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff777D82),
                                                  fontSize: 14,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),

                                          isEditOpen ?
                                              Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(left: 7),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                           if(value == ""){
                                                              setState(() {
                                                              caseBiodata['siblings'][index]['note'] = siblingsList[index]['note'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                              caseBiodata['siblings'][index]['note'] = value;
                                                          });
                                                            }
                                                        },
                                                      readOnly: isEditOpen ? false : true,
                                                      maxLines: null,
                                                      keyboardType: TextInputType.text,
                                                      textCapitalization: TextCapitalization.sentences,
                                                     // controller: siblingContactNameController,
                                                      textAlign: TextAlign.right,
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
                                                        hintText: caseBiodata['siblings'][index]['note'] == null ? "" : "${caseBiodata['siblings'][index]['note']}",
                                                        focusedBorder: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: selectedColor,
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                        border: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Color(0xff777D82),
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                              ) :
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 50),
                                              child: Text(
                                                caseBiodata['siblings'][index]['note'] == null ? "--" : "${caseBiodata['siblings'][index]['note']}",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Color(0xff23272A),
                                                    fontSize: 14,
                                                    fontFamily: "quicksand",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                     caseBiodata['siblings'].length - 1 == index
                                        ? Container()
                                        : Container(
                                            //height: 15,
                                            margin: EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 15,
                                                bottom: 15),
                                            child: Divider(
                                              color: Color(0xFF000000),
                                              height: 2,
                                              thickness: 0.2,
                                              //indent: 20,
                                              endIndent: 0,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            );
                          })),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 44,
                                decoration: BoxDecoration(
                                    color: Color(0xffF5FDFA).withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Image.asset("assets/image/family.png"),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                child: Text(
                                  "No siblings are associated with this case.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: Color(0xff707070),
                                      fontSize: 14,
                                      fontFamily: 'quicksand',
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              isEditOpen == false ? Container() : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    //isSiblingsAvailable = true;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddSiblingScreen()));
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
                                    "Add",
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
///////////////////////////////////// Sibling End ///////////////////////////////////

///////////////////////////////////// Kinship Start ///////////////////////////////////
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
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
                          "Other Kinship",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 14,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        isEditOpen == false
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  addKinships();
                                },
                                child: Text(
                                  "+ Add Kinship",
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
                        EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 15),
                    child: Divider(
                      color: Colors.black,
                      height: 2,
                      thickness: 0.1,
                      //indent: 20,
                      endIndent: 0,
                    ),
                  ),
                  caseBiodata['kinships'].length != 0
                      ? Container(
                          margin: EdgeInsets.only(top: 0),
                          child: Column(
                              children: List.generate(caseBiodata['kinships'].length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  //checkPotentialList.add(index);
                                });
                              },
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.only(left: 0, right: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    child: Row(
                                                      children: <Widget>[

                                                        isEditOpen ?
                                              Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(left: 0),
                                                    width: MediaQuery.of(context).size.width/2.6,
                                                    child: TextField(
                                                      onChanged: (value) {
                                                           if(value == ""){
                                                              setState(() {
                                                              caseBiodata['kinships'][index]['name'] = kinshipList[index]['kinships']['name'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                              caseBiodata['kinships'][index]['name'] = value;
                                                          });
                                                            }
                                                        },
                                                      readOnly: isEditOpen ? false : true,
                                                      maxLines: null,
                                                      keyboardType: TextInputType.text,
                                                     // controller: siblingContactNameController,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Color(0xff777D82),
                                                        fontSize: 15,
                                                        fontFamily: "quicksand",
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      cursorColor: selectedColor,
                                                      decoration: InputDecoration(
                                                        isDense: true,
                                                        contentPadding: null,
                                                        hintText: caseBiodata['kinships'][index]['name'] == "" ? "Enter name" : "${caseBiodata['kinships'][index]['name']}",
                                                        focusedBorder: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: selectedColor,
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                        border: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Color(0xff777D82),
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                              ) :
                                                        Container(
                                                          // margin:
                                                          //     EdgeInsets.only(
                                                          //         right: 5),
                                                          child: Text(
                                                           caseBiodata['kinships'][index]['name'] == "" ? "Enter name" : "${caseBiodata['kinships'][index]['name']}",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color:
                                                                    mainColor,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    "quicksand",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      isEditOpen == false ? Container() :
                                                        Container(
                                                          child: IconButton(
                                                            onPressed: () {
                                                              removeKinship(caseBiodata['kinships'][index], index);
                                                            },
                                                            icon: Icon(
                                                              Icons.delete,
                                                              size: 18,
                                                              color: Color(
                                                                  0xffF9423A),
                                                            ),
                                                          ),
                                                        ),
                                                        // Container(
                                                        //   margin:
                                                        //       EdgeInsets.only(
                                                        //           top: 5,
                                                        //           right: 30),
                                                        //   padding:
                                                        //       EdgeInsets.only(
                                                        //           top: 5,
                                                        //           bottom: 5,
                                                        //           left: 10,
                                                        //           right: 10),
                                                        //   decoration: BoxDecoration(
                                                        //       color: Color(
                                                        //               0xffDCF7EE)
                                                        //           .withOpacity(
                                                        //               0.5),
                                                        //       borderRadius:
                                                        //           BorderRadius
                                                        //               .circular(
                                                        //                   5)),
                                                        //   child: Text(
                                                        //     "${kinship[index]['gender']}",
                                                        //     textAlign: TextAlign
                                                        //         .center,
                                                        //     style: TextStyle(
                                                        //         color:
                                                        //             selectedColor,
                                                        //         fontSize: 9,
                                                        //         fontFamily:
                                                        //             "quicksand",
                                                        //         fontWeight:
                                                        //             FontWeight
                                                        //                 .w400),
                                                        //   ),
                                                        // )
                                                      ],
                                                    ),
                                                  ),


                                                 isEditOpen ?
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Container(
                                                        margin: EdgeInsets.only(left: 0),
                                                        width: MediaQuery.of(context).size.width/3,
                                                        child: TextField(
                                                          onChanged: (value) {
                                                               if(value == ""){
                                                                  setState(() {
                                                                  caseBiodata['kinships'][index]['relation'] = kinshipList[index]['relation'];
                                                              });
                                                                }else{
                                                                  setState(() {
                                                                  caseBiodata['kinships'][index]['relation'] = value;
                                                              });
                                                                }
                                                            },
                                                          readOnly: isEditOpen ? false : true,
                                                          maxLines: null,
                                                          keyboardType: TextInputType.text,
                                                         // controller: siblingContactNameController,
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
                                                            hintText: caseBiodata['kinships'][index]['relation'] == "" ? "Relationship" : "${caseBiodata['kinships'][index]['relation']}",
                                                            focusedBorder: isEditOpen
                                                                ? UnderlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                      color: selectedColor,
                                                                    ),
                                                                  )
                                                                : InputBorder.none,
                                                            border: isEditOpen
                                                                ? UnderlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                      color: Color(0xff777D82),
                                                                    ),
                                                                  )
                                                                : InputBorder.none,
                                                          ),
                                                        ),
                                                      ),
                                                  ),
                                                ],
                                              ) : Text(
                                                    caseBiodata['kinships'][index]['relation'] == "" ? "Relationship" : "${caseBiodata['kinships'][index]['relation']}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis, 
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: mainColor,
                                                        fontSize: 12,
                                                        fontFamily: "quicksand",
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // isEditOpen == false
                                          //     ? Container()
                                          //     : Container(
                                          //         margin: EdgeInsets.only(
                                          //             right: 10),
                                          //         child: Text(
                                          //           "trash",
                                          //           maxLines: 1,
                                          //           overflow:
                                          //               TextOverflow.ellipsis,
                                          //           textAlign: TextAlign.center,
                                          //           style: TextStyle(
                                          //               color:
                                          //                   Color(0xffF9423A),
                                          //               fontSize: 12,
                                          //               fontFamily: "quicksand",
                                          //               fontWeight:
                                          //                   FontWeight.w400),
                                          //         ),
                                          //       ),
                                        ],
                                      ),
                                    ),
                                    Container(
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
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              "Contact Name",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff777D82),
                                                  fontSize: 14,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          
                                          isEditOpen ?
                                              Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(left: 7),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                           if(value == ""){
                                                              setState(() {
                                                              caseBiodata['kinships'][index]['contact_name'] = kinshipList[index]['contact_name'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                              caseBiodata['kinships'][index]['contact_name'] = value;
                                                          });
                                                            }
                                                        },
                                                      readOnly: isEditOpen ? false : true,
                                                      maxLines: null,
                                                      keyboardType: TextInputType.text,
                                                     // controller: siblingContactNameController,
                                                      textAlign: TextAlign.right,
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
                                                        hintText: caseBiodata['kinships'][index]['contact_name'] == "" ? "" : "${caseBiodata['kinships'][index]['contact_name']}",
                                                        focusedBorder: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: selectedColor,
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                        border: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Color(0xff777D82),
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                              ) :
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 50),
                                              child: Text(
                                                caseBiodata['kinships'][index]['contact_name'] == "" ? "" : "${caseBiodata['kinships'][index]['contact_name']}",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Color(0xff23272A),
                                                    fontSize: 14,
                                                    fontFamily: "quicksand",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
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
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              "Address",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff777D82),
                                                  fontSize: 14,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),

                                          isEditOpen ?
                                              Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(left: 7),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                           if(value == ""){
                                                              setState(() {
                                                              caseBiodata['kinships'][index]['address'] = kinshipList[index]['address'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                              caseBiodata['kinships'][index]['address'] = value;
                                                          });
                                                            }
                                                        },
                                                      readOnly: isEditOpen ? false : true,
                                                      maxLines: null,
                                                      keyboardType: TextInputType.text,
                                                     // controller: siblingContactNameController,
                                                      textAlign: TextAlign.right,
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
                                                        hintText: caseBiodata['kinships'][index]['address'] == "" ? "" : "${caseBiodata['kinships'][index]['address']}",
                                                        focusedBorder: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: selectedColor,
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                        border: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Color(0xff777D82),
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                              ) :
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 50),
                                              child: Text(
                                                caseBiodata['kinships'][index]['address'] == "" ? "" : "${caseBiodata['kinships'][index]['address']}",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Color(0xff23272A),
                                                    fontSize: 14,
                                                    fontFamily: "quicksand",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
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
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              "Phone Number",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff777D82),
                                                  fontSize: 14,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),

                                          isEditOpen ?
                                              Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(left: 7),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                           if(value == ""){
                                                              setState(() {
                                                              caseBiodata['kinships'][index]['phone_number'] = kinshipList[index]['phone_number'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                              caseBiodata['kinships'][index]['phone_number'] = value;
                                                          });
                                                            }
                                                        },
                                                      readOnly: isEditOpen ? false : true,
                                                      maxLines: null,
                                                      keyboardType: TextInputType.text,
                                                     // controller: siblingContactNameController,
                                                      textAlign: TextAlign.right,
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
                                                        hintText: caseBiodata['kinships'][index]['phone_number'] == "" ? "" : "${caseBiodata['kinships'][index]['phone_number']}",
                                                        focusedBorder: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: selectedColor,
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                        border: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Color(0xff777D82),
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                              ) :
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 50),
                                              child: Text(
                                                caseBiodata['kinships'][index]['phone_number'] == "" ? "" : "${caseBiodata['kinships'][index]['phone_number']}",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Color(0xff23272A),
                                                    fontSize: 14,
                                                    fontFamily: "quicksand",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
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
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              "Email",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff777D82),
                                                  fontSize: 14,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),

                                          isEditOpen ?
                                              Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(left: 7),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                           if(value == ""){
                                                              setState(() {
                                                              caseBiodata['kinships'][index]['email'] = kinshipList[index]['email'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                              caseBiodata['kinships'][index]['email'] = value;
                                                          });
                                                            }
                                                        },
                                                      readOnly: isEditOpen ? false : true,
                                                      maxLines: null,
                                                      keyboardType: TextInputType.text,
                                                     // controller: siblingContactNameController,
                                                      textAlign: TextAlign.right,
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
                                                        hintText: caseBiodata['kinships'][index]['email'] == "" ? "" : "${caseBiodata['kinships'][index]['email']}",
                                                        focusedBorder: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: selectedColor,
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                        border: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Color(0xff777D82),
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                              ) :
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 50),
                                              child: Text(
                                                caseBiodata['kinships'][index]['email'] == "" ? "" : "${caseBiodata['kinships'][index]['email']}",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Color(0xff23272A),
                                                    fontSize: 14,
                                                    fontFamily: "quicksand",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
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
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              "Notes",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff777D82),
                                                  fontSize: 14,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),

                                          isEditOpen ?
                                              Flexible(
                                                child: Container(
                                                    margin: EdgeInsets.only(left: 7),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                           if(value == ""){
                                                              setState(() {
                                                              caseBiodata['kinships'][index]['note'] = kinshipList[index]['note'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                              caseBiodata['kinships'][index]['note'] = value;
                                                          });
                                                            }
                                                        },
                                                      readOnly: isEditOpen ? false : true,
                                                      maxLines: null,
                                                      keyboardType: TextInputType.text,
                                                     // controller: siblingContactNameController,
                                                      textAlign: TextAlign.right,
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
                                                        hintText: caseBiodata['kinships'][index]['note'] == "" ? "" : "${caseBiodata['kinships'][index]['note']}",
                                                        focusedBorder: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: selectedColor,
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                        border: isEditOpen
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Color(0xff777D82),
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                              ) :
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 50),
                                              child: Text(
                                                caseBiodata['kinships'][index]['note'] == "" ? "--" : "${caseBiodata['kinships'][index]['note']}",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Color(0xff23272A),
                                                    fontSize: 14,
                                                    fontFamily: "quicksand",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    caseBiodata['kinships'].length - 1 == index
                                        ? Container()
                                        : Container(
                                            //height: 15,
                                            margin: EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 15,
                                                bottom: 15),
                                            child: Divider(
                                              color: Color(0xFF000000),
                                              height: 2,
                                              thickness: 0.2,
                                              //indent: 20,
                                              endIndent: 0,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            );
                          })),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 44,
                                decoration: BoxDecoration(
                                    color: Color(0xffF5FDFA).withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Image.asset(
                                    "assets/image/play-with-child.png"),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                child: Text(
                                  "No other kin are assisted with this case.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: Color(0xff707070),
                                      fontSize: 14,
                                      fontFamily: 'quicksand',
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              isEditOpen == false ? Container() : GestureDetector(
                                onTap: () {
                                  setState(() {
                                   // isKinshipAvailable = true;
                                   addKinships();
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
                                    "Add",
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
            
            ////////////////////// Log Start ///////////////////////////////////////
            BioCommonLog(caseLog, user['id']) 
            ////////////////////// Log End ////////////////////////////////////////
          ],
        ),
      ),
    );
  }

////////////////////////////////////// _showPlacementDialog //////////////////////////////
  Future<Null> _showPlacementDialog() async {
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
                      child: Image.asset("assets/image/move.png")),
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
                    "Are you sure you want to move the child out of this placement?",
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddPlacementPage()));
                          },
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  top: 0, bottom: 20, left: 2.5, right: 0),
                              decoration: BoxDecoration(
                                color: selectedColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text("Proceed",
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
////////////////////////////////////// _showPlacementDialog //////////////////////////////

/////////////////////////////////////// _showAddPeopleDialog //////////////////////////////
  Future<Null> _showAddPeopleDialog() async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
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
                            "Add people",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'quicksand',
                                color: mainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.15),
                              borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          padding: EdgeInsets.only(top: 5, bottom: 5, right: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 12, right: 10, top: 5),
                                child: Text(
                                  "Add People",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xff7A98A9),
                                      fontSize: 10,
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
                                        fontSize: 12,
                                        color: Color(0xff003A5B),
                                      ),
                                      value: valPeople,
                                      items: _dropDownPeopleItems,
                                      icon: Icon(
                                        Icons.expand_more,
                                        size: 15,
                                        color: Color(0xff707070),
                                      ),
                                      onChanged: (String value) {
                                        setState(() {
                                          valPeople = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 20, top: 5, bottom: 10, right: 20),
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isByEmail = true;
                                    emailListData.add({ 
                                      'data': '',
                                    });
                                  });
                                },
                                child: Container(
                                  child: Text(
                                    "or invite by email",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: 'quicksand',
                                        color: selectedColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                             // emailListData.length == 0
                               isByEmail==false ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          emailListData.add({
                                            'data': '',
                                          });
                                        });
                                      },
                                      child: Container(
                                        child: Text(
                                          "+ Invite More",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontFamily: 'quicksand',
                                              color: mainColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        //emailListData.length == 0
                         isByEmail==false   ? Container()
                            : Container(
                                child: Column(
                                  children:
                                      List.generate(emailListData.length, (index) {
                                    return Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey,
                                                width: 0.15),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20, top: 5),
                                        padding: EdgeInsets.only(
                                            top: 15, bottom: 5, right: 10),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: TextField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    emailListData[index]['data'] =
                                                        value;
                                                  });
                                                },
                                                autofocus:  emailListData[index]['data'] == "" ? true : false,
                                                //readOnly: emailListData[index]['data'] != "" ? true : false,
                                                keyboardType: TextInputType.emailAddress,
                                                style: TextStyle(
                                                    color: mainColor,
                                                    fontSize: 12,
                                                    fontFamily: 'quicksand',
                                                    fontWeight:
                                                        FontWeight.w500),
                                                decoration: InputDecoration(
                                                  hintText: emailListData[index]['data'] != "" ? "${emailListData[index]['data']}" : "Enter Email",
                                                  hintStyle: TextStyle(
                                                      color: mainColor,
                                                      fontSize: 12,
                                                      fontFamily: 'quicksand',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  labelStyle: TextStyle(
                                                      color: Color(0xff7A98A9),
                                                      fontSize: 10,
                                                      fontFamily: 'quicksand',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  labelText: emailListData[index]['data'] != "" ? "${emailListData[index]['data']}" : "Email",
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          12.0, 0, 12.0, 0),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ));
                                  }),
                                ),
                              ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              border: Border.all(color: Colors.white)),
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                          emailListData = [];
                                          isByEmail = false;
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
                                  
                                  isByEmail ? emailPlacementPeople() : routeToPlacementPeople();
                                    
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
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text("Proceed",
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
                  ),
                );
              }));
        });
  }
////////////////////////////////////// _showAddPeopleDialog //////////////////////////////


/////////////////////////////////////// Interest Dialog //////////////////////////////
  Future<Null> _showAddInterestsDialog() async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
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
                            "Add Activities & Interests",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'quicksand',
                                color: mainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 0.15),
                                borderRadius: BorderRadius.circular(5)),
                            width: MediaQuery.of(context).size.width,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 5),
                            padding:
                                EdgeInsets.only(top: 5, bottom: 5, right: 10),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        interests = value;
                                      });
                                    },
                                    controller: interestsController,
                                    textCapitalization: TextCapitalization.sentences,
                                    autofocus: false,
                                    style: TextStyle(
                                        color: Color(0xff7A98A9),
                                        fontSize: 12,
                                        fontFamily: 'quicksand',
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      hintText: "e.g. Basketbal",
                                      hintStyle: TextStyle(
                                          color: Color(0xff7A98A9),
                                          fontSize: 12,
                                          fontFamily: 'quicksand',
                                          fontWeight: FontWeight.w500),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        isinterestPressed
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
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    border: Border.all(color: Colors.white)),
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
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
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "quicksand"))),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isinterestPressed = true;
                                          });
                                          Timer(Duration(seconds: 3), () {
                                            Navigator.pop(context);
                                            refresh(1);
                                          });
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
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "quicksand"))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              }));
        });
  }
/////////////////////////////////////// Interest Dialog //////////////////////////////
  


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
                                        child: Image.asset(doc ==
                                                "Social Security Card"
                                            ? "assets/image/birth_certificate.png"
                                            : doc == "Birth Ceritificate"
                                                ? "assets/image/security_card.png"
                                                : "assets/image/google-docs.png"),
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
                                                  doc == "Social Security Card"
                                                      ? "Social Security Card"
                                                      : doc ==
                                                              "Birth Ceritificate"
                                                          ? "Birth Ceritificate"
                                                          : doc,
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
                              ////////////////////////////////////////////
                            : isDocItemPressed
                                ? Column(
                                    children: <Widget>[
                                      Container(
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
                                              top: 5,
                                              bottom: 0),
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 5, right: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                child: TextField(
                                                  onChanged: (value) {
                                                    setState(() {
                                                      doc = value;
                                                    });
                                                  },
                                                  controller: docController,
                                                  autofocus: false,
                                                  textCapitalization: TextCapitalization.sentences,
                                                  enabled: doc ==
                                                          "Social Security Card"
                                                      ? false
                                                      : doc ==
                                                              "Birth Ceritificate"
                                                          ? false
                                                          : true,
                                                  style: TextStyle(
                                                      color: Color(0xff7A98A9),
                                                      fontSize: 12,
                                                      fontFamily: 'quicksand',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  decoration: InputDecoration(
                                                    hintText: "Document Name",
                                                    hintStyle: TextStyle(
                                                        color:
                                                            Color(0xff7A98A9),
                                                        fontSize: 12,
                                                        fontFamily: 'quicksand',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            12.0, 0, 12.0, 0),
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
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
                                  )
                              /////////////////////////////////////////////////
                                : Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              docController.text =
                                                  "Social Security Card";
                                              doc = "Social Security Card";
                                              isDocItemPressed = true;
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 15, right: 15, top: 20),
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
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Image.asset(
                                                      "assets/image/birth_certificate.png"),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            "Social Security Card",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff060606),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'quicksand',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          child: Text(
                                                            "Upload",
                                                            textAlign: TextAlign
                                                                .justify,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff003A5B),
                                                                fontSize: 11,
                                                                fontFamily:
                                                                    'quicksand',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
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
                                              docController.text =
                                                  "Birth Ceritificate";
                                              doc = "Birth Ceritificate";
                                              isDocItemPressed = true;
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 15, right: 15, top: 20),
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
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Image.asset(
                                                      "assets/image/security_card.png"),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            "Birth Ceritificate",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff060606),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'quicksand',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          child: Text(
                                                            "Upload",
                                                            textAlign: TextAlign
                                                                .justify,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff003A5B),
                                                                fontSize: 11,
                                                                fontFamily:
                                                                    'quicksand',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
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
                                              docController.text = "";
                                              doc = "";
                                              isDocItemPressed = true;
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 15, right: 15, top: 20),
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
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Image.asset(
                                                      "assets/image/google-docs.png"),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            "Other Document",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff060606),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'quicksand',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          child: Text(
                                                            "Upload",
                                                            textAlign: TextAlign
                                                                .justify,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff003A5B),
                                                                fontSize: 11,
                                                                fontFamily:
                                                                    'quicksand',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
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
                            : isDocItemPressed
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
                                              isDocItemPressed = false;
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
                                              doc == "" || file == null
                                              ? null:
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
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'PNG']
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
          isDocumentPressed = true;
          isDocAvailable = true;
          isFileUploading = false;
      });
       Navigator.pop(context);
    } else if(response.statusCode == 200 && body['success'] == true) {
      print("Oise Upload");
      
      setState(() {
          uploadedDocData = body;
          isDocumentPressed = true;
          isDocAvailable = true;
          isFileUploading = false;
          file = null;
        });
      refresh(2);
      Navigator.pop(context);
      //print(uploadedDocData);
    }
    else{
      print("Oise na Upload");
      setState(() {
          isDocumentPressed = true;
          isDocAvailable = true;
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
  void refresh(number) {
    if (number == 1) {
      setState(() {
        isinterestPressed = false;
        games.removeWhere((games) => games['title'] == "add_people");
        games.add({"title": interests});
        games.add({"title": "add_people"});
        interests = "";
        interestsController.text = "";
      });
    } else {
      setState(() {
        isDocumentPressed = false;
        var data = {
          'id': 0,
          'doc_type': doc == "Social Security Card"
              ? "security"
              : doc == "Birth Ceritificate" ? "birth" : "other",
          'doc_name': doc,
         'url': uploadedDocData['pic'],
         'url_type': uploadedDocData['type'],
         'extension': uploadedDocData['extension'],
        };
        print(data);
       documentList.add(data);
       caseBiodata['case_documents'].add(data);
       store.dispatch(BiographicalInfoAction(store.state.biographicalInfoState));
        doc = "";
        docController.text = "";
        path = "";
        isDocItemPressed = false;
      });
    }
  }
  //////////////////////Refresh ////////////////////////

String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }
//////////////////////Save BioData Start////////////////////////
   Future<void> _saveBioData() async {
    setState(() {
      isLoading = true;
      games.removeWhere((games) => games['title'] == "add_people");
    });

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userJson = localStorage.getString('user');
      var userData = json.decode(userJson);


      var data = {
                  "case_general_id": caseBiodata['id'],
                  "user_id": userData['id'],
                  "case_generals": {
                      "first_name": caseBiodata['first_name'],
                      "last_name":caseBiodata['last_name'],
                      "birthday": DateFormat("yyyy-MM-dd").format(DateTime.parse(apiGenDate)), // caseBiodata['birthday'],//dateToGeneral
                      "gender": caseBiodata['gender'],
                      "place_of_birth": placeOfBirthController.text,
                      "race": genRace,
                      "ethnicity": genEthnicity,
                      "ssn": ssnController.text,
                  },
                  "case_placements": {
                      "placement_name": placementNameController.text,
                      "placement_type": placementType,
                       "date": DateFormat("yyyy-MM-dd").format(DateTime.parse(apiPlacementDate)) ,// caseBiodata['placements']['created_at'],//dateToPlacement,
                      "phone_number": placementPhoneController.text,
                      "address": placementAddressController.text,
                      "email": placementEmailController.text
                  },
                  "languages": genListLanguage,
                  "activities_and_interests": games.map((obj) => obj['title']).toList(),
                  "documents": documentList,
                  "people_at_placement":{
                      "user": caseBiodata['people_of_placements'].map((obj) => obj['people_info']['id']).toList(),
                      "email": emailListData.map((obj) => obj['data']).toList(),
                  },
                  "siblings": siblingsList,
                  "kinships": kinshipList
                  };
       print(data);




      var res = await CallApi().postData(data, 'post_biographical_details');
       var body = json.decode(res.body);
       print(body);
    
   if (res.statusCode == 400 ) {
      print("Something went wrong(400)");
      _errorDialog("Something went wrong!");
      setState(() {
          isLoading = false;
          isEditOpen = false;
          games.add({"title": "add_people"});
        }); 
    }
    else if (res.statusCode == 200) {
      setState(() {
          siblingsList = []; ///////////// have to fill it after getting response
          kinshipList = [];
          documentList = [];
          games = [];
          documentList = [];
          documentList = [];
        }); 
      //////////////////// All work here////////////////////
       print(body['caseBiographical'].length);
      //if (body != null) {
       store.dispatch(BiographicalInfoAction(body['caseBiographical'])); // update data in store...
       store.dispatch(CommonLogAction(body['Logs'])); // update data in store...
      // print(body['caseBiographical']);
       //print(store.state.biographicalInfoState);
       if (!mounted) return;
       setState(() {
         caseBiodata = store.state.biographicalInfoState;
         caseLog = store.state.commonLogInfoState;
       });

    dateToGeneral = caseBiodata['birthday'] != null ? "${DateFormat("MM-dd-yyyy").format(DateTime.parse(caseBiodata['birthday']))}"  : "${DateFormat("MM-dd-yyyy").format(DateTime.now())}";
    apiGenDate = caseBiodata['birthday'] != null ? caseBiodata['birthday']  : DateTime.now();
    dateToPlacement =  caseBiodata['placements'] == null ? '' : caseBiodata['placements']['created_at'] == null ? '' : "${DateFormat("MM-dd-yyyy").format(DateTime.parse(caseBiodata['placements']['created_at']))}" ; //"${DateFormat("dd-MM-yyyy").format(DateTime.now())}";
    apiPlacementDate =  caseBiodata['placements'] == null ? null : caseBiodata['placements']['created_at'] == null ? null : caseBiodata['placements']['created_at'] ; //"${DateFormat("dd-MM-yyyy").format(DateTime.now())}";
    placeOfBirthController.text = caseBiodata['place_of_birth'] != null ? caseBiodata['place_of_birth'] : "";
    ssnController.text =  caseBiodata['ssn'] != null ? caseBiodata['ssn'] : '';
    //genListLanguage =  caseBiodata['language'] != null ? caseBiodata['language'] : '';
    if(caseBiodata['language'].length  >= 1){
      for(var i = 0; i < caseBiodata['language'].length; i++){
      genListLanguage = [];
      genListLanguage.add(caseBiodata['language'][i]['language']);
    }
    }else{
      genListLanguage = [];
    }
    genRace =  caseBiodata['race'] != null ? caseBiodata['race'] : '';
    genEthnicity =  caseBiodata['ethnicity'] != null ? caseBiodata['ethnicity'] : '';
    games =  caseBiodata['activities'] != null ? caseBiodata['activities'] : [];
    games.add({"title": "add_people"});

    placementNameController.text = caseBiodata['placements'] == null ? '' : caseBiodata['placements']['placement_name'] == null ? '' : caseBiodata['placements']['placement_name'];
    placementAddressController.text = caseBiodata['placements'] == null ? '' : caseBiodata['placements']['address'] == null ? '' : caseBiodata['placements']['address'];
    placementPhoneController.text = caseBiodata['placements'] == null ? '' : caseBiodata['placements']['phone_number'] == null ? '' : caseBiodata['placements']['phone_number'];
    placementEmailController.text = caseBiodata['placements'] == null ? '' : caseBiodata['placements']['email'] == null ? '' : caseBiodata['placements']['email'];
    placementType = caseBiodata['placements'] == null ? '' : caseBiodata['placements']['placement_type'] == null ? '' : caseBiodata['placements']['placement_type'];
    
    for (var x in caseBiodata['siblings']) {
        siblingsList.add({
          'id' : x['id'],
          'name' : x['name'],
          'address': x['address'],
          'phone_number': x['phone_number'],
          'email': x['email'],
          'gender': x['gender'],
          'relation': x['relation'],
          'note': x['note'],
          'status': x['status'],
          'placement_type' : x['placement_type'],
          'contact_name' : x['contact_name'],
          'birthday': x['birthday']
          });
      }
      print(siblingsList);
    //  // return siblingsList;

    for (var y in caseBiodata['kinships']) {
        kinshipList.add({
          'id' : y['id'],
          'name' : y['name'],
          'address': y['address'],
          'phone_number': y['phone_number'],
          'email': y['email'],
          'relation': y['relation'],
          'note': y['note'],
          'contact_name': y['contact_name'],
          });
      }
      print(kinshipList);
    //  // return kinshipList;


    for (var z in caseBiodata['case_documents']) {
        documentList.add({
          'id': z['id'],
          'doc_type': z['doc_type'],
          'doc_name': z['doc_name'],
          'url': z['url'],
          'url_type': z['url_type'],
          'extension':z['extension'],
          });
      }
      print(documentList);
    //  // return kinshipList;

    
    // _dropDownPeopleItems = getDropDownPeopleItems();
    // valPeople = _dropDownPeopleItems[0].value;

    setState(() {
      isEditOpen = false;
      isLoading = false;
      });
      //////////////////// All work here////////////////////
      
    }
    else{
      print("Api o Problem rebo vai");
      _errorDialog("Something went wrong!");
      setState(() {
        games.add({"title": "add_people"});
        isEditOpen = false;
          isLoading = false;
        });

   }

  // setState(() {
  //   isEditOpen = false;
  //   isLoading = false;
  //  // siblingsList = []; ///////////// have to fill it after getting response
  // });
  
  }
/////////////////////Save BioData End////////////////////////

 /////////////////////// Remove Document ///////////////////
  void removeDocument(caseBiooo, index) async{

    //print(index);

    for(var b in caseBiodata['case_documents']){
      if(b['url'] == caseBiooo['url'] ){
        //print(b);
       // _errorDialog("lalalala");
        store.state.biographicalInfoState['case_documents'].remove(b);
        store.dispatch(BiographicalInfoAction(store.state.biographicalInfoState));
        break;
      }
      else{
        print("hi hello");
      } 
    }
      for(var b in documentList){
      if(b['url'] == caseBiooo['url']){
        //print(b);
        documentList.remove(b);
        break;
      }
      else{
        print("hi hello");
      } 
    }
    
  }
  /////////////////////// Remove Document ///////////////////

/////////////////////// Remove sibling ///////////////////
  void removeSibling(caseBiooo, index) async{

    //print(index);

    for(var b in caseBiodata['siblings']){
      if(b['name'] == caseBiooo['name']){
        //print(b);
       // _errorDialog("lalalala");
        store.state.biographicalInfoState['siblings'].remove(b);
        store.dispatch(BiographicalInfoAction(store.state.biographicalInfoState));
        break;
      }
      else{
        print("hi hello");
      } 
    }

    for(var b in siblingsList){
      if(b['name'] == caseBiooo['name']){
        //print(b);
        siblingsList.remove(b);
        break;
      }
      else{
        print("hi hello");
      } 
    }
    
  }
  /////////////////////// Remove sibling ///////////////////


/////////////////////// Add Kinships ///////////////////
  void addKinships() async{

    //Navigator.push(context,MaterialPageRoute(builder: (context) =>AddKinshipScreen()));
     var data =    {
          'id' : 0,
          'name' : "",
          'address': "",
          'phone_number': "",
          'email': "",
          'relation': "",
          'note': "",
          'contact_name' : ""
          };
       store.state.biographicalInfoState['kinships'].add(data);
       kinshipList.add(data);
       store.dispatch(BiographicalInfoAction(store.state.biographicalInfoState));

       print(caseBiodata['kinships']);
    
  }
  /////////////////////// Add Kinships ///////////////////
  
  /////////////////////// Remove Kinships ///////////////////
  void removeKinship(caseBiooo, index) async{

    //print(index);

    for(var b in caseBiodata['kinships']){
      if(b['name'] == caseBiooo['name']){
        //print(b);
       // _errorDialog("lalalala");
        store.state.biographicalInfoState['kinships'].remove(b);
       // kinshipList.remove(b);
        store.dispatch(BiographicalInfoAction(store.state.biographicalInfoState));
        break;
      }
      else{
        print("hi hello");
      } 
    }

    for(var b in kinshipList){
      if(b['name'] == caseBiooo['name']){
        //print(b);
        kinshipList.remove(b);
        break;
      }
      else{
        print("hi hello");
      } 
    }
    
  }
  /////////////////////// Remove Kinships ///////////////////
  

  /////////////////////// Remove Placement People ///////////////////
  void removePlacementPeople(caseBiooo, index) async{

    for(var b in caseBiodata['people_of_placements']){
      if(b['people_info']['id'] == caseBiooo['people_info']['id']){
        store.state.biographicalInfoState['people_of_placements'].remove(b);
        store.dispatch(BiographicalInfoAction(store.state.biographicalInfoState));
        break;
      }
      else{
        print("hi hello");
      } 
    }
    
  }
  /////////////////////// Remove Placement People ///////////////////
  
    /////////////////////// Route Placement People ///////////////////
  void routeToPlacementPeople() async{

    Navigator.pop(context);
     Navigator.push(context, MaterialPageRoute( builder: (context) => PlacementAddPeopleScreen()));
    
  }
  /////////////////////// Route Placement People ///////////////////
  /////////////////////// Add Email People ///////////////////
  void emailPlacementPeople() async{

    print(emailListData);
    Navigator.pop(context);
    
  }
  /////////////////////// Add Email People ///////////////////
  

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
