import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/main.dart';
import 'package:homewardbase/screens/CaseCreatedPage/CaseCreatedPage.dart';
import 'package:homewardbase/screens/InviteSentPage/InviteSentPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMemberPage extends StatefulWidget { 
  final data;
  final caseData;
  AddMemberPage(this.data, this.caseData);
  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  bool isPressed = false;
  List emailList = [
    {
      'data': '',
    }
  ];

  List emails = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(right: 0, left: 0),
              child: Icon(Icons.chevron_left, color: Colors.black, size: 25)),
        ),
        title: Center(
          child: Text(
            "Add Members",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "quicksand",
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.only(right: 0, left: 0),
            child: Text(
              "Cancel",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: "quicksand",
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            SizedBox(height: 20),
            Container(
                margin: EdgeInsets.all(20),
                child: Image.asset(
                  "assets/image/add_member.png",
                  height: 44,
                )),
            Container(
              margin: EdgeInsets.only(left: 20, right: 15, top: 0, bottom: 0),
              child: Text(
                "Add members",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: mainColor,
                    fontFamily: "quicksand",
                    fontSize: 25,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 22, right: 40, top: 10, bottom: 20),
              child: Text(
                "Add other case members to keep in the loop.",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Color(0xff003A5B),
                    fontFamily: "quicksand",
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              child: Column(
                children: List.generate(emailList.length, (index) {
                  return Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.15),
                          borderRadius: BorderRadius.circular(5)),
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                      padding: EdgeInsets.only(top: 15, bottom: 5, right: 10),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  emailList[index]['data'] = value;
                                });
                              },
                              autofocus: false,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  color: Color(0xff003A5B).withOpacity(0.6),
                                  fontSize: 15,
                                  fontFamily: 'quicksand',
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: "Enter Email",
                                hintStyle: TextStyle(
                                    color: Color(0xff003A5B).withOpacity(0.6),
                                    fontSize: 15,
                                    fontFamily: 'quicksand',
                                    fontWeight: FontWeight.w600),
                                labelStyle: TextStyle(
                                    color: Color(0xff7A98A9),
                                    fontSize: 15,
                                    fontFamily: 'quicksand',
                                    fontWeight: FontWeight.w500),
                                labelText: "Email",
                                contentPadding:
                                    EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ));
                }),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  emailList.add({
                    'data': '',
                  });
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(left: 22, right: 20, top: 15, bottom: 20),
                child: Text(
                  "+ Add Another",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: selectedColor,
                      fontFamily: "quicksand",
                      fontSize: 11,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: Container(
        height: widget.data == 1 ? 150 : 115,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                // widget.data == 1 ? Navigator.push( context, MaterialPageRoute( builder: (context) => CaseCreatedPage()))
                //     : 
                   // Navigator.push( context, MaterialPageRoute( builder: (context) => InviteSentPage()));
                   _sendInvites();
                    
              },
              child: Container(
                margin: EdgeInsets.all(20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  margin: EdgeInsets.only(
                      top: 0, bottom: widget.data == 1 ? 0 : 20),
                  decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: selectedColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Send invites",
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
            widget.data == 1
                ? GestureDetector(
                    onTap: () {
                      //Navigator.push( context,  MaterialPageRoute(builder: (context) => CaseCreatedPage(widget.caseData['id'])));
                       Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => CaseCreatedPage(widget.caseData['id'])));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 22, right: 40, top: 0, bottom: 20),
                      child: Text(
                        "Skip",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Color(0xff003A5B),
                            fontFamily: "quicksand",
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }



////////////////////////  Add CAse  STart  //////////////////////
  
  void _sendInvites() async {
    
    setState(() {
      isPressed = true;
    });


    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var userData = json.decode(userJson);


      for(var d in emailList){
      if(d["data"] != ''){
        emails.add('${d["data"]}');
      } 
      }
      print(emails.length);

    var data = {
      'case_general_id': widget.caseData['id'],
      'user_id': userData['id'],
      'emails': emails,
    };
    
    print(data);
   // 

    // setState(() {
    //   isPressed = false;
    // });
    

    var res = await CallApi().postData(data, 'post_CaseMember');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode != 200) {
      // show error msg
      _errorDialog("Something went wrongg!");
        setState(() {
          emails =[];
      isPressed = false;
    });
    } else 
    if (res.statusCode == 200 && body['success'] == true){ 
      setState(() {
      isPressed = false;
     Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => InviteSentPage(widget.caseData['id'])));
    });
    }
    else{
      print('did not work');
      _errorDialog("Something went wrong!");
      setState(() {
        emails =[];
      isPressed = false;
    });
     }
  }
//////////////////////// Add CAse End /////////////////////////

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
