import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:intl/intl.dart';

import '../../main.dart';


class YourProfilePage extends StatefulWidget {
  final userID;
  YourProfilePage(this.userID);
  @override
  _YourProfilePageState createState() => _YourProfilePageState();
}

class _YourProfilePageState extends State<YourProfilePage> {

  bool _isLoading = true;
  bool _isError = false;
  var profileData;

  @override
  void initState() {
    _getPlayerData();
    super.initState();
  }

  Future _getPlayerData() async {
     setState(() {
        _isLoading = true;
       });
    var res = await CallApi().getData('get_user_profile/${widget.userID}');
    final body = json.decode(res.body);

    //print(body);
    if (res.statusCode == 200) {
      if (body != null) {
       // homePageData = MainData.fromJson(body);
      //  store.dispatch(HomepageCaseAction(body)); // update data in store...
      //  print("body['caseGeneral']");
      //  print(store.state.homepageCaseState);
      // if (!mounted) return;
      
       setState(() {
         profileData = body;
        _isLoading = false;
         //homeData = store.state.homepageCaseState;
       });
      //  var date = profileData['User'][0]['created_at'];
      //   DateTime todayDate = DateTime.parse(date);
      //  print(DateFormat.yMd().format(todayDate));
       print(profileData);
      }
    } else{
      setState(() {
        _isError = true;
      });
      print("Error re vai");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(bottom: 30),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Stack(
                      children: <Widget>[
                        profileData['User']['profile_picture'] == null
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: selectedColor,
                                      borderRadius: BorderRadius.circular(100)),
                                  height: 63,
                                  width: 63,
                                  child: Center(
                                      child: Text(
                                    "${profileData['User']['first_name'][0].toUpperCase()}${profileData['User']['last_name'][0].toUpperCase()}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontFamily: "quicksand",
                                        fontWeight: FontWeight.bold),
                                  )),
                                )
                              :
                        Container(
                          margin: EdgeInsets.only(left: 0),
                          child: Container(
                            padding: EdgeInsets.all(24),
                            decoration: BoxDecoration(
                                color: selectedColor,
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/image/your_profile.png"),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(100)),
                            height: 63,
                            width: 63,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        "${profileData['User']['first_name']} ${profileData['User']['last_name']}",
                        style: TextStyle(
                            color: mainColor,
                            fontFamily: 'quicksand',
                            fontSize: 19,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "${profileData['User']['user_type']}",
                        style: TextStyle(
                            color: Color(0xff7A98A9),
                            fontFamily: 'quicksand',
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Text(
                      "About",
                      style: TextStyle(
                          color: Color(0xff313131),
                          fontFamily: 'quicksand',
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                  ),
                  margin: EdgeInsets.only(top: 0),
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
                              "Joined",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff777D82),
                                  fontSize: 11,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "${DateFormat.yMd().format(DateTime.parse(profileData['User']['created_at']))}", //01/23/2020 
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff23272A),
                                  fontSize: 11,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Container(
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
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Location",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff777D82),
                                  fontSize: 11,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "${profileData['User']['city']}, ${profileData['User']['state']}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff23272A),
                                  fontSize: 11,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Container(
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
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Email",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff777D82),
                                  fontSize: 11,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                             profileData['User']['optional_email'] == null ? "${profileData['User']['email']}" : "${profileData['User']['optional_email']}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff23272A),
                                  fontSize: 11,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Container(
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
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Phone Number",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff777D82),
                                  fontSize: 11,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                             profileData['User']['mobile'] != null ? "${profileData['User']['mobile']}" : "(---) --------", //"(123) 456-7890 "
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff23272A),
                                  fontSize: 11,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Container(
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
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Home Phone Number",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff777D82),
                                  fontSize: 11,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              profileData['User']['home_phone'] != null ? "${profileData['User']['home_phone']}" : "(---) --------",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff23272A),
                                  fontSize: 11,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Text(
                      "Related Cases",
                      style: TextStyle(
                          color: Color(0xff313131),
                          fontFamily: 'quicksand',
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
              child: profileData['Related_case'].length == 0 ? Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                child : Center(
                  child: Text(
                        "No Cases",
                        style: TextStyle(
                                  color: Color(0xff23272A),
                                  fontSize: 11,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w600),
                      ),
                ),
              ) :
               Column(
                  children: List.generate(
                     profileData['Related_case'].length, (index) {
                return GestureDetector(
                  onTap: () {
                  //  Navigator.push( context, MaterialPageRoute(   builder: (context) => YourProfilePage()));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 0, right: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                             profileData['Related_case'][index]['profile_picture'] == null
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: selectedColor,
                                      borderRadius: BorderRadius.circular(100)),
                                  height: 45,
                                  width: 45,
                                  margin: EdgeInsets.only(left: 20),
                                  child: Center(
                                      child: Text(
                                    "${profileData['Related_case'][index]['first_name'][0].toUpperCase()}${profileData['Related_case'][index]['last_name'][0].toUpperCase()}",
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
                                            "assets/image/baby5.png"),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(100)),
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
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                                child: Text(
                                                  "${profileData['Related_case'][index]['first_name']} ${profileData['Related_case'][index]['last_name']}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: mainColor,
                                                      fontSize: 15,
                                                      fontFamily: "quicksand",
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        profileData['Related_case'][index]['placements'] != null ?
                                        "${profileData['Related_case'][index]['placements']['placement_type']} - ${profileData['Related_case'][index]['age']} yo"
                                        : "${profileData['Related_case'][index]['age']} yo",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: 12,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        padding: EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 14,
                                            right: 14),
                                        decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                          profileData['Related_case'][index]['status'] == "Current" ?
                                          "${DateFormat('dd-MM-yyyy').format(DateTime.parse(profileData['Related_case'][index]['created_at']))} to Present" :
                                          "${DateFormat('dd-MM-yyyy').format(DateTime.parse(profileData['Related_case'][index]['created_at']))} to ${DateFormat('dd-MM-yyyy').format(DateTime.parse(profileData['Related_case'][index]['updated_at']))}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}
