import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:homewardbase/redux/actions.dart';

import '../../../../main.dart';


class UpdateSchoolScreen extends StatefulWidget {
  final schoolData;
  final schoolIndex;
  UpdateSchoolScreen(this.schoolData, this.schoolIndex);
  @override
  _UpdateSchoolScreenState createState() => _UpdateSchoolScreenState();
}

class _UpdateSchoolScreenState extends State<UpdateSchoolScreen> {
  bool isLoading = true;
  bool pressButton = true;
  TextEditingController schoolNameController = new TextEditingController();
  TextEditingController schoolAddressController = new TextEditingController();
  TextEditingController schoolMobNumController =
      new MaskedTextController(mask: '(000) 000-000000');

  bool phoneCorrect = false;
  String mobile = "";

  String valType = "";
  List<DropdownMenuItem<String>> _dropDownTypeItems;
  List arrType = [
    "Grade (optional)",
    "Pre-K",
    "Kindergarten",
    "1st Grade",
    "2nd Grade",
    "3rd Grade",
    "4th Grade",
    "5th Grade",
    "6th Grade",
    "7th Grade",
    "8th Grade",
    "9th Grade",
    "10th Grade",
    "11th Grade",
    "12th Grade",
  ];

  @override
  void initState() {
    _dropDownTypeItems = getDropDownTypeItems();
    valType = _dropDownTypeItems[0].value;
    getSchoolData();

    // TODO: implement initState
    super.initState();
  }

 void getSchoolData() async {
   setState(() {
     isLoading = true;
   });
   print(widget.schoolIndex);
   schoolNameController.text = store.state.educationInfoState['education'][widget.schoolIndex]['school_name'];
   schoolAddressController.text = store.state.educationInfoState['education'][widget.schoolIndex]['address'];
   schoolMobNumController.text = store.state.educationInfoState['education'][widget.schoolIndex]['phone'];
   valType = store.state.educationInfoState['education'][widget.schoolIndex]['grade'] == null ? "Grade (optional)" : store.state.educationInfoState['education'][widget.schoolIndex]['grade'];
   setState(() {
     isLoading = false;
   });
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
              color: typeList == "Select Grade"
                  ? mainColor.withOpacity(0.6)
                  : mainColor,
              fontFamily: 'quicksand',
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          )));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator()
      ),
    ) :
    Scaffold(
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
                    "Update School",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "quicksand",
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    schoolNameController.text = store.state.educationInfoState['education'][widget.schoolIndex]['school_name'];
                    schoolAddressController.text = store.state.educationInfoState['education'][widget.schoolIndex]['address'];
                    schoolMobNumController.text = store.state.educationInfoState['education'][widget.schoolIndex]['phone'];
                    valType = store.state.educationInfoState['education'][widget.schoolIndex]['grade'] == null ? "Grade (optional)" : store.state.educationInfoState['education'][widget.schoolIndex]['grade'];
                  });
                },
                child: Container(
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
              ),
            ],
          ),
        ),
      ),
    
      body: Stack(
        children: [
          /////////////////////////// Add Button //////////////////////////
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
        onTap: () {
                 pressButton == false ? null : updateEducationButton();
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
                        "Update",
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
              ],
            ),
          ),
          /////////////////////////// Add Button //////////////////////////
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                ////////////////////// school name input field start //////////////////////////
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10, right: 20, top: 15),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: schoolNameController,
                            textCapitalization: TextCapitalization.sentences,
                            autofocus: false,
                            style: TextStyle(
                                color: Color(0xff003A5B).withOpacity(0.6),
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: "Enter school name",
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
                              labelText: "School Name",
                              contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                  //height: 15,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: Divider(
                    color: Colors.black,
                    height: 2,
                    thickness: 0.15,
                    //indent: 20,
                    endIndent: 0,
                  ),
                ),
                ////////////////////// school name input field end //////////////////////////

                /////////////// school address input start //////////////////
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10, right: 20, top: 15),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: schoolAddressController,
                            textCapitalization: TextCapitalization.words,
                            autofocus: false,
                            style: TextStyle(
                                color: Color(0xff003A5B).withOpacity(0.6),
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: "Enter school address",
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
                              labelText: "Address",
                              contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: Divider(
                    color: Colors.black,
                    height: 2,
                    thickness: 0.15,
                    endIndent: 0,
                  ),
                ),
                /////////////// school address input end //////////////////

                /////////////// phone number input start //////////////////
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10, right: 20, top: 15),
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
                            controller: schoolMobNumController,
                            autofocus: false,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                                color: Color(0xff003A5B).withOpacity(0.6),
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: "(---) ---- ---",
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
                              labelText: "Phone Number",
                              contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
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
                Container(
                  //height: 15,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: Divider(
                    color: Colors.black,
                    height: 2,
                    thickness: 0.15,
                    //indent: 20,
                    endIndent: 0,
                  ),
                ),
                /////////////// phone number input end //////////////////

                /////////////// grade dropdown input start //////////////////
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  padding: EdgeInsets.only(top: 5, bottom: 5, right: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Container(
                      //   margin: EdgeInsets.only(left: 12, right: 10, top: 5),
                      //   child: Text(
                      //     "Grade",
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //         color: Color(0xff959595),
                      //         fontSize: 11.5,
                      //         fontFamily: 'quicksand',
                      //         fontWeight: FontWeight.w400),
                      //   ),
                      // ),
                      Container(
                        height: 33,
                        padding: EdgeInsets.only(left: 5, right: 12),
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
                /////////////// grade dropdown input end //////////////////
              ],
            ),
          ),
        ],
      ),
    );
  }


   void updateEducationButton() async{

    setState(() {
      pressButton = false;
    });

    if(schoolNameController.text == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    } 
    else if(schoolAddressController.text == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    }
    else if(schoolMobNumController.text == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    }
    // else if(valType == "Select Placement"){
    //   _errorDialog("Please fill every input field");
    //   setState(() {
    //   pressButton = true;
    // });
    // }

    else{

    store.state.educationInfoState['education'][widget.schoolIndex]['school_name'] = schoolNameController.text;
    store.state.educationInfoState['education'][widget.schoolIndex]['address'] = schoolAddressController.text;
    store.state.educationInfoState['education'][widget.schoolIndex]['phone'] = schoolMobNumController.text;
    store.state.educationInfoState['education'][widget.schoolIndex]['grade'] = valType == "Grade (optional)" ? null : valType;

    setState(() {
      educationList[widget.schoolIndex]['school_name'] = schoolNameController.text;
      educationList[widget.schoolIndex]['address'] = schoolAddressController.text;
      educationList[widget.schoolIndex]['phone'] = schoolMobNumController.text;
      educationList[widget.schoolIndex]['grade'] = valType == "Grade (optional)" ? null : valType;
    });
   store.dispatch(EducationInfoAction(store.state.educationInfoState));
      
      // print(store.state.educationInfoState['education']);
      // print('did');
      // print(educationList);
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
                      child:Image.asset("assets/image/accept_removal.png")),
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
