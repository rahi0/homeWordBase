import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:homewardbase/screens/ProfileBioPage/ProfileBioPage.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/BioCommonWidgets/BioCommonWidgets.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioUpdatePages/updateSchoolScreen.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/BiographicalProfilePage/ProfileBioWidgets/addSchoolScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';

class EducationPage extends StatefulWidget {
  final caseId;
  EducationPage(this.caseId);
  @override
  _EducationPageState createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {

  bool isLoading = true;
  bool noData = false;

  var educationData;
  var caseLog;
  var user;

  bool isEducationEdit = false;


   @override
  void initState() {
    super.initState();
    _getMedicalData();
  }


  Future <void>_getMedicalData() async {

    setState(() {
      isLoading = true;
      educationList = []; ///////////// have to fill it after getting response
    });

   SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    user = json.decode(userJson);
    //print(user);

   
    var res = await CallApi().getData('get_education_details/${widget.caseId}');
    final body = json.decode(res.body);
    //var homePageData;
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

       store.dispatch(EducationInfoAction(body)); // update data in store...
       
       //print(store.state.biographicalInfoState);
       if (!mounted) return;
       setState(() {
         educationData = store.state.educationInfoState;
         caseLog = store.state.commonLogInfoState;
       });
      // print(educationData);

       for (var x in educationData['education']) {
        educationList.add({
          'id' : x['id'],
          'school_name' : x['school_name'],
          'address': x['address'],
          'phone': x['phone'],
          'grade': x['grade'],
          'note': x['note'],
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
                        "Education",
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
                          isEducationEdit == false
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isEducationEdit = false;
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
                                if (isEducationEdit) {
                                  _saveEducationData();
                                } else {
                                  isEducationEdit = true;
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
                                    isEducationEdit == false
                                        ? Icon(Icons.edit,
                                            size: 11, color: Colors.white)
                                        : Container(),
                                    Text(
                                      isEducationEdit == false ? " Edit" : "Save",
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
                            "School",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: mainColor,
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w500),
                          ),
                          isEducationEdit == false
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddSchoolScreen()));
                                  },
                                  child: Text(
                                    "+ Add School",
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
                          children: List.generate(educationData['education'].length, (index) {
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
                                          color: Color(0xffE6FAF3),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      height: 33,
                                      width: 33,
                                      child: Image.asset(
                                          "assets/image/lesson2.png"),
                                    ),


                                    ////////////////////////////////////// Update Button ///////////////
                                    Expanded(
                                      child:  GestureDetector(
                                          onTap: () {
                                            isEducationEdit == false ? null :
                                             Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateSchoolScreen(educationData['education'][index], index))).then((value) {
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
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        child: Text(
                                                          "${educationData['education'][index]['school_name']}",
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
                                                    educationData['education'][index]['grade'] == null ?
                                                    Container() :
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
                                                        "${educationData['education'][index]['grade']}",
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
                                                          "${educationData['education'][index]['address']}",
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
                                                        "${educationData['education'][index]['phone']}",
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
                                    isEducationEdit == false
                                        ? Container()
                                        : GestureDetector(
                                                  onTap: (){
                                                    removeSchool(educationData['education'][index], index);
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 20, top: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Notes:",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                                    margin: EdgeInsets.only(
                                        left: 20, top: 5, right: 20),
                                    child: Row(
                                      children: <Widget>[
                                        isEducationEdit ?
                                              Flexible(
                                                child: Container(
                                                   // margin: EdgeInsets.only(left: 7),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                           if(value == ""){
                                                              setState(() {
                                                              educationList[index]['note'] = value;
                                                              educationData['education'][index]['note'] = educationList[index]['note'];
                                                          });
                                                            }else{
                                                              setState(() {
                                                              educationData['education'][index]['note'] = value;
                                                              educationList[index]['note'] = value;
                                                          });
                                                            }
                                                        },
                                                      readOnly: isEducationEdit ? false : true,
                                                      maxLines: null,
                                                      keyboardType: TextInputType.text,
                                                      textCapitalization: TextCapitalization.sentences,
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
                                                        hintText: educationData['education'][index]['note'] == null ? "" : "${educationData['education'][index]['note']}",
                                                        focusedBorder: isEducationEdit
                                                            ? UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: selectedColor,
                                                                ),
                                                              )
                                                            : InputBorder.none,
                                                        border: isEducationEdit
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
                                           // margin: EdgeInsets.only(left: 20),
                                            child: Text(
                                              educationData['education'][index]['note'] == null ? "--" : "${educationData['education'][index]['note']}",
                                            //  "${educationData['education'][index]['note']}",
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Color(0xff777D82),
                                                  fontSize: 13,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              educationData['education'].length - 1 == index
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



              ////////////////////// Log Start ///////////////////////////////////////
              BioCommonLog(caseLog, user['id'])
              ////////////////////// Log End ////////////////////////////////////////
            ],
          ),
        ),
      )
      ),
    );
  }


  //////////////////////Save BioData Start////////////////////////
   Future<void> _saveEducationData() async {
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


      var data = {
                  "case_general_id": widget.caseId,
                  "user_id": user['id'],
                  "educations": educationList
                };
        print(data);




   var res = await CallApi().postData(data, 'post_Education');
       var body = json.decode(res.body);
       print(body);
    
   if(body['status'] == 'Token is Expired'){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
      else if (res.statusCode != 200) {

     _errorDialog("Something went wrong!");
      setState(() {
      isEducationEdit = false;
      isLoading = false;
      });
    }
    else if (res.statusCode == 200) {
      setState(() {
        educationList = []; ///////////// have to fill it after getting response
      });
        
        store.dispatch(EducationInfoAction(body)); // update data in store...
       
       //print(store.state.biographicalInfoState);
       if (!mounted) return;
       setState(() {
         educationData = store.state.educationInfoState;
       });
      // print(educationData);

       for (var x in educationData['education']) {
        educationList.add({
          'id' : x['id'],
          'school_name' : x['school_name'],
          'address': x['address'],
          'phone': x['phone'],
          'grade': x['grade'],
          'note': x['note'],
          });
      }

    setState(() {
      isEducationEdit = false;
      isLoading = false;
      });
    }
    else if (res.statusCode == 400) {
      _errorDialog("Something went wrong!");
      setState(() {
      noData = true;
      isEducationEdit = false;
      isLoading = false;
      });
    }
    
    else{
      _errorDialog("Something went wrong!");
      setState(() {
      isEducationEdit = false;
      isLoading = false;
      });
    }


  // setState(() {
  //   isEducationEdit = false;
  //   isLoading = false;
  //   educationList = []; ///////////// have to fill it after getting response
  // });
  
  }
/////////////////////Save BioData End////////////////////////



/////////////////////// Remove School ///////////////////
  void removeSchool(caseEducation, index) async{

    //print(index);

    for(var b in educationData['education']){
      if(b['school_name'] == caseEducation['school_name'] && b['phone'] == caseEducation['phone']){
        //print(b);
       // _errorDialog("lalalala");
        store.state.educationInfoState['education'].remove(b);
        store.dispatch(EducationInfoAction(store.state.educationInfoState));
        break;
      }
      else{
        print("hi hello");
      } 
    }
      for(var b in educationList){
      if(b['school_name'] == caseEducation['school_name'] && b['phone'] == caseEducation['phone']){
        //print(b);
        educationList.remove(b);
        print(educationList);
        break;
      }
      else{
        print("hi hello2");
      } 
    }
    
  }
  /////////////////////// Remove School ///////////////////
  

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
