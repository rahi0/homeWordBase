import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';


class UpdateTherapistScreen extends StatefulWidget {
  final therapistData;
  final therapistIndex;
  UpdateTherapistScreen(this.therapistData, this.therapistIndex);
  @override
  _UpdateTherapistScreenState createState() => _UpdateTherapistScreenState();
}

class _UpdateTherapistScreenState extends State<UpdateTherapistScreen> {
  bool isLoading = true;
  bool isFName = true;
  bool isLName = true;
  bool phoneCorrect = false;
  bool pressButton = true;
  String fname = "", lname = "", dpt = "", address = "", mobile = "";
  TextEditingController typeController = new TextEditingController();
  TextEditingController fNameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController mobNumController =
      new MaskedTextController(mask: '(000) 000-000000');


  @override
  void initState() {
    getTherapistData();

    // TODO: implement initState
    super.initState();
  }

 void getTherapistData() async {
   setState(() {
     isLoading = true;
   });
   print(widget.therapistIndex);
   fNameController.text = store.state.therapyInfoState['doctor'][widget.therapistIndex]['name'];
   addressController.text = store.state.therapyInfoState['doctor'][widget.therapistIndex]['address'];
   mobNumController.text = store.state.therapyInfoState['doctor'][widget.therapistIndex]['phone_number'];
   typeController.text = store.state.therapyInfoState['doctor'][widget.therapistIndex]['department'];
   setState(() {
     isLoading = false;
   });
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
                    "Update Therapist",
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
                onTap: () {
                  setState(() {
                    fNameController.text = store.state.therapyInfoState['doctor'][widget.therapistIndex]['name'];
                    addressController.text = store.state.therapyInfoState['doctor'][widget.therapistIndex]['address'];
                    mobNumController.text = store.state.therapyInfoState['doctor'][widget.therapistIndex]['phone_number'];
                    typeController.text = store.state.therapyInfoState['doctor'][widget.therapistIndex]['department'];
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

          ////////////////////////// Update Button Start///////////////
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
        onTap: () {
                pressButton == false ? null : updateDoctorButton();
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
          ////////////////////////// Update Button End ///////////////


          SingleChildScrollView(
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
                              hintText: "Enter therapist name",
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
                        ),
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

                /////////////// address input start //////////////////
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10, right: 20, top: 15),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                address = value;
                              });
                            },
                            controller: addressController,
                            autofocus: false,
                             keyboardType: TextInputType.text,
                             textCapitalization: TextCapitalization.words,
                            style: TextStyle(
                                color: Color(0xff003A5B).withOpacity(0.6),
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: "Enter therapist address",
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
                /////////////// address input end //////////////////

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
                            controller: mobNumController,
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

                /////////////// placement type dropdown input start //////////////////
                
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10, right: 20, top: 15),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                dpt = value;
                              });
                            },
                            controller: typeController,
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                                color: Color(0xff003A5B).withOpacity(0.6),
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                             // hintText: "(---) ---- ---",
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
                              labelText: "Department Type",
                              hintText: "Therapist, Psychologist, etc.",
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
                ///////////////  placement type dropdown input end //////////////////
              ],
            ),
          ),
        ],
      ),
    );
  }



void updateDoctorButton() async{

    setState(() {
      pressButton = false;
    });

    if(fNameController.text == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    } 
    else if(addressController.text == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    }
    else if(mobNumController.text == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    }
    else if(typeController.text == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    }

    else{

      
    store.state.therapyInfoState['doctor'][widget.therapistIndex]['name'] = fNameController.text;
    store.state.therapyInfoState['doctor'][widget.therapistIndex]['address'] = addressController.text;
    store.state.therapyInfoState['doctor'][widget.therapistIndex]['phone_number'] = mobNumController.text;
    store.state.therapyInfoState['doctor'][widget.therapistIndex]['department'] = typeController.text;

    setState(() {
      therapyDoctorList[widget.therapistIndex]['name'] = fNameController.text;
      therapyDoctorList[widget.therapistIndex]['address'] = addressController.text;
      therapyDoctorList[widget.therapistIndex]['phone_number'] = mobNumController.text;
      therapyDoctorList[widget.therapistIndex]['department'] = typeController.text;
    });
   store.dispatch(TherapyInfoAction(store.state.therapyInfoState));

      // print(store.state.therapyInfoState['doctor']);
      // print('did');
      // print(therapyDoctorList);
      
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