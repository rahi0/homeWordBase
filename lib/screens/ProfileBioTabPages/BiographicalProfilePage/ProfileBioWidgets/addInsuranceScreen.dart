import 'package:flutter/material.dart';
import 'package:homewardbase/redux/actions.dart';

import '../../../../main.dart';


class AddInsuranceScreen extends StatefulWidget {
  @override
  _AddInsuranceScreenState createState() => _AddInsuranceScreenState();
}

class _AddInsuranceScreenState extends State<AddInsuranceScreen> {
  bool pressButton = true;
  TextEditingController insuarnceNameController = new TextEditingController();
  TextEditingController insuarnceIdController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
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
                    "Add Insurance",
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
          pressButton == false ? null : addInsuranceButton();
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
            ////////////////////// insurance name input field start //////////////////////////
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
                        controller: insuarnceNameController,
                        autofocus: false,
                        style: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: "Enter insurance name",
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
                          labelText: "Insurance name",
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
            ////////////////////// insuarnce name input field end //////////////////////////

            /////////////// insuarnceId input start //////////////////
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
                        controller: insuarnceIdController,
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        style: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: "Enter insurance id",
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
                          labelText: "Insurance Id",
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
            /////////////// insuarnceId reactions input end //////////////////
          ],
        ),
      ),
    );
  }


  void addInsuranceButton() async{

    setState(() {
      pressButton = false;
    });

    if(insuarnceNameController.text == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    } 
    else if(insuarnceIdController.text == ""){
      _errorDialog("Please fill every input field");
      setState(() {
      pressButton = true;
    });
    }

    else{
     var data =    {
          'id' : 0,
          'plan_name' : insuarnceNameController.text,
          'id_number': insuarnceIdController.text,
          'rx_bin': "",
          'rx_group': "",
          'rx_pcn': "",
          'phone_number': "",
          'Front_Photo': null,
          'Back_Photo': null,
          };

          var dataToRedux =    {
          'id' : 0,
          'plan_name' : insuarnceNameController.text,
          'id_number': insuarnceIdController.text,
          'rx_bin': "",
          'rx_group': "",
          'rx_pcn': "",
          'phone_number': "",
          'front_photo': null,
          'back_photo': null,
          };

       store.state.medicalInfoState['insurance'].add(dataToRedux);
       medicaInsuranceList.add(data);
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
