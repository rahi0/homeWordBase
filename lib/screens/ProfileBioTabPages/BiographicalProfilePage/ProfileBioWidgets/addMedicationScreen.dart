import 'package:flutter/material.dart';
import 'package:homewardbase/redux/actions.dart';

import '../../../../main.dart';


class AddMedicationScreen extends StatefulWidget {
  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {

   bool pressButton = true;
  TextEditingController timeOfDayController = new TextEditingController();
  TextEditingController medicationNameController = new TextEditingController();
  TextEditingController usageController = new TextEditingController();
  TextEditingController frequencyController = new TextEditingController();

List dosageTimeList = [];

  ///////////////////// Date Picker Essentials Start ///////////////////////
  String timeTo = 'HH-MM';
  TimeOfDay time = TimeOfDay.now();

  Future<Null> _pickTime(BuildContext context) async {
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
        timeTo = MaterialLocalizations.of(context).formatTimeOfDay(time,
          alwaysUse24HourFormat: false);//"${DateFormat("dd-MM-yyyy").format(time)}";
        dosageTimeList.add({'time' : timeTo});
      });
  }
  ///////////////////// Date Picker Essentials End ///////////////////////
  

  @override
  void initState() {
    super.initState();
  }

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
                    "Add Medication",
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
      body: Stack(
        children: [

          ////////////////////////////// Add Button ////////////////////////
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                            pressButton == false ? null : addMedicineButton();
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
              ],
            ),
          ),
          ////////////////////////////// Add Button ////////////////////////
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                ////////////////////// med name input field start //////////////////////////
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
                            controller: medicationNameController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            autofocus: false,
                            style: TextStyle(
                                color: Color(0xff003A5B).withOpacity(0.6),
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: "Enter medication name",
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
                              labelText: "Medication Name",
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
                ////////////////////// med name input field end //////////////////////////

                /////////////// med use input start //////////////////
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
                            controller: usageController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            autofocus: false,
                            style: TextStyle(
                                color: Color(0xff003A5B).withOpacity(0.6),
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: "Enter medication use",
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
                              labelText: "Use",
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
                /////////////// med use input end //////////////////

/////////////// med intake frequency start //////////////////
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
                            controller: frequencyController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            autofocus: false,
                            style: TextStyle(
                                color: Color(0xff003A5B).withOpacity(0.6),
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: "E.g. Twice daily, as needed, etc.",
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
                              labelText: "Frequency",
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
                /////////////// med intake frequency input end //////////////////

                /////////////// med intake time of day input start //////////////////
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
                            controller: timeOfDayController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            autofocus: false,
                            // keyboardType: TextInputType.number,
                            style: TextStyle(
                                color: Color(0xff003A5B).withOpacity(0.6),
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                               hintText: "E.g. Morning, before bedtime, 12:00 PM, etc",
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
                              labelText: "Time of day",
                              contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    )
                    ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: Divider(
                    color: Colors.black,
                    height: 2,
                    thickness: 0.15,
                    endIndent: 0,
                  ),
                ),
                ///////////////  med intake time of day input end //////////////////

                /////////////// med dosage input start //////////////////
                GestureDetector(
                  onTap: () {
                    _pickTime(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 0.2,
                        ),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 65,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    padding: EdgeInsets.only(top: 10, bottom: 5, right: 10),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 6),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Dosage",
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
                            6.0,
                            6,
                            12.0,
                            0,
                          ),
                          alignment: Alignment.topLeft,
                          child: Text(
                           timeTo,
                            style: TextStyle(
                              color: timeTo == 'HH-MM'
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
                /////////////// med dosage input end //////////////////
                
                //////////////////////// Dosage List ///////////////////////////
                Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 80),
                          child: Wrap(
                              children: List.generate(dosageTimeList.length, (index) {
                            return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        dosageTimeList.removeAt(index);
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
                                        child:  Wrap(
                                                children: <Widget>[
                                                  Text(
                                                    "${dosageTimeList[index]['time']}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: mainColor,
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
                //////////////////////// Dosage List ///////////////////////////
                

              ],
            ),
          ),
        ],
      ),
    );
  }





void addMedicineButton() async{

    setState(() {
      pressButton = false;
    });

    if(medicationNameController.text == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    } 
    else if(frequencyController.text == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    }
    else if(timeOfDayController.text == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    }
    else if(usageController.text == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    }
    else if(dosageTimeList.length == 0){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    }

    else{
       //  siblingsList.add(
     var data =    {
          'id' : 0,
          'medicin_name' : medicationNameController.text,
          'power': frequencyController.text,
          'taking_method': timeOfDayController.text,
          'cause': usageController.text,
          'doctor_id': null,
          'time': dosageTimeList.map((obj) => obj['time']).toList(),
          };
     //     );

      var dataATRedux =    {
           'id' : 0,
          'medicin_name' : medicationNameController.text,
          'power': frequencyController.text,
          'taking_method': timeOfDayController.text,
          'cause': usageController.text,
          'doctor_id': null,
          'medicin_taking_time': dosageTimeList
          };

       store.state.medicalInfoState['Medication'].add(dataATRedux);
       medicationList.add(data);
       store.dispatch(MedicalInfoAction(store.state.medicalInfoState));
      
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
