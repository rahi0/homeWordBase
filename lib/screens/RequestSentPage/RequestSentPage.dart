import 'package:flutter/material.dart';
import 'package:homewardbase/main.dart';
import 'package:homewardbase/screens/AddCasePage/AddCasePage.dart';
import 'package:homewardbase/screens/HomePage/HomePage.dart';

class RequestSentPage extends StatefulWidget {
  @override
  _RequestSentPageState createState() => _RequestSentPageState();
}

class _RequestSentPageState extends State<RequestSentPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              //margin: EdgeInsets.only(left:55, right:55),
                              child: Center(
                                  child: Image.asset(
                            "assets/image/contact.png",
                            height: 66,
                            width: 66,
                          ))),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(
                                left: 30, right: 30, top: 30, bottom: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Request sent",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: mainColor,
                                      fontFamily: "quicksand",
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 30, right: 30, top: 10, bottom: 40),
                            child: Text(
                              "Your request to join the case has been sent. You will be notified of the status of this request. ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff354D5B),
                                  fontFamily: "quicksand",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                 // addCasePage = 2;
                //  Navigator.push(context,  MaterialPageRoute(builder: (context) => AddCasePage()));
                 // Navigator.push(context,  MaterialPageRoute(builder: (context) => HomePage()));
                   Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 60),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    decoration: BoxDecoration(
                        color: selectedColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Return home",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "quicksand",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
