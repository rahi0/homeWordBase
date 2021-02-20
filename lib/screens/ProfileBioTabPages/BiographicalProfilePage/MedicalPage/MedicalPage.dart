import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:homewardbase/screens/FileShowingPage/FileShowingPage.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioUpdatePages/updateMedicalDocScreen.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:homewardbase/screens/ProfileBioPage/ProfileBioPage.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/BioCommonWidgets/BioCommonWidgets.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/addAllergyScreen.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/addDoctorScreen.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/addImmunizationsScreen.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/addInsuranceScreen.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/addMedicalConditionsScreen.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/addMedicationScreen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';

class MedicalPage extends StatefulWidget {
  final caseId;
  MedicalPage(this.caseId);
  @override
  _MedicalPageState createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  bool isLoading = true; 
  bool noData = false;

  var medicalData;
  var caseLog;
  var user;
  bool isMedicalEdit = false;
  bool isDoctorAdded = false;

  ///////////////// for file /////////////
  bool isDocAvailable = false;
  bool isDocumentPressed = false;
  bool isDocItemPressed = false;
  bool isFileUploading = false;

  var uploadedDocData;
  List documentList = [];

   String path = "", doc ='';
   File file;
  ///////////////// for file /////////////

void textRxBinnValue(value){
  print(value);
}
  ////////////////////////  text field container start /////////////////////////
  Container textFieldCon(TextInputType tit, Function fff) {
    return Container(
      margin: EdgeInsets.only(left: 7),
      child: TextField(
        readOnly: isMedicalEdit ? false : true,
        maxLines: null,
        keyboardType: tit,
        //controller: controller,
        onChanged: fff,
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
          focusedBorder: isMedicalEdit
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: selectedColor,
                  ),
                )
              : InputBorder.none,
          border: isMedicalEdit
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
  //////////////////////// text field container end /////////////////////////



  @override
  void initState() {
    super.initState();
    _getMedicalData();
    //menuSelected = 0;
  }


  _getMedicalData() async {

    setState(() {
      isLoading = true;
      doctorList = []; ///////////// have to fill it after getting response
      conditionList = []; ///////////// have to fill it after getting response
      immunizationList = []; ///////////// have to fill it after getting response
      allergyList = []; ///////////// have to fill it after getting response
      medicationList = []; ///////////// have to fill it after getting response
      medicaInsuranceList = []; ///////////// have to fill it after getting response
    });

   SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    user = json.decode(userJson);
    //print(user);

   var data = {
      'case_general_id': widget.caseId,
      //'user_id': user['id']
    };

    print(data);
    var res = await CallApi().postData(data, 'get_medical_details');
    final body = json.decode(res.body);
    //var homePageData;
  //  print(body);
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

       store.dispatch(MedicalInfoAction(body)); // update data in store...
       
       //print(store.state.biographicalInfoState);
       if (!mounted) return;
       setState(() {
         medicalData = store.state.medicalInfoState;
         caseLog = store.state.commonLogInfoState;
       });
       print(medicalData);

       for (var x in medicalData['doctor']) {
        doctorList.add({
          'id' : x['id'],
          'name' : x['name'],
          'address': x['address'],
          'phone_number': x['phone_number'],
          'profile_picture': x['profile_picture'],
          'department': x['department'],
          });
      }

      for (var x in medicalData['Immunization']) {
        immunizationList.add({
          'id' : x['id'],
          'title' : x['title'],
          'description': x['description'],
          'date': x['date'],
          });
      }

      for (var x in medicalData['PhysicalCondition']) {
        conditionList.add({
          'title' : x['title'],
          'id' : x['id'],
          'type': x['type'],
          'description': x['description'],
          'date': x['date'],
          });
      }

      for (var x in medicalData['Allergy']) {
        allergyList.add({
          'id' : x['id'],
          'allergy_type' : x['allergy_type'],
          'symptoms': x['symptoms'],
          'severity': x['severity']
          });
      }


      for (var x in medicalData['Medication']) {
        medicationList.add({
          'id' : x['id'],
          'medicin_name' : x['medicin_name'],
          'power': x['power'],
          'taking_method': x['taking_method'],
          'cause': x['cause'],
          'doctor_id': x['doctor_id'],
          'time': x['medicin_taking_time'].map((obj) => obj['time']).toList(),
          });
      }

      for (var x in medicalData['insurance']) {
        medicaInsuranceList.add({
          'id' : x['id'],
          'plan_name' : x['plan_name'],
          'id_number': x['id_number'],
          'rx_bin': x['rx_bin'],
          'rx_group': x['rx_group'],
          'rx_pcn': x['rx_pcn'],
          'phone_number': x['phone_number'],
          'Front_Photo': x['Front_Photo'],
          'Back_Photo': x['Back_Photo'], 
          });
      }

        
    //  "Front_Photo":{
    //     "id": 0,
    //     "pic_type" : "Front_Photo",
    //     "url": "/uploads/4KXa6XXgXVs6MCX9UfJ5hvlJ30JUheN0jOZMScsi.png",
    //     "url_type": "image/png",
    //     "extension": "png"
    // }
    
    // dateToLegal = legalData['date'] == null ? "" : "${DateFormat("dd-MM-yyyy").format(DateTime.parse(legalData['date']))}";//"${DateFormat("dd-MM-yyyy").format(DateTime.now())}";
    // noteController.text = legalData['note'] == null ? "" : legalData['note'];
    // // ssnController.text =  caseBiodata['ssn'] != null ? caseBiodata['ssn'] : '';
    

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
                      "Medical",
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
                        isMedicalEdit == false
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isMedicalEdit = false;
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
                              if (isMedicalEdit) {
                                _saveMedicalData();
                              } else {
                                isMedicalEdit = true;
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
                                  isMedicalEdit == false
                                      ? Icon(Icons.edit,
                                          size: 11, color: Colors.white)
                                      : Container(),
                                  Text(
                                    isMedicalEdit == false ? " Edit" : "Save",
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
                      ],
                    ),
                  ),
                ],
              ),
            ),


 //////////////////// Doctor Start /////////////////////////           
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
                          "Doctors",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 14,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        isMedicalEdit == false
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddDoctorScreen()));
                                },
                                child: Text(
                                  "+ Add Doctor",
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


                  //////////////////// Doctors list start /////////////////////////
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Column(
                        children: List.generate(medicalData['doctor'].length, (index) {
                      return GestureDetector(
                        onTap: () {
                          isMedicalEdit == false ? null :
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateDoctorScreen(medicalData['doctor'][index], index))).then((value) {
                                setState(() {});
                                });
                        },
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 0, right: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(left: 20),
                                      decoration: BoxDecoration(
                                          color: selectedColor,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      height: 45,
                                      width: 45,
                                      child: Image.asset(
                                                  "assets/image/stethoscope.png",
                                                  color: Colors.white,
                                                   fit: BoxFit.cover
                                                  ),
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
                                                        "${medicalData['doctor'][index]['name']}",
                                                        // maxLines: 1,
                                                        // overflow: TextOverflow
                                                        //     .ellipsis,
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
                                                      "${medicalData['doctor'][index]['department']}",
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
                                            SizedBox(height: 7),
                                            Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.location_on,
                                                    size: 15,
                                                    color: mainColor,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(left: 2),
                                                      child: Text(
                                                        "${medicalData['doctor'][index]['address']}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            color: mainColor,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                "quicksand",
                                                            fontWeight:
                                                                FontWeight.w400),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.phone,
                                                    size: 12,
                                                    color: mainColor,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(left: 2),
                                                    child: Text(
                                                      "${medicalData['doctor'][index]['phone_number']}",
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
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    isMedicalEdit == false
                                        ? Container()
                                        : GestureDetector(
                                                  onTap: (){
                                                    removeDoctor(medicalData['doctor'][index], index);
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
                              medicalData['doctor'].length - 1 == index
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
                  //////////////////// Doctors list End /////////////////////////
                ],
              ),
            ),
//////////////////// Doctor End /////////////////////////     

//////////////////// Medications Start /////////////////////////
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
                          "Medications",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 14,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        isMedicalEdit == false
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddMedicationScreen()));
                                },
                                child: Text(
                                  "+ Add Medications",
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


                  //////////////////// Medication list start /////////////////////////
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Column(
                        children: List.generate(medicalData['Medication'].length, (index) {
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
                                padding: EdgeInsets.only(left: 0, right: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                      child: Text(
                                                        "${medicalData['Medication'][index]['medicin_name']}",
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
                                                      "${medicalData['Medication'][index]['power']}",
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
                                            SizedBox(height: 7),
                                            Container(
                                              child: Text(
                                                "${medicalData['Medication'][index]['cause']}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: mainColor,
                                                    fontSize: 12,
                                                    fontFamily: "quicksand",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            Container(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 5, right: 10),
                                                    padding: EdgeInsets.only(
                                                        top: 5,
                                                        bottom: 5,
                                                        left: 10,
                                                        right: 10),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffF0F3F5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Text(
                                                      "${medicalData['Medication'][index]['taking_method']}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: mainColor,
                                                          fontSize: 9,
                                                          fontFamily:
                                                              "quicksand",
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      //color: Colors.red,
                                                      child: Wrap(
                                                        children: List.generate(medicalData['Medication'][index]['medicin_taking_time'].length, (ind) {
                                                          return Container(
                                                            margin: EdgeInsets.only(top: 5, right: 10),
                                                            padding: EdgeInsets.only(
                                                                top: 5,bottom: 5,left: 10,right: 10),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Color(0xffF0F3F5),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(5)),
                                                            child: Text(
                                                              "${medicalData['Medication'][index]['medicin_taking_time'][ind]['time']}",
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: TextStyle(
                                                                  color: mainColor,
                                                                  fontSize: 9,
                                                                  fontFamily:
                                                                      "quicksand",
                                                                  fontWeight:
                                                                      FontWeight.w400),
                                                            ),
                                                          );
                                                        }),
                                                        


                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    isMedicalEdit == false
                                        ? Container()
                                        : GestureDetector(
                                                  onTap: (){
                                                    removeMedicine(medicalData['Medication'][index], index);
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
                              medicalData['Medication'].length - 1 == index
                                  ? Container()
                                  : Container(
                                      //height: 15,
                                      margin: EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          top: 15,
                                          bottom: 10),
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

                  //////////////////// Medication list End /////////////////////////
                ],
              ),
            ),
//////////////////// Medications End /////////////////////////


//////////////////// Allergies Start /////////////////////////
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
                          "Allergies",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 14,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        isMedicalEdit == false
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddAllergyScreen()));
                                },
                                child: Text(
                                  "+ Add Allergy",
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

                  //////////////////// Allergies list start /////////////////////////
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Column(
                        children: List.generate(medicalData['Allergy'].length, (index) {
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
                                padding: EdgeInsets.only(left: 0, right: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                      child: Text(
                                                        "${medicalData['Allergy'][index]['allergy_type']}",
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
                                                        color:
                                                            Color(0xffF0F3F5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Text(
                                                      "${medicalData['Allergy'][index]['severity']}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: mainColor,
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
                                            SizedBox(height: 7),
                                            Container(
                                              child: Text(
                                                "${medicalData['Allergy'][index]['symptoms']}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: mainColor,
                                                    fontSize: 12,
                                                    fontFamily: "quicksand",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    isMedicalEdit == false
                                        ? Container()
                                        : GestureDetector(
                                                  onTap: (){
                                                    removeAllergie(medicalData['Allergy'][index], index);
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
                              medicalData['Allergy'].length - 1 == index
                                  ? Container()
                                  : Container(
                                      //height: 15,
                                      margin: EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          top: 15,
                                          bottom: 10),
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

                  //////////////////// Allergies list End /////////////////////////
                ],
              ),
            ),

//////////////////// Insurance Start /////////////////////////
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
                          "Insurance",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 14,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        isMedicalEdit == false
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddInsuranceScreen())); 
                                },
                                child: Text(
                                  "+ Add Insurance",
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

                  //////////////////// insuranceList start /////////////////////////
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Column(
                        children: List.generate(medicalData['insurance'].length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            //checkPotentialList.add(index);
                          });
                        },
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              isMedicalEdit
                                  ? Container(
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
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 20),
                                                            child: Text(
                                                              "${medicalData['insurance'][index]['plan_name']}",
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
                                                        ),
                                                        isMedicalEdit == false
                                                            ? Container()
                                                            : GestureDetector(
                                                  onTap: (){
                                                    removeInsurance(medicalData['insurance'][index], index);
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
                                                  SizedBox(height: 5),
                                                  Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          height: 10,
                                                          width: 1,
                                                          color: selectedColor,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          "ID Number - ${medicalData['insurance'][index]['id_number']}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow .ellipsis,
                                                          textAlign:TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color(0xff777D82),
                                                              fontSize: 12,
                                                              fontFamily:"quicksand",
                                                              fontWeight:FontWeight.w400),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Plan Name",
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
                                                "${medicalData['insurance'][index]['plan_name']}",
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
                              isMedicalEdit
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
                              isMedicalEdit
                                  ? Container()
                                  : Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "ID Number",
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
                                                "${medicalData['insurance'][index]['id_number']}",
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        "Rx BIN",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xff777D82),
                                            fontSize: 14,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: Container(
                                    //     margin: EdgeInsets.only(left: 50),
                                    //     child: Text(
                                    //       "${insuranceList[index]['rx_bn']}",
                                    //       textAlign: TextAlign.end,
                                    //       style: TextStyle(
                                    //           color: Color(0xff23272A),
                                    //           fontSize: 14,
                                    //           fontFamily: "quicksand",
                                    //           fontWeight: FontWeight.w400),
                                    //     ),
                                    //   ),
                                    // ),
                                    Flexible(
                                      child: Container(
                                                  margin: EdgeInsets.only(left: 7),
                                                  child: TextField(
                                                    readOnly: isMedicalEdit ? false : true,
                                                    maxLines: null,
                                                    keyboardType: TextInputType.number,
                                                    onChanged: (value){
                                                      if(value == ""){
                                                              setState(() {
                                                             medicalData['insurance'][index]['rx_bin'] = medicaInsuranceList[index]['rx_bin'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                             medicalData['insurance'][index]['rx_bin'] = value;
                                                          });
                                                            }
                                                    },
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      color: Color(0xff777D82),
                                                      fontSize: 14,
                                                      fontFamily: "quicksand",
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    cursorColor: selectedColor,
                                                    decoration: InputDecoration(
                                                      hintText: medicalData['insurance'][index]['rx_bin'] == null ? "" : "${medicalData['insurance'][index]['rx_bin']}",
                                                      isDense: true,
                                                      contentPadding: null,
                                                      focusedBorder: isMedicalEdit
                                                          ? UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: selectedColor,
                                                              ),
                                                            )
                                                          : InputBorder.none,
                                                      border: isMedicalEdit
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        "Rx Group",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xff777D82),
                                            fontSize: 14,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: Container(
                                    //     margin: EdgeInsets.only(left: 50),
                                    //     child: Text(
                                    //       "${insuranceList[index]['rx_grp']}",
                                    //       textAlign: TextAlign.end,
                                    //       style: TextStyle(
                                    //           color: Color(0xff23272A),
                                    //           fontSize: 14,
                                    //           fontFamily: "quicksand",
                                    //           fontWeight: FontWeight.w400),
                                    //     ),
                                    //   ),
                                    // ),
                                    Flexible(
                                      child: Container(
                                                  margin: EdgeInsets.only(left: 7),
                                                  child: TextField(
                                                    readOnly: isMedicalEdit ? false : true,
                                                    maxLines: null,
                                                    keyboardType: TextInputType.number,
                                                    onChanged: (value){
                                                      if(value == ""){
                                                              setState(() {
                                                             medicalData['insurance'][index]['rx_group'] = medicaInsuranceList[index]['rx_group'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                             medicalData['insurance'][index]['rx_group'] = value;
                                                          });
                                                            }
                                                    },
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      color: Color(0xff777D82),
                                                      fontSize: 14,
                                                      fontFamily: "quicksand",
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    cursorColor: selectedColor,
                                                    decoration: InputDecoration(
                                                     hintText: medicalData['insurance'][index]['rx_group'] == null ? "" : "${medicalData['insurance'][index]['rx_group']}",
                                                      isDense: true,
                                                      contentPadding: null,
                                                      focusedBorder: isMedicalEdit
                                                          ? UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: selectedColor,
                                                              ),
                                                            )
                                                          : InputBorder.none,
                                                      border: isMedicalEdit
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        "Rx PCN",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xff777D82),
                                            fontSize: 14,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: Container(
                                    //     margin: EdgeInsets.only(left: 50),
                                    //     child: Text(
                                    //       "${insuranceList[index]['rx_pcn']}",
                                    //       textAlign: TextAlign.end,
                                    //       style: TextStyle(
                                    //           color: Color(0xff23272A),
                                    //           fontSize: 14,
                                    //           fontFamily: "quicksand",
                                    //           fontWeight: FontWeight.w400),
                                    //     ),
                                    //   ),
                                    // ),
                                    Flexible(
                                      child: Container(
                                                  margin: EdgeInsets.only(left: 7),
                                                  child: TextField(
                                                    readOnly: isMedicalEdit ? false : true,
                                                    maxLines: null,
                                                    keyboardType: TextInputType.number,
                                                    onChanged: (value){
                                                      if(value == ""){
                                                              setState(() {
                                                             medicalData['insurance'][index]['rx_pcn'] = medicaInsuranceList[index]['rx_pcn'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                             medicalData['insurance'][index]['rx_pcn'] = value;
                                                          });
                                                            }
                                                    },
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      color: Color(0xff777D82),
                                                      fontSize: 14,
                                                      fontFamily: "quicksand",
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    cursorColor: selectedColor,
                                                    decoration: InputDecoration(
                                                     hintText: medicalData['insurance'][index]['rx_pcn'] == null ? "" : "${medicalData['insurance'][index]['rx_pcn']}",
                                                      isDense: true,
                                                      contentPadding: null,
                                                      focusedBorder: isMedicalEdit
                                                          ? UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: selectedColor,
                                                              ),
                                                            )
                                                          : InputBorder.none,
                                                      border: isMedicalEdit
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        "Insurance Phone Number",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xff777D82),
                                            fontSize: 14,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: Container(
                                    //     margin: EdgeInsets.only(left: 50),
                                    //     child: Text(
                                    //       "${insuranceList[index]['phone']}",
                                    //       textAlign: TextAlign.end,
                                    //       style: TextStyle(
                                    //           color: Color(0xff23272A),
                                    //           fontSize: 14,
                                    //           fontFamily: "quicksand",
                                    //           fontWeight: FontWeight.w400),
                                    //     ),
                                    //   ),
                                    // ),
                                    Flexible(
                                      child: Container(
                                                  margin: EdgeInsets.only(left: 7),
                                                  child: TextField(
                                                    readOnly: isMedicalEdit ? false : true,
                                                    maxLines: null,
                                                    keyboardType: TextInputType.number,
                                                    onChanged: (value){
                                                      if(value == ""){
                                                              setState(() {
                                                             medicalData['insurance'][index]['phone_number'] = medicaInsuranceList[index]['phone_number'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                             medicalData['insurance'][index]['phone_number'] = value;
                                                          });
                                                            }
                                                    },
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      color: Color(0xff777D82),
                                                      fontSize: 14,
                                                      fontFamily: "quicksand",
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    cursorColor: selectedColor,
                                                    decoration: InputDecoration(
                                                     hintText: medicalData['insurance'][index]['phone_number'] == null ? "" : "${medicalData['insurance'][index]['phone_number']}",
                                                      isDense: true,
                                                      contentPadding: null,
                                                      focusedBorder: isMedicalEdit
                                                          ? UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: selectedColor,
                                                              ),
                                                            )
                                                          : InputBorder.none,
                                                      border: isMedicalEdit
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
                                    Text(
                                      "Attachment",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xff777D82),
                                          fontSize: 14,
                                          fontFamily: "quicksand",
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(bottom: 0, top: 15),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        physics: BouncingScrollPhysics(),
                                        child: Wrap(
                                          children: [
                                            ////////////////////////// Front Pic Start ///////////////////////
                                            GestureDetector(
                                              onTap: () {
                                               isMedicalEdit ? _showUploadDocDialog('front', medicalData['insurance'][index], index) :
                                                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => FullScreenImage( medicalData['insurance'][index]['front_photo']['url'])));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 0, right: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 82,
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          color:Color(0xffECF0F3),
                                                          borderRadius: BorderRadius.circular(5)),
                                                          child: medicalData['insurance'][index]['front_photo'] == null || medicalData['insurance'][index]['front_photo']['url'] == null ?
                                                           Container() :
                                                          // medicalData['insurance'][index]['front_photo']['url'] == null ?
                                                          // Container() :
                                                          // Hero(
                                                          //   tag: '${medicalData['insurance'][index]['front_photo']['url']}',
                                                          //   child:
                                                             Image.network(
                                                                    CallApi().fileShowlurl +
                                                                    '${medicalData['insurance'][index]['front_photo']['url']}',
                                                                    fit: BoxFit.contain,
                                                                    loadingBuilder: (context, child, progress){
                                                                      return progress == null ?
                                                                      child : LinearProgressIndicator();
                                                                    },
                                                                    ),
                                                         // ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Container(
                                                      child: Text(
                                                        "Front photo",
                                                        style: TextStyle(
                                                            color: Color(0xff354D5B),
                                                            fontFamily:"quicksand",
                                                            fontSize: 9,
                                                            fontWeight:FontWeight.w400),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            ////////////////////////// Front Pic End ///////////////////////
                                            

                                            ////////////////////////// Back Pic Start ///////////////////////
                                            GestureDetector(
                                              onTap: () {
                                               isMedicalEdit ? _showUploadDocDialog('back', medicalData['insurance'][index], index) : 
                                                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => FullScreenImage( medicalData['insurance'][index]['back_photo']['url'])));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 0, right: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 82,
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          color:Color(0xffECF0F3),
                                                          borderRadius: BorderRadius.circular(5)),
                                                           child: 
                                                           medicalData['insurance'][index]['back_photo'] == null || medicalData['insurance'][index]['back_photo']['url'] == null ?
                                                           Container() :
                                                          //  medicalData['insurance'][index]['back_photo']['url'] == null ?
                                                          // Container() :
                                                          // Hero(
                                                          //   tag: '${medicalData['insurance'][index]['back_photo']['url']}',
                                                          //  child: 
                                                            Image.network(
                                                                    CallApi().fileShowlurl +
                                                                    '${medicalData['insurance'][index]['back_photo']['url']}',
                                                                    fit: BoxFit.contain,
                                                                    loadingBuilder: (context, child, progress){
                                                                      return progress == null ?
                                                                      child : LinearProgressIndicator();
                                                                    },
                                                                    ),
                                                        //  ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Container(
                                                      child: Text(
                                                        "Back photo",
                                                        style: TextStyle(
                                                            color: Color(0xff354D5B),
                                                            fontFamily:"quicksand",
                                                            fontSize: 9,
                                                            fontWeight:FontWeight.w400),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            ////////////////////////// Back Pic End ///////////////////////
                                          ]
                                          ),
                                        ),
                                      ),
                                    
                                  ],
                                ),
                              ),
                              medicalData['insurance'].length - 1 == index
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
                                        thickness: 0.6,
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
                  //////////////////// insuranceList list End  /////////////////////////
                ],
              ),
            ),


//////////////////// Immunization Start /////////////////////////
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
                          "Immunizations",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 14,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        isMedicalEdit == false
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddImmunizationsScreen()));
                                },
                                child: Text(
                                  "+ Add Immunization",
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

                  //////////////////// immunizationList list start /////////////////////////
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Column(
                        children:
                            List.generate(medicalData['Immunization'].length, (index) {
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
                                padding: EdgeInsets.only(left: 0, right: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                      child: Text(
                                                        "${medicalData['Immunization'][index]['title']}",
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
                                                        top: 5, right: 10),
                                                    child: Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons
                                                                .calendar_today,
                                                            size: 15,
                                                            color: mainColor,
                                                          ),
                                                          SizedBox(width: 3),
                                                          Text(
                                                            "${DateFormat("dd-MM-yyyy").format(DateTime.parse(medicalData['Immunization'][index]['date']))}",
                                                            
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color:
                                                                    mainColor,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    "quicksand",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                      child: Text(
                                                        "${medicalData['Immunization'][index]['description']}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            color: mainColor,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                "quicksand",
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                  ),
                                                  isMedicalEdit == false
                                                      ? Container()
                                                      : GestureDetector(
                                                  onTap: (){
                                                    removeImmunization(medicalData['Immunization'][index], index);
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
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              medicalData['Immunization'].length - 1 == index
                                  ? Container()
                                  : Container(
                                      //height: 15,
                                      margin: EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          top: 15,
                                          bottom: 10),
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
                  //////////////////// immunizationList list End /////////////////////////
                  
                ],
              ),
            ),

 //////////////////// Condition Start /////////////////////////
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
                          "Conditions",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 14,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        isMedicalEdit == false
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddMedicalConditionsScreen()));
                                },
                                child: Text(
                                  "+ Add Conditions",
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

                  //////////////////// consitionList start /////////////////////////
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Column(
                        children: List.generate(medicalData['PhysicalCondition'].length, (index) {
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
                                padding: EdgeInsets.only(left: 0, right: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                      child: Text(
                                                        "${medicalData['PhysicalCondition'][index]['title']}",
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
                                                        top: 5, right: 10),
                                                    child: Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons
                                                                .calendar_today,
                                                            size: 15,
                                                            color: mainColor,
                                                          ),
                                                          SizedBox(width: 3),
                                                          Text(
                                                            "${DateFormat("dd-MM-yyyy").format(DateTime.parse(medicalData['PhysicalCondition'][index]['date']))}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color:
                                                                    mainColor,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    "quicksand",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                      child: Text(
                                                        "${medicalData['PhysicalCondition'][index]['description']}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            color: mainColor,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                "quicksand",
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                  ),
                                                  isMedicalEdit == false
                                                      ? Container()
                                                      : GestureDetector(
                                                  onTap: (){
                                                    removeCondition(medicalData['PhysicalCondition'][index], index);
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
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              medicalData['PhysicalCondition'].length - 1 == index
                                  ? Container()
                                  : Container(
                                      //height: 15,
                                      margin: EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          top: 15,
                                          bottom: 10),
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
                  //////////////////// consitionList End /////////////////////////
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


  


//////////////////////Save MedicalDAta Start////////////////////////
   Future<void> _saveMedicalData() async {
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

////no need this part //////
      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // var userJson = localStorage.getString('user');
      // var userData = json.decode(userJson);
////no need this part //////

      var data = {
                 "case_general_id": widget.caseId,
                 "user_id": user['id'],
                 "doctors": doctorList,
                  "medicins": medicationList,
                   "allergies": allergyList,
                  "insurance": medicaInsuranceList,
                  "immunizations": immunizationList,
                  "conditions": conditionList
                };

        print(data);
// setState(() {
//       isLoading = false;
//     });
// return;


      var res = await CallApi().postData(data, 'post_case_medical');
      var body = json.decode(res.body);
      print(body);
    
  if (res.statusCode == 400 ) {
      print("Something went wrong(400)");
      _errorDialog("Something went wrong!");
      setState(() {
          isLoading = false;
          isMedicalEdit = false;
        }); 
    }
    else if (res.statusCode == 200) {
      setState(() {
          doctorList = []; ///////////// have to fill it after getting response
          conditionList = []; ///////////// have to fill it after getting response
          immunizationList = []; ///////////// have to fill it after getting response
          allergyList = []; ///////////// have to fill it after getting response
          medicationList = []; ///////////// have to fill it after getting response
          medicaInsuranceList = []; ///////////// have to fill it after getting response
        }); 
      //////////////////// All work here////////////////////
       store.dispatch(MedicalInfoAction(body)); // update data in store...
       
       //print(store.state.biographicalInfoState);
       if (!mounted) return;
       setState(() {
         medicalData = store.state.medicalInfoState;
       });
       print(medicalData);

       for (var x in medicalData['doctor']) {
        doctorList.add({
          'id' : x['id'],
          'name' : x['name'],
          'address': x['address'],
          'phone_number': x['phone_number'],
          'profile_picture': x['profile_picture'],
          'department': x['department'],
          });
      }

      for (var x in medicalData['Immunization']) {
        immunizationList.add({
          'id' : x['id'],
          'title' : x['title'],
          'description': x['description'],
          'date': x['date'],
          });
      }

      for (var x in medicalData['PhysicalCondition']) {
        conditionList.add({
          'title' : x['title'],
          'id' : x['id'],
          //'type': x['type'],
          'description': x['description'],
          'date': x['date'],
          });
      }

      for (var x in medicalData['Allergy']) {
        allergyList.add({
          'id' : x['id'],
          'allergy_type' : x['allergy_type'],
          'symptoms': x['symptoms'],
          'severity': x['severity']
          });
      }


      for (var x in medicalData['Medication']) {
        medicationList.add({
          'id' : x['id'],
          'medicin_name' : x['medicin_name'],
          'power': x['power'],
          'taking_method': x['taking_method'],
          'cause': x['cause'],
          'doctor_id': x['doctor_id'],
          'time': x['medicin_taking_time'].map((obj) => obj['time']).toList(),
          });
      }

      for (var x in medicalData['insurance']) {
        medicaInsuranceList.add({
          'id' : x['id'],
          'plan_name' : x['plan_name'],
          'id_number': x['id_number'],
          'rx_bin': x['rx_bin'],
          'rx_group': x['rx_group'],
          'rx_pcn': x['rx_pcn'],
          'phone_number': x['phone_number'],
          'Front_Photo': x['Front_Photo'],
          'Back_Photo': x['Back_Photo'], 
          });
      }

    setState(() {
      isMedicalEdit = false;
      isLoading = false;
      });
      //////////////////// All work here////////////////////
      
    }
    else{
      print("Api o Problem rebo vai");
      _errorDialog("Something went wrong!");
      setState(() {
        isMedicalEdit = false;
          isLoading = false;
        });

   }

  // setState(() {
  //   isMedicalEdit = false;
  //   isLoading = false;
  //   // doctorList = []; ///////////// have to fill it after getting response
  //   // conditionList = []; ///////////// have to fill it after getting response
  //   // immunizationList = []; ///////////// have to fill it after getting response
  //   // allergyList = []; ///////////// have to fill it after getting response
  //   // medicationList = []; ///////////// have to fill it after getting response
  //   // medicaInsuranceList = []; ///////////// have to fill it after getting response
  // });
  
  }
/////////////////////Save MedicalDAta End ////////////////////////


 /////////////////////// Remove Doctor ///////////////////
  void removeDoctor(caseDoctor, index) async{

    //print(index);

    for(var b in medicalData['doctor']){
      if(b['name'] == caseDoctor['name'] && b['phone_number'] == caseDoctor['phone_number']){
        //print(b);
       // _errorDialog("lalalala");
        store.state.medicalInfoState['doctor'].remove(b);
        store.dispatch(MedicalInfoAction(store.state.medicalInfoState));
        break;
      }
      else{
        print("hi hello");
      } 
    }
      for(var b in doctorList){
      if(b['name'] == caseDoctor['name'] && b['phone_number'] == caseDoctor['phone_number']){
        //print(b);
        doctorList.remove(b);
       // print(doctorList);
        break;
      }
      else{
        print("hi hello");
      } 
    }
    
  }
  /////////////////////// Remove Doctor ///////////////////
  

  /////////////////////// Remove Medicine ///////////////////
  void removeMedicine(caseMedicine, index) async{

    //print(index);

    for(var b in medicalData['Medication']){
      if(b['medicin_name'] == caseMedicine['medicin_name'] && b['power'] == caseMedicine['power']){
        //print(b);
       // _errorDialog("lalalala");
        store.state.medicalInfoState['Medication'].remove(b);
        store.dispatch(MedicalInfoAction(store.state.medicalInfoState));
        break;
      }
      else{
        print("hi hello");
      } 
    }
      for(var b in medicationList){
      if(b['medicin_name'] == caseMedicine['medicin_name'] && b['power'] == caseMedicine['power']){
        //print(b);
        medicationList.remove(b);
        print(medicationList);
        break;
      }
      else{
        print("hi hello2");
      } 
    }
    
  }
  /////////////////////// Remove Medicine ///////////////////
  

  /////////////////////// Remove Allergies ///////////////////
  void removeAllergie(caseAllergy, index) async{

    //print(index);

    for(var b in medicalData['Allergy']){
      if(b['allergy_type'] == caseAllergy['allergy_type'] && b['symptoms'] == caseAllergy['symptoms']){
        //print(b);
       // _errorDialog("lalalala");
        store.state.medicalInfoState['Allergy'].remove(b);
        store.dispatch(MedicalInfoAction(store.state.medicalInfoState));
        break;
      }
      else{
        print("hi hello");
      } 
    }
      for(var b in allergyList){
      if(b['allergy_type'] == caseAllergy['allergy_type'] && b['symptoms'] == caseAllergy['symptoms']){
        //print(b);
        allergyList.remove(b);
        print(allergyList);
        break;
      }
      else{
        print("hi hello2");
      } 
    }
    
  }
  /////////////////////// Remove Allergies ///////////////////
  

  /////////////////////// Remove Allergies ///////////////////
  void removeImmunization(caseImmunization, index) async{

    //print(index);

    for(var b in medicalData['Immunization']){
      if(b['title'] == caseImmunization['title'] && b['description'] == caseImmunization['description']){
        //print(b);
       // _errorDialog("lalalala");
        store.state.medicalInfoState['Immunization'].remove(b);
        store.dispatch(MedicalInfoAction(store.state.medicalInfoState));
        break;
      }
      else{
        print("hi hello");
      } 
    }
      for(var b in immunizationList){
      if(b['title'] == caseImmunization['title'] && b['description'] == caseImmunization['description']){
        //print(b);
        immunizationList.remove(b);
        print(immunizationList);
        break;
      }
      else{
        print("hi hello2");
      } 
    }
    
  }
  /////////////////////// Remove Allergies ///////////////////
  

  /////////////////////// Remove Allergies ///////////////////
  void removeCondition(caseCondition, index) async{

    //print(index);

    for(var b in medicalData['PhysicalCondition']){
      if(b['title'] == caseCondition['title'] && b['description'] == caseCondition['description']){
        //print(b);
       // _errorDialog("lalalala");
        store.state.medicalInfoState['PhysicalCondition'].remove(b);
        store.dispatch(MedicalInfoAction(store.state.medicalInfoState)); 
        break;
      }
      else{
        print("hi hello");
      } 
    }
      for(var b in conditionList){
      if(b['title'] == caseCondition['title'] && b['description'] == caseCondition['description']){
        //print(b);
        conditionList.remove(b);
        print(conditionList);
        break;
      }
      else{
        print("hi hello2");
      } 
    }
    
  }
  /////////////////////// Remove Allergies ///////////////////
 
 /////////////////////// Remove insurance ///////////////////
  void removeInsurance(caseInsurance, index) async{

    //print(index);

    for(var b in medicalData['insurance']){
      if(b['id_number'] == caseInsurance['id_number'] && b['rx_bin'] == caseInsurance['rx_bin']){
        //print(b);
       // _errorDialog("lalalala");
        store.state.medicalInfoState['insurance'].remove(b);
        store.dispatch(MedicalInfoAction(store.state.medicalInfoState));
        break;
      }
      else{
        print("hi hello");
      } 
    }
      for(var b in medicaInsuranceList){
      if(b['id_number'] == caseInsurance['id_number'] && b['rx_bin'] == caseInsurance['rx_bin']){
        //print(b);
        medicaInsuranceList.remove(b);
        print(medicaInsuranceList);
        break;
      }
      else{
        print("hi hello2");
      } 
    }
    
  }
  /////////////////////// Remove insurance ///////////////////
  

   ////////////////////////////////////////////////////////////////////// Upload Section /////////////////////////////////////////////////////////////////
  

  ///////////////////////////////////// _showUploadDocDialog /////////////////////////////////////////
  Future<Null> _showUploadDocDialog(title, insuranceData, index) async {
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
                                                 // path == '' ? "" :
                                                  "Item Selected",
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
                                             isFileUploading ? null : _uploadFile(title, insuranceData, index);
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
                                                child: Text( isFileUploading ? "Adding..." :"+ Add",
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
      allowedExtensions: ['png', 'jpg', 'jpeg', 'PNG']
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
  
  Future<void> _uploadFile(title, insuranceData, index) async {

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
        });
      refresh(title, insuranceData, index);
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

  }
  /////////////////////// Upload File //////////////////


  
  //////////////////////Refresh ////////////////////////
  void refresh(title, insuranceData, index) {
    if(title == 'front'){
      setState(() {
        isDocumentPressed = false;
        var data = {
         'id': 0,
         'pic_type' : "Front_Photo",
        // 'doc_name': "${file.path.split('/').last}",
         'url': uploadedDocData['pic'],
         'url_type': uploadedDocData['type'],
         'extension': uploadedDocData['extension'],
        };
        // "url": "/uploads/4KXa6XXgXVs6MCX9UfJ5hvlJ30JUheN0jOZMScsi.png",
        print(data);

        for(var b in medicalData['insurance']){
      if(b['id_number'] == insuranceData['id_number'] && b['plan_name'] == insuranceData['plan_name']){
        //print(b);
       // _errorDialog("lalalala");
        store.state.medicalInfoState['insurance'][index]['front_photo'] = data;
        store.dispatch(MedicalInfoAction(store.state.medicalInfoState));
        break;
      }
      else{
        print("hi hello");
      } 
    }
      for(var b in medicaInsuranceList){
      if(b['id_number'] == insuranceData['id_number'] && b['plan_name'] == insuranceData['plan_name']){
        //print(b);
        medicaInsuranceList[index]['Front_Photo'] = data;
        print(medicaInsuranceList);
        break;
      }else{
        print("hi hello2");
      } 

      }
        path = "";
        isDocItemPressed = false;
      
      });
    }

    ////////////////////////// Back pic //////////////////////
    else{
      setState(() {
        isDocumentPressed = false;
        var backData = {
         'id': 0,
         'pic_type' : "Back_Photo",
        // 'doc_name': "${file.path.split('/').last}",
         'url': uploadedDocData['pic'],
         'url_type': uploadedDocData['type'],
         'extension': uploadedDocData['extension'],
        };

      for(var b in medicalData['insurance']){
      if(b['id_number'] == insuranceData['id_number'] && b['plan_name'] == insuranceData['plan_name']){
        //print(b);
       // _errorDialog("lalalala");
        store.state.medicalInfoState['insurance'][index]['back_photo'] = backData;
        store.dispatch(MedicalInfoAction(store.state.medicalInfoState));
        break;
      }
      else{
        print("hi hello");
      } 
    }
      for(var b in medicaInsuranceList){
      if(b['id_number'] == insuranceData['id_number'] && b['plan_name'] == insuranceData['plan_name']){
        //print(b);
        medicaInsuranceList[index]['Back_Photo'] = backData;
        //print(medicaInsuranceList);
        break;
      }else{
        print("hi hello2");
      } 

      }
        path = "";
        isDocItemPressed = false;
      });
    }
  }
  //////////////////////Refresh ////////////////////////
  ////////////////////////////////////////////////////////////////////// Upload Section /////////////////////////////////////////////////////////////////


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
