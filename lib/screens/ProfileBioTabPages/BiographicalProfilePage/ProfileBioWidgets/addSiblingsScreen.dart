import 'package:flutter/material.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';


class AddSiblingScreen extends StatefulWidget {
  @override
  _AddSiblingScreenState createState() => _AddSiblingScreenState();
}

class _AddSiblingScreenState extends State<AddSiblingScreen> {

  
  bool pressButton = true;
  bool isFName = true;
  bool isLName = true;
  String fname = "", lname = "", dob = "";
  TextEditingController dobController = new TextEditingController();
  TextEditingController fNameController = new TextEditingController();

  var gender = "";
  var inCareStatus = "";

  String valType = "";
  List<DropdownMenuItem<String>> _dropDownTypeItems;
  List arrType = [
    "Select Placement",
    "Adoptive Placement",
    "Foster Placement",
    "Residential Placement",
    "Emergency Placement",
  ];


  @override
  void initState() {
    _dropDownTypeItems = getDropDownTypeItems();
    valType = _dropDownTypeItems[0].value;

    dobController.text = 'DD-MM-YYYY';
    // TODO: implement initState
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownTypeItems() {
    ////////drop down button
    List<DropdownMenuItem<String>> items = new List();
    for (String typeList in arrType) {
      items.add(new DropdownMenuItem(
          value: typeList,
          child: new Text(
            typeList,
            textAlign: TextAlign.end,
            style: TextStyle(
                color: typeList == "Select Placement"
                    ? mainColor.withOpacity(0.6)
                    : mainColor,
                fontFamily: 'quicksand',
                fontSize: 15,
                fontWeight: FontWeight.w500),
          )));
    }
    return items;
  }

  ///////////////////// Date Picker Essentials Start ///////////////////////
  String dateTo = 'DD-MM-YYYY';
  DateTime selectedDateTo = DateTime.now();
  var dateTextController = new TextEditingController();

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
        dateTo = "${DateFormat("dd-MM-yyyy").format(selectedDateTo)}";
        dobController.text = dateTo;
      });
    }
  }
  ///////////////////// Date Picker Essentials End ///////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
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
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: 0, left: 0),
                    child: Icon(Icons.close, color: Colors.black, size: 17)),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    "Add Sibling",
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
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.only(right: 0, left: 0),
                child: Center(
                    child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Color(0xff7A98A9),
                      fontSize: 13,
                      fontFamily: "quicksand",
                      fontWeight: FontWeight.w400),
                )),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector( 
        onTap: () {
        pressButton == false ? null : addSiblingButton();
        },
        child: Container(
          margin: EdgeInsets.all(20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            margin: EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
                color: pressButton == false ? Colors.grey[350] : selectedColor,
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
                      fontSize: 16,
                      fontFamily: "quicksand",
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ////////////////////// name input field start //////////////////////////
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 10, right: 20, top: 35),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            fname = value;
                            if (fname == "") {
                              setState(() {
                                isFName = false;
                              });
                            } else {
                              isFName = true;
                            }
                          });
                        },
                        controller: fNameController,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        style: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: "Enter your name",
                          hintStyle: TextStyle(
                              color: Color(0xff003A5B).withOpacity(0.6),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w600),
                          labelStyle: TextStyle(
                              color: Color(0xff003A5B),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w500),
                          labelText: "Name",
                          contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                )),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      //height: 15,
                      margin: EdgeInsets.only(left: 20, right: 10, top: 0),
                      child: Divider(
                        color: Colors.black,
                        height: 15,
                        thickness: 0.2,
                        //indent: 20,
                        endIndent: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ////////////////////// name input field end //////////////////////////

            ///////////////////// gender input container start //////////////////////
            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Gender",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 10),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                          gender = "Male";
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            gender == "Male"
                                ? "assets/image/gender_yes.png"
                                : "assets/image/gender_no.png",
                            height: 21,
                            width: 21,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 7),
                            child: Text(
                              "Male",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 15,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = "Female";
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 25),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            gender == "Female"
                                ? "assets/image/gender_yes.png"
                                : "assets/image/gender_no.png",
                            height: 21,
                            width: 21,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 7),
                            child: Text(
                              "Female",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 15,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ///////////////////// gender input container end //////////////////////
            
            ////////////////////// IN care/ not In care Start /////////////////////
            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Status",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          inCareStatus = "In_care";
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 17, right: 17),
                          margin: EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                              color:
                                  inCareStatus == "In_care" ? selectedColor : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: inCareStatus == "In_care"
                                      ? selectedColor
                                      : Color(0xfff1f1f1))),
                          child: Text(
                            "In care",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: inCareStatus == "In_care"
                                    ? Colors.white
                                    : Color(0xff333333),
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          inCareStatus = "Not_in_care";
                          //inCareSiblingAgeList = [];
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 17, right: 17),
                          margin: EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                              color:
                                  inCareStatus == "Not_in_care" ? selectedColor : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: inCareStatus == "Not_in_care"
                                      ? selectedColor
                                      : Color(0xfff1f1f1))),
                          child: Text(
                            "Not in care",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: inCareStatus == "Not_in_care"
                                    ? Colors.white
                                    : Color(0xff333333),
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ////////////////////// IN care/ not In care End /////////////////////

            /////////////// placement type dropdown input start //////////////////
            Container(
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey, width: 0.15),
              //     borderRadius: BorderRadius.circular(5)),
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              padding: EdgeInsets.only(top: 5, bottom: 5, right: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 10, top: 5),
                    child: Text(
                      "Placement Type",
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
                          isExpanded: true,
                          iconEnabledColor: Color(0xff003A5B),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff003A5B),
                          ),
                          value: valType,
                          items: _dropDownTypeItems,
                          icon: Icon(
                            Icons.expand_more,
                            size: 15,
                            color: Color(0xff707070),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              valType = value;
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
              margin: EdgeInsets.only(left: 22, right: 22, top: 0),
              child: Divider(
                color: Colors.black,
                height: 15,
                thickness: 0.2,
                endIndent: 0,
              ),
            ),
            ///////////////  placement type dropdown input end //////////////////

            ////////////////////// Date of Birth input start //////////////////
            GestureDetector(
              onTap: () {
                _selectDateTo(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 0.2,
                    ),
                  ),
                  // border: Border.all(color: Colors.grey, width: 0.15),
                  // borderRadius: BorderRadius.circular(5),
                ),
                width: MediaQuery.of(context).size.width,
                height: 65,
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                padding: EdgeInsets.only(top: 10, bottom: 5, right: 10),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 11),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Date of Birth",
                        style: TextStyle(
                          color: Color(0xff959595),
                          fontSize: 11.5,
                          fontFamily: 'quicksand',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        12.0,
                        6,
                        12.0,
                        0,
                      ),
                      alignment: Alignment.topLeft,
                      child: Text(
                        dateTo,
                        style: TextStyle(
                          // color: Color(0xff003A5B).withOpacity(0.6),
                          color: dateTo == 'DD-MM-YYYY'
                              ? mainColor.withOpacity(0.6)
                              : mainColor,
                          fontSize: 15,
                          fontFamily: 'quicksand',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ////////////////////// Date of Birth input end //////////////////
          ],
        ),
      ),
    );
  }

  void addSiblingButton() async{

    setState(() {
      pressButton = false;
    });

    if(fNameController.text == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    } 
    else if(gender == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    }
    else if(inCareStatus == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    }
    else if(valType == "Select Placement"){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    }
    else if(dateTo == "DD-MM-YYYY"){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    }

    else{
       //  siblingsList.add(
     var data =    {
          'id' : 0,
          'name' : fNameController.text,
          'address': "",
          'phone_number': "",
          'email': "",
          'gender': gender,
          'relation': "",
          'note': "",
          'status': inCareStatus,
          'placement_type' : valType,
          'contact_name' : "",
          'birthday': "${selectedDateTo}".split(' ')[0]
          };
     //     );

       store.state.biographicalInfoState['siblings'].add(data);
       siblingsList.add(data);
       store.dispatch(BiographicalInfoAction(store.state.biographicalInfoState));
      
      print(data);
      Navigator.pop(context);

      setState(() {
      pressButton = true;
    });
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
                      width: 55,
                      height: 55,
                      margin: EdgeInsets.all(15),
                      child:Image.asset("assets/image/unsuccess.png")),
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
