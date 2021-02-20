import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:homewardbase/screens/ProfileBioPage/ProfileBioPage.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/BioCommonWidgets/BioCommonWidgets.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioUpdatePages/updateDentalCareProviders.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioUpdatePages/updateDentalConditionsScreen.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/addDentalCareProviders.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/addDentalConditionsScreen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';

class DentalPage extends StatefulWidget {
  final caseId;
  DentalPage(this.caseId);
  @override
  _DentalPageState createState() => _DentalPageState();
}

class _DentalPageState extends State<DentalPage> {

  bool isLoading = true;
  bool noData = false;

  var dentalData;
  var caseLog;
  var user;

  

  bool isDentalEdit = false;
 

 @override
  void initState() {
    super.initState();
    _getMedicalData();
  }


  Future <void>_getMedicalData() async {

    setState(() {
      isLoading = true;
      dentalDocList = []; ///////////// have to fill it after getting response
      dentalConsitionList = []; ///////////// have to fill it after getting response
    });

   SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    user = json.decode(userJson);
    //print(user);

   
    var res = await CallApi().getData('get_dental_details/${widget.caseId}');
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

       store.dispatch(DentalInfoAction(body)); // update data in store...
       
       //print(store.state.biographicalInfoState);
       if (!mounted) return;
       setState(() {
         dentalData = store.state.dentalInfoState;
         caseLog = store.state.commonLogInfoState;
       });
       print(dentalData);

       for (var x in dentalData['doctor']) {
        dentalDocList.add({
          'id' : x['id'],
          'name' : x['name'],
          'address': x['address'],
          'phone_number': x['phone_number'],
          'profile_picture': x['profile_picture'],
          'department': x['department'],
          });
      }

      for (var x in dentalData['PhysicalCondition']) {
        dentalConsitionList.add({
          'id' : x['id'],
          'title' : x['title'],
          //'type': x['type'],
          'description': x['description'],
          'date': x['date'],
          });
      }

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
      onRefresh: _getMedicalData,
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
                          "Dental",
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
                            isDentalEdit == false
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isDentalEdit = false;
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
                                  if (isDentalEdit) {
                                    _saveDentalData();
                                  } else {
                                    isDentalEdit = true;
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
                                      isDentalEdit == false
                                          ? Icon(Icons.edit,
                                              size: 11, color: Colors.white)
                                          : Container(),
                                      Text(
                                        isDentalEdit == false ? " Edit" : "Save",
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
                              "Dental Care Providers",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 14,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w500),
                            ),
                            isDentalEdit == false
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddDentalCareProviders())); 
                                    },
                                    child: Text(
                                      "+ Add Dental Care Providers",
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
                      Container(
                        margin: EdgeInsets.only(top: 0),
                        child: Column(
                            children: List.generate(dentalData['doctor'].length, (index) {
                          return Container(
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
                                                    "assets/image/teeth.png",
                                                    color: Colors.white,
                                                     fit: BoxFit.cover
                                                    ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                              isDentalEdit == false ? null :
                                               Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateDentalCareProviders(dentalData['doctor'][index], index))).then((value) {
                                                 setState(() {});
                                               });
                                            },
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
                                                            "${dentalData['doctor'][index]['name']}",
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
                                                          "${dentalData['doctor'][index]['department']}",
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
                                                            "${dentalData['doctor'][index]['address']}",
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
                                                        size: 14,
                                                        color: mainColor,
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(left: 2),
                                                        child: Text(
                                                          "${dentalData['doctor'][index]['phone_number']}",
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
                                      ),
                                      isDentalEdit == false
                                          ? Container()
                                          : GestureDetector(
                                                    onTap: (){
                                                     removeDentalDoctor(dentalData['doctor'][index], index);
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
                                dentalData['doctor'].length - 1 == index
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
                          );
                        })),
                      ),
                    ],
                  ),
                ),
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
                            isDentalEdit == false
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddDentalConditionScreen()));
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
                      Container(
                        margin: EdgeInsets.only(top: 0),
                        child: Column(
                            children: List.generate(dentalData['PhysicalCondition'].length, (index) {
                          return GestureDetector(
                            onTap: () {
                                              isDentalEdit == false ? null :
                                               Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateDentalConditionScreen(dentalData['PhysicalCondition'][index], index))).then((value) {
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
                                                            "${dentalData['PhysicalCondition'][index]['title']}",
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
                                                                "${DateFormat("MM-dd-yyyy").format(DateTime.parse(dentalData['PhysicalCondition'][index]['date']))}",
                                                                //"${DateFormat("dd-MM-yyyy").format(DateTime.parse(dentalData['PhysicalCondition'][index]['date']))}",
                                                                //"${dentalData['PhysicalCondition'][index]['date']}",
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
                                                            "${dentalData['PhysicalCondition'][index]['description']}",
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
                                                      isDentalEdit == false
                                                          ? Container()
                                                          : GestureDetector(
                                                      onTap: (){
                                                        removeDentalCondition(dentalData['PhysicalCondition'][index], index);
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
                                  dentalData['PhysicalCondition'].length - 1 == index
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
                    ],
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



  //////////////////////Save DentalDAta Start////////////////////////
   Future<void> _saveDentalData() async {
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
                "dentist": dentalDocList,
                "physical_conditions": dentalConsitionList
                };

        print(data);




  
   var res = await CallApi().postData(data, 'post_dental');
       var body = json.decode(res.body);
       print(body);
    
   if(body['status'] == 'Token is Expired'){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
      else if (res.statusCode != 200) {

     _errorDialog("Something went wrong!");
      setState(() {
      isDentalEdit = false;
      isLoading = false;
      });
    }
    else if (res.statusCode == 200) {
      setState(() {
       dentalDocList = []; ///////////// have to fill it after getting response
       dentalConsitionList = []; ///////////// have to fill it after getting response
      });
        
       store.dispatch(DentalInfoAction(body)); // update data in store...
       
       //print(store.state.biographicalInfoState);
       if (!mounted) return;
       setState(() {
         dentalData = store.state.dentalInfoState;
         caseLog = store.state.commonLogInfoState;
       });
       print(dentalData);

       for (var x in dentalData['doctor']) {
        dentalDocList.add({
          'id' : x['id'],
          'name' : x['name'],
          'address': x['address'],
          'phone_number': x['phone_number'],
          'profile_picture': x['profile_picture'],
          'department': x['department'],
          });
      }

      for (var x in dentalData['PhysicalCondition']) {
        dentalConsitionList.add({
          'id' : x['id'],
          'title' : x['title'],
          //'type': x['type'],
          'description': x['description'],
          'date': x['date'],
          });
      }

    setState(() {
      isDentalEdit = false;
      isLoading = false;
      });
    }
    else if (res.statusCode == 400) {
      _errorDialog("Something went wrong!");
      setState(() {
      noData = true;
      isDentalEdit = false;
      isLoading = false;
      });
    }
    
    else{
      _errorDialog("Something went wrong!");
      setState(() {
      isDentalEdit = false;
      isLoading = false;
      });
    }

  // setState(() {
  //   isDentalEdit = false;
  //   isLoading = false;
  //   dentalDocList = []; ///////////// have to fill it after getting response
  //   dentalConsitionList = []; ///////////// have to fill it after getting response
  // });
  
  }
/////////////////////Save DentalDAta End ////////////////////////


/////////////////////// Remove Doctor ///////////////////
  void removeDentalDoctor(caseDentalDoc, index) async{

    //print(index);

    for(var b in dentalData['doctor']){
      if(b['name'] == caseDentalDoc['name'] && b['phone_number'] == caseDentalDoc['phone_number']){
        //print(b);
       // _errorDialog("lalalala");
        store.state.dentalInfoState['doctor'].remove(b);
        store.dispatch(DentalInfoAction(store.state.dentalInfoState));
        break;
      }
      else{
        print("hi hello");
      } 
    }
      for(var b in dentalDocList){
      if(b['name'] == caseDentalDoc['name'] && b['phone_number'] == caseDentalDoc['phone_number']){
        //print(b);
        dentalDocList.remove(b);
        print(dentalDocList);
        break;
      }
      else{
        print("hi hello2");
      } 
    }
    
  }
  /////////////////////// Remove Doctor ///////////////////
  

  /////////////////////// Remove Allergies ///////////////////
  void removeDentalCondition(caseDentalCondition, index) async{

    //print(index);

    for(var b in dentalData['PhysicalCondition']){
      if(b['title'] == caseDentalCondition['title'] && b['description'] == caseDentalCondition['description']){
        //print(b);
       // _errorDialog("lalalala");
        store.state.dentalInfoState['PhysicalCondition'].remove(b);
        store.dispatch(DentalInfoAction(store.state.dentalInfoState));
        break;
      }
      else{
        print("hi hello");
      } 
    }
      for(var b in dentalConsitionList){
      if(b['title'] == caseDentalCondition['title'] && b['description'] == caseDentalCondition['description']){
        //print(b);
        dentalConsitionList.remove(b);
        print(dentalConsitionList);
        break;
      }
      else{
        print("hi hello2");
      } 
    }
    
  }
  /////////////////////// Remove Allergies ///////////////////
  


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
