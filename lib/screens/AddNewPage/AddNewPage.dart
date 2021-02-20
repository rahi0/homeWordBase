import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:homewardbase/screens/ProfileBioPage/ProfileBioPage.dart';
import 'package:homewardbase/screens/ProfileBioTabPages/ProfileEventPage/ProfileEventPage.dart';
import 'package:http/http.dart' as http;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/main.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/LogAddPeople/LogAddPeople.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewPage extends StatefulWidget {
  final caseId;
  AddNewPage(this.caseId);
  @override
  _AddNewPageState createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  bool isAddPeople = false;
  bool isAddAttachment = false;
  bool isLoading = false;
  String title = "", location = "", desc = "", type = "";

  

  ///////////////// for file /////////////
  bool isEditOpen = false;
  bool isDocAvailable = false;
  bool isDocumentPressed = false;
  bool isDocItemPressed = false;
  bool isFileUploading = false;

  var uploadedDocData;
  List documentList = [];

   String path = "", doc ='';
   File file;
  ///////////////// for file /////////////

  List<DropdownMenuItem<String>> _dropDownTypeItems;

  List typeState = [
    "Type",
    "Visit",
    "Biographical",
    "Medical",
    "Dental",
    "Therapy",
    "Education",
    "Legal",
  ];

  List<DropdownMenuItem<String>> getDropDownTypeItems() {
    ////////drop down button
    List<DropdownMenuItem<String>> items = new List();
    for (String typeList in typeState) {
      items.add(new DropdownMenuItem(
          value: typeList,
          child: new Text(
            typeList,
            textAlign: TextAlign.end,
            style: TextStyle(
                color: typeList == "Type"
                    ? Color(0xff354D5B).withOpacity(0.6)
                    : Color(0xff354D5B),
                fontSize: 14,
                fontFamily: 'quicksand',
                fontWeight: FontWeight.w400),
          )));
    }
    return items;
  }

  ///////////////////// Time Picker Essentials Start ///////////////////////
  String timeFrom = 'Time';
  String timeTo = 'Time';
  TimeOfDay time = TimeOfDay.now();

  Future<Null> _pickTime(BuildContext context, var timePut) async {
   TimeOfDay picked = await showTimePicker(
     builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: selectedColor,
              ),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        },
      context: context,
      initialTime: time
    );
    if(picked != null && picked != time)
      setState(() {
        time = picked; 
         timePut == 'timeFrom'
            ? timeFrom =
                MaterialLocalizations.of(context).formatTimeOfDay(time, alwaysUse24HourFormat: false)
            : timeTo = MaterialLocalizations.of(context).formatTimeOfDay(time, alwaysUse24HourFormat: false);
      });
  }
  ///////////////////// Time Picker Essentials End ///////////////////////
  

  ///////////////////// Date Picker Essentials Start ///////////////////////
  String dateFrom = 'Date';
  String dateTo = 'Date';
  DateTime selectedDateTo = DateTime.now();

  Future<Null> _selectDateTo(BuildContext context, var datePut) async {
    final DateTime picked = await showDatePicker(
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: selectedColor,
              ),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
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
        datePut == 'dateFrom'
            ? dateFrom =
                "${DateFormat("dd-MM-yyyy").format(selectedDateTo)}"
            : dateTo =
                "${DateFormat("dd-MM-yyyy").format(selectedDateTo)}";
      });
    }
  }
  ///////////////////// Date Picker Essentials End ///////////////////////

  @override
  void initState() {
    setState(() {
     // usersAtAppointment = [];
     store.state.appointmentAddPepState = []; // update data in store...
    // print(store.state.appointmentAddPepState);
    });
    super.initState();

    _dropDownTypeItems = getDropDownTypeItems();
    type = _dropDownTypeItems[0].value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(right: 0, left: 0),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Color(0xff7A98A9),
                        fontSize: 13,
                        fontFamily: "quicksand",
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    "Add New",
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
                padding: EdgeInsets.all(5),
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
        actions: <Widget>[],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, top: 25),
            child: Text(
              "Add New",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: mainColor,
                  fontFamily: "quicksand",
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.15),
                borderRadius: BorderRadius.circular(5)),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
              controller: titleController,
              autofocus: false,
              style: TextStyle(
                  color: Color(0xff354D5B),
                  fontSize: 15,
                  fontFamily: 'quicksand',
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(
                    color: Color(0xff354D5B),
                    fontSize: 14,
                    fontFamily: 'quicksand',
                    fontWeight: FontWeight.w400),
                // labelStyle: TextStyle(
                //     color: Color(0xff7A98A9),
                //     fontSize: 15,
                //     fontFamily: 'quicksand',
                //     fontWeight: FontWeight.w500),
                // labelText: "Old Password",
                contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.15),
                borderRadius: BorderRadius.circular(5)),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(
              top: 5,
              bottom: 5,
              right: 10,
              left: 15,
            ),
            child: DropdownButtonHideUnderline(
              child: Container(
                child: DropdownButton(
                  //icon: Icon(Icons.arrow_drop_down),
                  isExpanded: true,
                  // iconDisabledColor:
                  //     Color(0xFF008990),
                  iconEnabledColor: Color(0xff003A5B),
                  // iconSize: 40,

                  //hint: Text('Type'),
                  style: TextStyle(
                      color: Color(0xff354D5B),
                      fontSize: 14,
                      fontFamily: 'quicksand',
                      fontWeight: FontWeight.w400),
                  value: type,
                  items: _dropDownTypeItems,
                  icon: Icon(
                    Icons.expand_more,
                    size: 20,
                    color: Color(0xff003A5B),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      type = value;
                    });
                  },
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 10, top: 20),
            child: Text(
              "From",
              style: TextStyle(
                  color: Color(0xff354D5B),
                  fontSize: 14,
                  fontFamily: 'quicksand',
                  fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      _selectDateTo(context, "dateFrom");
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.15),
                            borderRadius: BorderRadius.circular(5)),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 20, right: 10, top: 10),
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, right: 10, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              dateFrom,
                              style: TextStyle(
                                  color: Color(0xff354D5B),
                                  fontSize: 14,
                                  fontFamily: 'quicksand',
                                  fontWeight: FontWeight.w400),
                            ),
                            Container(
                                child: Image.asset(
                              "assets/image/calendar1.png",
                              height: 17,
                              width: 17,
                            )),
                          ],
                        )),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                     onTap: (){
                      _pickTime(context, "timeFrom");
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.15),
                            borderRadius: BorderRadius.circular(5)),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 10, right: 20, top: 10),
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, right: 10, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              timeFrom,
                              style: TextStyle(
                                  color: Color(0xff354D5B),
                                  fontSize: 14,
                                  fontFamily: 'quicksand',
                                  fontWeight: FontWeight.w400),
                            ),
                            Container(
                                child: Image.asset(
                              "assets/image/time1.png",
                              height: 17,
                              width: 17,
                            )),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 10, top: 10),
            child: Text(
              "To",
              style: TextStyle(
                  color: Color(0xff354D5B),
                  fontSize: 14,
                  fontFamily: 'quicksand',
                  fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                     onTap: (){
                      _selectDateTo(context, "dateTo");
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.15),
                            borderRadius: BorderRadius.circular(5)),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 20, right: 10, top: 10),
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, right: 10, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              dateTo,
                              style: TextStyle(
                                  color: Color(0xff354D5B),
                                  fontSize: 14,
                                  fontFamily: 'quicksand',
                                  fontWeight: FontWeight.w400),
                            ),
                            Container(
                                child: Image.asset(
                              "assets/image/calendar1.png",
                              height: 17,
                              width: 17,
                            )),
                          ],
                        )),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                     onTap: (){
                      _pickTime(context, "timeTo");
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.15),
                            borderRadius: BorderRadius.circular(5)),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 10, right: 20, top: 10),
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, right: 10, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              timeTo,
                              style: TextStyle(
                                  color: Color(0xff354D5B),
                                  fontSize: 14,
                                  fontFamily: 'quicksand',
                                  fontWeight: FontWeight.w400),
                            ),
                            Container(
                                child: Image.asset(
                              "assets/image/time1.png",
                              height: 17,
                              width: 17,
                            )),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.15),
                borderRadius: BorderRadius.circular(5)),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  location = value;
                });
              },
              controller: locationController,
              autofocus: false,
              style: TextStyle(
                  color: Color(0xff354D5B),
                  fontSize: 15,
                  fontFamily: 'quicksand',
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: "Location",
                hintStyle: TextStyle(
                    color: Color(0xff354D5B),
                    fontSize: 14,
                    fontFamily: 'quicksand',
                    fontWeight: FontWeight.w400),
                // labelStyle: TextStyle(
                //     color: Color(0xff7A98A9),
                //     fontSize: 15,
                //     fontFamily: 'quicksand',
                //     fontWeight: FontWeight.w500),
                // labelText: "Old Password",
                contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.15),
                borderRadius: BorderRadius.circular(5)),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(top: 10, bottom: 5, right: 10),
            alignment: Alignment.topLeft,
            child: new ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 120.0, minHeight: 70),
              child: Column(
                children: <Widget>[
                  new SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    child: new TextField(
                      maxLines: null,
                      autofocus: false,
                      controller: descController,
                      decoration: InputDecoration(
                        hintText: "Description",
                        hintStyle: TextStyle(
                            color: Color(0xff354D5B),
                            fontSize: 14,
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w400),
                        contentPadding:
                            EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 15.0),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          desc = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Add People",
                  style: TextStyle(
                      color: Color(0xff354D5B),
                      fontSize: 14,
                      fontFamily: 'quicksand',
                      fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () {
                    // setState(() {
                    //   if (isAddPeople) {
                    //     isAddPeople = false;
                    //   } else {
                    //     isAddPeople = true;
                    //   }
                    // });

                  Navigator.push(context,MaterialPageRoute(builder:(context) => LogAddPeoplePage(widget.caseId) ));
                  },
                  child: Container(
                      child: Image.asset(
                    "assets/image/people.png",
                    //height: 17,
                    width: 53,
                  )),
                ),
              ],
            ),
          ),
          ///////////////////////////////////
         // isAddPeople == false
           store.state.appointmentAddPepState.length == 0
              ? Container()
              : Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                      children: List.generate(store.state.appointmentAddPepState.length, (index) {
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
                                children: <Widget>[
                                  store.state.appointmentAddPepState[index]['profile_picture'] == null
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: selectedColor,
                                      borderRadius: BorderRadius.circular(100)),
                                  height: 45,
                                  width: 45,
                                  margin: EdgeInsets.only(left: 20),
                                  child: Center(
                                      child: Text(
                                    "${store.state.appointmentAddPepState[index]['first_name'][0].toUpperCase()}${store.state.appointmentAddPepState[index]['last_name'][0].toUpperCase()}",
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
                                    margin: EdgeInsets.only(left: 20),
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/image/pm1.png"),
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
                                                      "${store.state.appointmentAddPepState[index]['first_name']} ${store.state.appointmentAddPepState[index]['last_name']}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: mainColor,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              "quicksand",
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
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    store.state.appointmentAddPepState[index]['user_type'] == null ? "" :
                                                    "${store.state.appointmentAddPepState[index]['user_type']}",
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
                                            store.state.appointmentAddPepState[index]['organization'] == null ? "" :
                                            "${store.state.appointmentAddPepState[index]['organization']}",
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
                                  GestureDetector(
                                        onTap: (){
                                         store.state.appointmentAddPepState.remove(store.state.appointmentAddPepState[index]);
                                         store.dispatch(AppointmentAddPepAction(store.state.appointmentAddPepState));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(right: 20),
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
                            store.state.appointmentAddPepState.length - 1 == index
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


                ////////////////////////////
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Add Attachment",
                  style: TextStyle(
                      color: Color(0xff354D5B),
                      fontSize: 14,
                      fontFamily: 'quicksand',
                      fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () {
                    _showUploadDocDialog();
                    // setState(() {
                    //   if (isAddAttachment) {
                    //     isAddAttachment = false;
                    //   } else {
                    //     isAddAttachment = true;
                    //   }
                    // });
                  },
                  child: Container(
                      child: Image.asset(
                    "assets/image/attachment.png",
                    //height: 17,
                    width: 53,
                  )),
                ),
              ],
            ),
          ),
          // isAddAttachment == false
          //     ? Container()
          //     :
               Container(
                  margin: EdgeInsets.only(bottom: 20, top: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Wrap(
                      children: List.generate(documentList.length, (index) {
                        return Container(
                          padding: EdgeInsets.only(left: 20, right: 5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 95,
                                  width: 105,
                                  alignment: Alignment.topRight,
                                  decoration: BoxDecoration(
                                      color: Color(0xffECF0F3),
                                      borderRadius: BorderRadius.circular(5),
                                      // image: DecorationImage(
                                      //   image: AssetImage(
                                      //     "assets/image/pdf.png"
                                      //   ), fit: BoxFit.cover
                                      //   )
                                       ),
                                  child: Stack(
                                    children: [
                                      documentList[index]['extension'] == "pdf" ?
                                      Container(
                                            padding: EdgeInsets.all(5),
                                            child: Image.asset(
                                              "assets/image/pdf.png",
                                              height: 95,
                                              width: 105,
                                            )) :

                                            Container(
                                            padding: EdgeInsets.all(5),
                                            height: 95,
                                            width: 105,
                                            child: Image.network(
                                                CallApi().fileShowlurl +
                                                '${documentList[index]['pic']}',
                                                fit: BoxFit.contain,
                                                loadingBuilder: (context, child, progress){
                                                return progress == null ?
                                                 child : LinearProgressIndicator();
                                                },
                                             )
                                            ),
                                      Positioned(
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              documentList.remove(documentList[index]);
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.all(5),
                                              child: Image.asset(
                                                "assets/image/close.png",
                                                //height: 17,
                                                width: 10,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  width: 105,
                                  child: Text(
                                    "${documentList[index]['doc_name']}",
                                    style: TextStyle(
                                        color: Color(0xff354D5B),
                                        fontFamily: "quicksand",
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                        );
                      }),
                    ),
                  ),
                )
        ]),
      ),
      bottomNavigationBar: Wrap(
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
            onTap: () {
             isLoading ? null :_addAppoitmentutton();
            },
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
                      "Add",
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
    );
  }


//////////////////////Save LigalDAta Start////////////////////////
   Future<void> _addAppoitmentutton() async {
    setState(() {
      isLoading = true;
    });

    if(titleController.text == ""){
      _errorDialog("Add title!");
      isLoading = false;
    }
    else if(locationController.text == ""){
      _errorDialog("Add location!");
      isLoading = false;
    }
     else if(type == "Type"){
      _errorDialog('Type is not selected');
      isLoading = false;
    }
     else if(descController.text == ""){
      _errorDialog("Add description!");
      isLoading = false;
    }
    else if(dateFrom == "Date"){
      _errorDialog('"From" date is not selected');
      isLoading = false;
    }
    else if(dateFrom == "Date"){
      _errorDialog('"To" date is not selected');
      isLoading = false;
    }
    else if(timeFrom == "Time"){
      _errorDialog('"From" time is not selected');
      isLoading = false;
    }
    else if(timeTo == "Time"){
      _errorDialog('"To" time is not selected');
      isLoading = false;
    }
     else {


      var data = {
              "case_general_id": widget.caseId,
              "title": "${titleController.text}",
              "type": type,
              "location": "${locationController.text}",
              "message": "${descController.text}",
              "from_date": DateFormat("yyyy-MM-dd").format(DateTime.parse("${DateFormat("dd-MM-yyyy").parse(dateFrom)}")),
              "from_time": timeFrom,
              "to_date": DateFormat("yyyy-MM-dd").format(DateTime.parse("${DateFormat("dd-MM-yyyy").parse(dateTo)}")),
              "to_time": timeTo,
              "attachments": documentList,
            "people":store.state.appointmentAddPepState.map((obj) => obj['id']).toList(),
};
               // DateFormat("yyyy-MM-dd").format(DateTime.parse("${DateFormat("dd-MM-yyyy").parse(dateToLog)}")),

        print(data);
       // _errorDialog("Something went wrong!");




      var res = await CallApi().postData(data, 'post_appointment');
       var body = json.decode(res.body);
       print(body);
    
   if(body['status'] == 'Token is Expired'){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
      else if (res.statusCode != 200) {

     _errorDialog("Something went wrong!");
      setState(() {
      isLoading = false;
      });
    }
    else if (res.statusCode == 200) {

     
    //print("its working");
    // store.state.appointmentInfoState['all_appointments'].add(body['appointment']);
    // store.dispatch(AppointmentInfoAction(store.state.appointmentInfoState)); // update data in store...
    
    setState(() {
      isLoading = false;
      });
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => ProfileBioPage(widget.caseId)));
   // Navigator.pop(context);
    }
    else if (res.statusCode == 400) {
      _errorDialog("Something went wrong!");
      setState(() {
      isLoading = false;
      });
    }
    
    else{
      _errorDialog("Something went wrong!");
      setState(() {
      isLoading = false;
      });
    }

  setState(() {
    isLoading = false;
  });
  
    }
  }
/////////////////////Save Ligal End ////////////////////////



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


////////////////////////////////////////////////////////////////////// Upload Section /////////////////////////////////////////////////////////////////
  

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
                                             isFileUploading ? null : _uploadFile();
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

  }
  /////////////////////// Upload File //////////////////


  
  //////////////////////Refresh ////////////////////////
  void refresh(number) {
    setState(() {
        isDocumentPressed = false;
        var data = {
         'doc_name': "${file.path.split('/').last}",
         'pic': uploadedDocData['pic'],
         'type': uploadedDocData['type'],
         'extension': uploadedDocData['extension'],
        };
        print(data);
       documentList.add(data);
       print(documentList);
      //  caseBiodata['case_documents'].add(data);
      //  store.dispatch(BiographicalInfoAction(store.state.biographicalInfoState));
        path = "";
        isDocItemPressed = false;
      });
  }
  //////////////////////Refresh ////////////////////////
  ////////////////////////////////////////////////////////////////////// Upload Section /////////////////////////////////////////////////////////////////


}
