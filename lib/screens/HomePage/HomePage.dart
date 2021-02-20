import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get_version/get_version.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/customPlugins/RouteAnimation/RouteAnimation.dart';
import 'package:homewardbase/main.dart';
import 'package:flutter/services.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/AddCasePage/AddCasePage.dart';
import 'package:homewardbase/screens/Drawerr/Drawerr.dart';
import 'package:homewardbase/screens/FilterPage/FilterPage.dart';
import 'package:homewardbase/screens/HomeSearchPage/HomeSearchPage.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:homewardbase/screens/MyProfilePage/MyProfilePage.dart';
import 'package:homewardbase/screens/NotificationPage/NotificationPage.dart';
import 'package:homewardbase/screens/PendingRequestPage/PendingRequestPage.dart';
import 'package:homewardbase/screens/ProfileBioPage/ProfileBioPage.dart';
import 'package:homewardbase/screens/SecurityPage/SecurityPage.dart';
import 'package:homewardbase/screens/YourProfilePage/YourProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _projectVersion = '', _projectCode = '';
  bool isLoading = true;
  var userData;
  var homeData;

  bool isPendingClose = false;
  bool caseInviteButton = false;
  bool memberInviteButton = false;
  bool removalButton = false;
  bool closeButton = false;
  bool noData = false;

  @override
  initState() {
    super.initState();
    _getUser();
    initPlatformState();
  }


  Future<Null> _getUser() async {
    setState(() {
      isLoading = true;
     // currentDrawer = 'cases';
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    print(user);
    setState(() {
      userData = store.state.userInfoState;
     // userData = user;
    });
    _getHomeData();
  }


  _getHomeData() async {
    print("hello");
    print(userData);
    
    // get the local data
    // var key = "upcoming-matches";
    // await getLocalHomePageData(key);
   // call api for new data
   // print(userData.id);
    var res = await CallApi().getData('get_all_case_general_by_id/${userData['id']}'); //${userData['id']}
    final body = json.decode(res.body);
    var homePageData;
    print(body);
     if(body['status'] == 'Token is Expired'){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
    else if (res.statusCode == 200) {
      if (body != null) {
       // homePageData = MainData.fromJson(body);
       store.dispatch(HomepageCaseAction(body)); // update data in store...
       print(body['caseGeneral']);
       print(store.state.homepageCaseState);
       if (!mounted) return;
       setState(() {
         homeData = store.state.homepageCaseState;
       });
       if(homeData['caseGeneral'].length == 0 && homeData['New_Case_Invite'].length == 0 && 
       homeData['withdrawalRequest'].length == 0 && homeData['pendingRemovals'].length == 0 &&
       homeData['pendingCloses'].length == 0 && homeData['newMemberRequest'].length == 0){
         setState(() {
           noData =true;
         });
       }else{
         setState(() {
           noData =false;
         });
       }
      }
      setState(() {
      isLoading = false;
      });
    //  store.dispatch(CaseGeneralAction(body['caseGeneral'])); // update data in store...
      //add the fresh copy in local storage
      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString(key, json.encode(body));
    }

    
  }

  initPlatformState() async {
    String projectVersion;
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }

    String projectCode;
    try {
      projectCode = await GetVersion.projectCode;
    } on PlatformException {
      projectCode = 'Failed to get build number.';
    }

    if (!mounted) return;

    setState(() {
      _projectVersion = projectVersion;
      _projectCode = projectCode;
    });
  }



  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(selectedColor);
    return isLoading ? Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator()
      ),
    ) : Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF8F8FA),
      appBar: AppBar(
        backgroundColor: selectedColor,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(right: 10, left: 5),
            child: Image.asset("assets/image/drawer.png"),
            height: 25,
          ),
        ),
        title: Center(
          child: Text(
            "Cases",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontFamily: "quicksand",
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => SearchScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(right: 10),
                    child: Image.asset("assets/image/search.png"),
                    height: 25,
                    width: 25,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FilterPage()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Image.asset("assets/image/filter.png"),

                    height: 25,
                    width: 25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
//////////////////////////////Drawer start//////////////////////
      drawer: Drawerr(),
//////////////////////////////Drawer End//////////////////////

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddCasePage()));
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: selectedColor,
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: _getUser,
          child: 
          noData ? 
          Center(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 20, right: 20),
                                          child: Text(
                                            "No cases found. Tap the “+” to create or join a new case",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                            color: mainColor,
                                            fontSize: 16,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.bold),
                                    ),
                                        )
          ) :
           CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[ 

              SliverToBoxAdapter(
                child: Container(height: 25,),
              ),


//////////////////////////////Case General Cards start//////////


              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                     return Container(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileBioPage(homeData['caseGeneral'][index]['id'])));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 0, bottom: 10),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            homeData['caseGeneral'][index]['profile_picture'] == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        borderRadius: BorderRadius.circular(100)),
                                    height: 45,
                                    width: 45,
                                    child: Center(
                                        child: Text(
                                      "${homeData['caseGeneral'][index]['first_name'][0].toUpperCase()}${homeData['caseGeneral'][index]['last_name'][0].toUpperCase()}",
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
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                CallApi().fileShowlurl +"${homeData['caseGeneral'][index]['profile_picture']}"),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(100)),
                                    height: 45,
                                    width: 45,
                                  ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "${homeData['caseGeneral'][index]['first_name']} ${homeData['caseGeneral'][index]['last_name']}",
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: 15,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                     Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                              homeData['caseGeneral'][index]['placements']['placement_type'] == null ? "${homeData['caseGeneral'][index]['age']} yo" :
                                              "${homeData['caseGeneral'][index]['placements']['placement_type']} - ${homeData['caseGeneral'][index]['age']} yo",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontSize: 12,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                           // initList[index]['boa'] ? 
                            Container(
                                    margin: EdgeInsets.only(right: 5, left: 0),
                                    //child: Image.asset("assets/image/boa.png"),
                                    height: 23,
                                    width: 23,
                                    child: Icon(
                                      Icons.notifications,
                                      size: 18,
                                      color: Color(0xffFFBA0D),
                                    ),
                                  )
                            //    : Container(),
                          ],
                        ),
                      ),
                    )
                );
                  },
                  
                  childCount: homeData['caseGeneral'].length,
                ),
              ),
////////////////////////////////Case General Cards Ends//////////

/////////////////////////////New_Case_Invite Cards start//////////

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                     return Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
                  //padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "New Case Invite",
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: 15,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text(
                                        "${homeData['New_Case_Invite'][index]['from_user_info']['first_name']} ${homeData['New_Case_Invite'][index]['from_user_info']['last_name']} has invited you to join this case.",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: 12,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => YourProfilePage(homeData['New_Case_Invite'][index]['from_user_info']['id'])));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 0, right: 0, top: 0, bottom: 10),
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              homeData['New_Case_Invite'][index]['from_user_info']['profile_picture'] == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        borderRadius: BorderRadius.circular(100)),
                                    height: 33,
                                    width: 33,
                                    child: Center(
                                        child: Text(
                                      "${homeData['New_Case_Invite'][index]['from_user_info']['first_name'][0].toUpperCase()}${homeData['New_Case_Invite'][index]['from_user_info']['last_name'][0].toUpperCase()}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontFamily: "quicksand",
                                          fontWeight: FontWeight.w600),
                                    )),
                                  )
                                :
                              Container(
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                    color: selectedColor,
                                    image: DecorationImage(
                                        image: AssetImage("assets/image/baby4.png"),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(100)),
                                height: 33,
                                width: 33,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "${homeData['New_Case_Invite'][index]['from_user_info']['first_name']} ${homeData['New_Case_Invite'][index]['from_user_info']['last_name']}",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: mainColor.withOpacity(0.6),
                                              fontSize: 10,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "${homeData['New_Case_Invite'][index]['from_user_info']['user_type']}",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontSize: 8,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            // Text(
                                            //   " - 12 yo",
                                            //   textAlign: TextAlign.start,
                                            //   overflow: TextOverflow.ellipsis,
                                            //   style: TextStyle(
                                            //       color: mainColor,
                                            //       fontSize: 8,
                                            //       fontFamily: "quicksand",
                                            //       fontWeight: FontWeight.w500),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        margin: EdgeInsets.only(top: 0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  caseInviteButton == true ? null : _acceptNewCaseInvite(homeData['New_Case_Invite'][index]);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5, right: 7.5),
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 14, right: 14),
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    "Accept Invite",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: "quicksand",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                 caseInviteButton == true ? null : _rejectNewCaseInvite(homeData['New_Case_Invite'][index]);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5, left: 7.5),
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 14, right: 14),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF9423A),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    "Reject Invite",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: "quicksand",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        //height: 15,
                        margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                        child: Divider(
                          color: Colors.black,
                          height: 2,
                          thickness: 0.15,
                          //indent: 20,
                          endIndent: 0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 0, right: 0, top: 0, bottom: 10),
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              homeData['New_Case_Invite'][index]['case_info']['profile_picture'] == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        borderRadius: BorderRadius.circular(100)),
                                    height: 33,
                                    width: 33,
                                    child: Center(
                                        child: Text(
                                      "${homeData['New_Case_Invite'][index]['case_info']['first_name'][0].toUpperCase()}${homeData['New_Case_Invite'][index]['case_info']['last_name'][0].toUpperCase()}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontFamily: "quicksand",
                                          fontWeight: FontWeight.w600),
                                    )),
                                  )
                                :
                              Container(
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                    color: selectedColor,
                                    image: DecorationImage(
                                        image: AssetImage("assets/image/baby3.png"),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(100)),
                                height: 33,
                                width: 33,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "${homeData['New_Case_Invite'][index]['case_info']['first_name']} ${homeData['New_Case_Invite'][index]['case_info']['last_name']}",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: mainColor.withOpacity(0.6),
                                              fontSize: 10,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                         homeData['New_Case_Invite'][index]['placements'] == null ? "${homeData['New_Case_Invite'][index]['case_info']['age']} yo" : 
                                         "${homeData['New_Case_Invite'][index]['placements']['placement_type']} - ${homeData['New_Case_Invite'][index]['case_info']['age']} yo",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: mainColor,
                                              fontSize: 8,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w500),
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
                    ],
                  ),
                );
                  },
                  
                  childCount: homeData['New_Case_Invite'].length,
                ),
              ),

//////////////////////////////New_Case_Invite Cards Ends//////////



/////////////////////////////withdrawalRequest Cards start//////////

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                     return Container(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push( context,MaterialPageRoute(builder: (context) => PendingRequestPage(homeData['withdrawalRequest'][index]['id'])));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 0, bottom: 10),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            homeData['withdrawalRequest'][index]['profile_picture'] == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        borderRadius: BorderRadius.circular(100)),
                                    height: 45,
                                    width: 45,
                                    child: Center(
                                        child: Text(
                                      "${homeData['withdrawalRequest'][index]['first_name'][0]}${homeData['withdrawalRequest'][index]['last_name'][0]}",
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
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/image/baby1.png"),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(100)),
                                    height: 45,
                                    width: 45,
                                  ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "${homeData['withdrawalRequest'][index]['first_name']} ${homeData['withdrawalRequest'][index]['last_name']}",
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: 15,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w500),
                                      ),
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
                                              "Pending",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),
                    )
                );
                  },
                  
                  childCount: homeData['withdrawalRequest'].length,
                ),
              ),

//////////////////////////////withdrawalRequest Cards Ends//////////



/////////////////////////////pendingRemovals Cards start//////////

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                     return Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
                  //padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Pending Removal",
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: 15,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text(
                                        "${homeData['pendingRemovals'][index]['from_user_info']['first_name']} ${homeData['pendingRemovals'][index]['from_user_info']['last_name']} has suggested that you be removed from this case.",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: 12,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                 removalButton ? null : _showCaseDialog(1, homeData['pendingRemovals'][index], index);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5, right: 7.5),
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 14, right: 14),
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    "Accept removal",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: "quicksand",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  removalButton ? null : _rejectRemoval(homeData['pendingRemovals'][index]);//_showRemovalDialog(2);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5, left: 7.5),
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 14, right: 14),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF9423A),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    "Reject removal",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: "quicksand",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          //////////// tough counting //////////////////////////////////////////////////////////
                          homeData['pendingRemovals'][index]['day'] == 0 ? 
                          "3 days left to respond" : homeData['pendingRemovals'][index]['day'] == 1 ? 
                          "2 days left to respond" : homeData['pendingRemovals'][index]['day'] == 2 ? 
                          "1 days left to respond" : "0 days left to respond",
                          //////////// tough counting //////////////////////////////////////////////////////////
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 8,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        //height: 15,
                        margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                        child: Divider(
                          color: Colors.black,
                          height: 2,
                          thickness: 0.15,
                          //indent: 20,
                          endIndent: 0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute( builder: (context) => ProfileBioPage(homeData['pendingRemovals'][index]['case_info']['id'])));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 0, right: 0, top: 0, bottom: 10),
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              homeData['pendingRemovals'][index]['case_info']['profile_picture'] == null
                                ? Container(
                                  //padding: EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        borderRadius: BorderRadius.circular(100)),
                                    height: 33,
                                    width: 33,
                                    child: Center(
                                        child: Text(
                                      "${homeData['pendingRemovals'][index]['case_info']['first_name'][0]}${homeData['pendingRemovals'][index]['case_info']['last_name'][0]}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontFamily: "quicksand",
                                          fontWeight: FontWeight.w600),
                                    )),
                                  )
                                :
                              Container(
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                    color: selectedColor,
                                    image: DecorationImage(
                                        image: AssetImage("assets/image/baby3.png"),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(100)),
                                height: 33,
                                width: 33,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "${homeData['pendingRemovals'][index]['case_info']['first_name']} ${homeData['pendingRemovals'][index]['case_info']['last_name']}",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: mainColor.withOpacity(0.6),
                                              fontSize: 10,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          homeData['pendingRemovals'][index]['case_info']['placements'] == null ? "${homeData['pendingRemovals'][index]['case_info']['age']} yo" :
                                          "${homeData['pendingRemovals'][index]['case_info']['placements']['placement_type']} - ${homeData['pendingRemovals'][index]['case_info']['age']} yo",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: mainColor,
                                              fontSize: 8,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w500),
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
                    ],
                  ),
                );
                  },
                  
                  childCount: homeData['pendingRemovals'].length,
                ),
              ),

//////////////////////////////pendingRemovals Cards Ends//////////

/////////////////////////////pendingCloses Cards start//////////

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                     return Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
                  //padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Pending Close",
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: 15,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text(
                                        "${homeData['pendingCloses'][index]['user_info']['first_name']} ${homeData['pendingCloses'][index]['user_info']['last_name']} has suggested that this case be closed.",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: 12,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      homeData['pendingCloses'][index]['is_accept'] == null
                          ? Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                       closeButton ? null : _showCaseDialog(2, homeData['pendingCloses'][index], index);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 5, right: 7.5),
                                        padding: EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 14,
                                            right: 14),
                                        decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius: BorderRadius.circular(5)),
                                        child: Text(
                                          "Accept close",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                       closeButton ? null : _rejectClose(homeData['pendingCloses'][index], index);
                                        
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 5, left: 7.5),
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10, left: 14, right: 14),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFF9423A),
                                            borderRadius: BorderRadius.circular(5)),
                                        child: Text(
                                          "Reject close",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    homeData['pendingCloses'][index]['is_accept'] == null ? 
                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                         // isPendingClose ? "3 days left" : "3 days left to respond",
                          //////////// tough counting //////////////////////////////////////////////////////////
                          homeData['pendingCloses'][index]['day'] == 0 ? 
                          "3 days left to respond" : homeData['pendingCloses'][index]['day'] == 1 ? 
                          "2 days left to respond" : homeData['pendingCloses'][index]['day'] == 2 ? 
                          "1 days left to respond" : "0 days left to respond",
                          //////////// tough counting //////////////////////////////////////////////////////////
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 8,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                      ) : Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                         // isPendingClose ? "3 days left" : "3 days left to respond",
                          //////////// tough counting //////////////////////////////////////////////////////////
                          homeData['pendingCloses'][index]['day'] == 0 ? 
                          "3 days left" : homeData['pendingCloses'][index]['day'] == 1 ? 
                          "2 days left" : homeData['pendingCloses'][index]['day'] == 2 ? 
                          "1 days left" : "0 days left to respond",
                          //////////// tough counting //////////////////////////////////////////////////////////
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 8,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        //height: 15,
                        margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                        child: Divider(
                          color: Colors.black,
                          height: 2,
                          thickness: 0.15,
                          //indent: 20,
                          endIndent: 0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push( context, MaterialPageRoute( builder: (context) => ProfileBioPage(homeData['pendingCloses'][index]['case_info']['id'])));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 0, right: 0, top: 0, bottom: 10),
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              homeData['pendingCloses'][index]['case_info']['profile_picture'] == null
                                ? Container(
                                  //padding: EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        borderRadius: BorderRadius.circular(100)),
                                    height: 33,
                                    width: 33,
                                    child: Center(
                                        child: Text(
                                      "${homeData['pendingCloses'][index]['case_info']['first_name'][0].toUpperCase()}${homeData['pendingCloses'][index]['case_info']['last_name'][0].toUpperCase()}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontFamily: "quicksand",
                                          fontWeight: FontWeight.w600),
                                    )),
                                  )
                                :
                              Container(
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                    color: selectedColor,
                                    image: DecorationImage(
                                        image: AssetImage("assets/image/baby3.png"),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(100)),
                                height: 33,
                                width: 33,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "${homeData['pendingCloses'][index]['case_info']['first_name']} ${homeData['pendingCloses'][index]['case_info']['last_name']}",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: mainColor.withOpacity(0.6),
                                              fontSize: 10,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          homeData['pendingCloses'][index]['case_info']['placements'] == null ? "${homeData['pendingCloses'][index]['case_info']['age']} yo" :
                                          "${homeData['pendingCloses'][index]['case_info']['placements']['placement_type']} - ${homeData['pendingCloses'][index]['case_info']['age']} yo",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: mainColor,
                                              fontSize: 8,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w500),
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
                    ],
                  ),
                );
                  },
                  
                  childCount: homeData['pendingCloses'].length,
                ),
              ),

//////////////////////////////pendingCloses Cards Ends//////////


/////////////////////////////newMemberRequest Cards start//////////

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                     return Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
                  //padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "New Member Request",
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: 15,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text(
                                        "${homeData['newMemberRequest'][index]['user_info']['first_name']} ${homeData['newMemberRequest'][index]['user_info']['last_name']} has requested to join this case",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: 12,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => YourProfilePage(homeData['newMemberRequest'][index]['user_info']['id'])));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 0, right: 0, top: 0, bottom: 10),
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              homeData['newMemberRequest'][index]['user_info']['profile_picture'] == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        borderRadius: BorderRadius.circular(100)),
                                    height: 33,
                                    width: 33,
                                    child: Center(
                                        child: Text(
                                      "${homeData['newMemberRequest'][index]['user_info']['first_name'][0].toUpperCase()}${homeData['newMemberRequest'][index]['user_info']['last_name'][0].toUpperCase()}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontFamily: "quicksand",
                                          fontWeight: FontWeight.w600),
                                    )),
                                  )
                                :
                              Container(
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                    color: selectedColor,
                                    image: DecorationImage(
                                        image: AssetImage("assets/image/baby4.png"),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(100)),
                                height: 33,
                                width: 33,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "${homeData['newMemberRequest'][index]['user_info']['first_name']} ${homeData['newMemberRequest'][index]['user_info']['last_name']}",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: mainColor.withOpacity(0.6),
                                              fontSize: 10,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "${homeData['newMemberRequest'][index]['user_info']['user_type']}",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontSize: 8,
                                                  fontFamily: "quicksand",
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            // Text(
                                            //   " - 12 yo",
                                            //   textAlign: TextAlign.start,
                                            //   overflow: TextOverflow.ellipsis,
                                            //   style: TextStyle(
                                            //       color: mainColor,
                                            //       fontSize: 8,
                                            //       fontFamily: "quicksand",
                                            //       fontWeight: FontWeight.w500),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        margin: EdgeInsets.only(top: 0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                 memberInviteButton ? null : _acceptNewMemberInvite(homeData['newMemberRequest'][index]);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5, right: 7.5),
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 14, right: 14),
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    "Accept request",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: "quicksand",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                 memberInviteButton ? null : _rejectNewMemberInvite(homeData['newMemberRequest'][index]);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5, left: 7.5),
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 14, right: 14),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF9423A),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    "Reject request",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: "quicksand",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        //height: 15,
                        margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                        child: Divider(
                          color: Colors.black,
                          height: 2,
                          thickness: 0.15,
                          //indent: 20,
                          endIndent: 0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileBioPage(homeData['newMemberRequest'][index]['case_info']['id'])));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 0, right: 0, top: 0, bottom: 10),
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              homeData['newMemberRequest'][index]['case_info']['profile_picture'] == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        borderRadius: BorderRadius.circular(100)),
                                    height: 33,
                                    width: 33,
                                    child: Center(
                                        child: Text(
                                      "${homeData['newMemberRequest'][index]['case_info']['first_name'][0].toUpperCase()}${homeData['newMemberRequest'][index]['case_info']['last_name'][0].toUpperCase()}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontFamily: "quicksand",
                                          fontWeight: FontWeight.w600),
                                    )),
                                  )
                                :
                              Container(
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                    color: selectedColor,
                                    image: DecorationImage(
                                        image: AssetImage("assets/image/baby3.png"),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(100)),
                                height: 33,
                                width: 33,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "${homeData['newMemberRequest'][index]['case_info']['first_name']} ${homeData['newMemberRequest'][index]['case_info']['last_name']}",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: mainColor.withOpacity(0.6),
                                              fontSize: 10,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          "${homeData['newMemberRequest'][index]['user_info']['user_type']} - ${homeData['newMemberRequest'][index]['case_info']['age']} yo",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: mainColor,
                                              fontSize: 8,
                                              fontFamily: "quicksand",
                                              fontWeight: FontWeight.w500),
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
                    ],
                  ),
                );
                  },
                  
                  childCount: homeData['newMemberRequest'].length,
                ),
              ),

//////////////////////////////newMemberRequest Cards Ends//////////


              
            ],
          ),
        ),
      ),
      
    );
  }

  Future<Null> _showCaseDialog(number, pendingRemovalSS, index) async {
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
                      child: Image.asset(number == 1
                          ? "assets/image/accept_removal.png"
                          : "assets/image/accept_close.png")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    "Are you sure?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff003A5B),
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Text(
                    number == 1
                        ? "Do you really want to leave this case? You will not be able to join again without requesting to join."
                        : "You are agreeing to close this case. You will not be able to change your response.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff7A98A9),
                        fontWeight: FontWeight.w400,
                        fontSize: 11),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(
                                top: 0, bottom: 20, left: 0, right: 2.5),
                            decoration: BoxDecoration(
                              color: Color(0xffF8F8F8),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text("Cancel",
                                style: TextStyle(
                                    color: Color(0xff003A5B),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "quicksand"))),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            if (number == 1) {
                              _acceptRemoval(pendingRemovalSS);//_showRemovalDialog(1);
                            } else {
                              _acceptClose(pendingRemovalSS, index); //// actually its pendingClose
                              //_showCloseDialog(1);
                            }
                          },
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  top: 0, bottom: 20, left: 2.5, right: 0),
                              decoration: BoxDecoration(
                                color: Color(0xffF9423A),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(number == 1 ? "Leave" : "Accept",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "quicksand"))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<Null> _showRemovalDialog(number, member) async {
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
                      child: Image.asset(number == 1
                          ? "assets/image/accept_removal.png"
                          : "assets/image/reject_removal.png")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    number == 1 ? "You have left the case" : "Reject Removal",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff003A5B),
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Text(
                    number == 1
                        ? "You have successfully left the case and will no longer have access to it. If this was a mistake, you will have to request to join again or be invited."
                        : "Removal rejected” and you are still part of this case. Contact with ${member['from_user_info']['first_name']} ${member['from_user_info']['last_name']} to see if your removal suggestion was made by mistake.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff7A98A9),
                        fontWeight: FontWeight.w400,
                        fontSize: 11),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white)),
                    child: Container(
                        width: 100,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(
                            top: 0, bottom: 20, left: 50, right: 50),
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

  Future<Null> _showCloseDialog(number) async {
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
                      child: Image.asset(number == 1
                          ? "assets/image/accept_close.png"
                          : "assets/image/unsuccess.png")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    number == 1 ? "Case pending close" : "New member rejected",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff003A5B),
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: Text(
                    number == 1
                        ? "Your decision has been logged. All other users have the opportunity to reject this action."
                        : "You have successfully rejected Jill Smith's attempt to join this case. They will have to request again to join or be invited if this was a mistake.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff7A98A9),
                        fontWeight: FontWeight.w400,
                        fontSize: 11),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      isPendingClose = true;
                    });
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
                            top: 0, bottom: 20, left: 50, right: 50),
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
  

////////////// New Member Request Dialog STart //////////
  Future<Null> _showMemberDialog(number, member) async {
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
                      child: Image.asset(number == 1
                          ? "assets/image/success.png"
                          : "assets/image/unsuccess.png")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    number == 1 ? "Success" : "New member rejected",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff003A5B),
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: Text(
                    number == 1
                        ? "${member['user_info']['first_name']} ${member['user_info']['last_name']} has been successfully added to this case"
                        : "You have successfully rejected ${member['user_info']['first_name']} ${member['user_info']['last_name']}'s attempt to join this case. They will have to request again to join or be invited if this was a mistake.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff7A98A9),
                        fontWeight: FontWeight.w400,
                        fontSize: 11),
                  ),
                ),
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
////////////// New Member Request Dialog End //////////


////////////// New Case Invite Dialog STart //////////
  Future<Null> _showNewCaseInviteDialog(number) async {
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
                      child: Image.asset(number == 1
                          ? "assets/image/success.png"
                          : "assets/image/accept_removal.png")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    number == 1 ? "Success" : "Invite rejected",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff003A5B),
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: Text(
                    number == 1
                        ? "You have successfully joined the case."
                        : "If you would like to join this case in the future, you will need to be invited or request to join.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff7A98A9),
                        fontWeight: FontWeight.w400,
                        fontSize: 11),
                  ),
                ),
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
////////////// New Case Invite Dialog End //////////


  ////////////////////////  Log Out Start  //////////////////////
  void _logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    //Navigator.push(context, SlideRightRoute(page: LoginPage()));
  }
  ///////////////////////////  Log Out End /////////////////////////
  



////////////////////////  Accept New case Invite STart  //////////////////////
  
  void _acceptNewCaseInvite(newCAseInvite) async {
    setState(() {
      caseInviteButton = true;
    });
    var data = {
      'email': userData['email'],
      'case_general_id': newCAseInvite['case_general_id'],
      'to_user' : newCAseInvite['to_user'],
    };

    print(data);

    // setState(() {
    //   caseInviteButton = false;
    // });

    var res = await CallApi().postData(data, 'accepting_case_invite');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode != 200) {
      // show error msg
      print('error');
        setState(() {
      caseInviteButton = false;
    });
    // body['case_info']
    } else if(res.statusCode == 200 && body['msg'] == "Already Accepted"){
      print(body['msg']);
      setState(() {
      caseInviteButton = false;
    });
    }
     else if (res.statusCode == 200 && body['success'] == true ){
      _showNewCaseInviteDialog(1);
      store.state.homepageCaseState['caseGeneral'].add(body['data']);
      for(var d in store.state.homepageCaseState['New_Case_Invite']){
        if(d['case_general_id'] == newCAseInvite['case_general_id']){
          print(newCAseInvite['id']);
          store.state.homepageCaseState['New_Case_Invite'].remove(newCAseInvite);
          //print(store.state.homepageCaseState['New_Case_Invite']);
          break;
        }
      }
      setState(() {
      caseInviteButton = false;
    });
    }
    else{
      print("something went wrong");
      setState(() {
      memberInviteButton = false;
    });
    }
  }
////////////////////////  Accept New case Invite End /////////////////////////

////////////////////////  Reject New case Invite STart  //////////////////////
  
  void _rejectNewCaseInvite(newCAseInvite) async {
    setState(() {
      caseInviteButton = true;
    });
    var data = {
      'email': userData['email'],
      'case_general_id': newCAseInvite['case_general_id']
    };

    print(data);

    // setState(() {
    //   caseInviteButton = false;
    // });

    var res = await CallApi().postData(data, 'rejecting_case_invite');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode != 200) {
      // show error msg
      print('error');
        setState(() {
      caseInviteButton = false;
    });
    } else if (res.statusCode == 200 && body['success'] == true){
      _showNewCaseInviteDialog(2);
      for(var d in store.state.homepageCaseState['New_Case_Invite']){
        if(d['case_general_id'] == newCAseInvite['case_general_id']){
          print(newCAseInvite['id']);
          store.state.homepageCaseState['New_Case_Invite'].remove(newCAseInvite);
          //print(store.state.homepageCaseState['New_Case_Invite']);
          break;
        }
      }
      setState(() {
      caseInviteButton = false;
    });
    }else{
      print('did not work');
      setState(() {
      memberInviteButton = false;
    });
    }
  }
////////////////////////  Reject New case Invite End /////////////////////////
  


////////////////////////  Accept New Member Invite STart  //////////////////////
  
  void _acceptNewMemberInvite(newMemberRequesT) async {
    setState(() {
      memberInviteButton = true;
    });
    var data = {
      'newMemberRequest_id': newMemberRequesT['id'],
      'user_id': newMemberRequesT['user_id'],
      'case_general_id': newMemberRequesT['case_general_id']
    };

    print(data);
    // _showMemberDialog(1, newMemberRequesT );

    // setState(() {
    //   memberInviteButton = false;
    // });

    var res = await CallApi().postData(data, 'accept_pending_add');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode != 200) {
      // show error msg
      print('error');
        setState(() {
      memberInviteButton = false;
    });
    } else if (res.statusCode == 200 && body['msg'] == "Already Accepted"){
      print(body['msg']);
      setState(() {
      memberInviteButton = false;
    });
    }
    else if (res.statusCode == 200 && body['success'] == true){
      _showMemberDialog(1, newMemberRequesT );
      for(var d in store.state.homepageCaseState['newMemberRequest']){
        if(d['id'] == newMemberRequesT['id']){
          print(newMemberRequesT['id']);
          store.state.homepageCaseState['newMemberRequest'].remove(newMemberRequesT);
          //print(store.state.homepageCaseState['New_Case_Invite']);
          break;
        }
      }
      setState(() {
      memberInviteButton = false;
    });
    }else{
      print('did not work');
      setState(() {
      memberInviteButton = false;
    });
    }
  }
////////////////////////  Accept New Member Invite End /////////////////////////

////////////////////////  Reject New Member Invite STart  //////////////////////
  
  void _rejectNewMemberInvite(newMemberRequesT) async {
    setState(() {
      memberInviteButton = true;
    });
    var data = {
      'newMemberRequest_id': newMemberRequesT['id']
    };

    print(data);
    // _showMemberDialog(2, newMemberRequest );

    // setState(() {
    //   memberInviteButton = false;
    // });

    var res = await CallApi().postData(data, 'reject_pending_add');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode != 200) {
      // show error msg
      print('error');
        setState(() {
      memberInviteButton = false;
    });
    } else if (res.statusCode == 200 && body['success'] == true){
      _showMemberDialog(2, newMemberRequesT );
      for(var d in store.state.homepageCaseState['newMemberRequest']){
        if(d['id'] == newMemberRequesT['id']){
          print(newMemberRequesT['id']);
          store.state.homepageCaseState['newMemberRequest'].remove(newMemberRequesT);
          //print(store.state.homepageCaseState['New_Case_Invite']);
          break;
        }
      }
      setState(() {
      memberInviteButton = false;
    });
    }else{
      print('did not work');
      setState(() {
      memberInviteButton = false;
    });
    }
  }
////////////////////////  Reject New Member Invite End /////////////////////////


////////////////////////  Removal Reject  STart  //////////////////////
  
  void _rejectRemoval(pendingRemovalS) async {
    setState(() {
      removalButton = true;
    });
    var data = {
      'id': pendingRemovalS['id'],
      'case_general_id': pendingRemovalS['case_general_id'],
      'member_id': pendingRemovalS['to_user'],
    };

    print(data);
    //  _showRemovalDialog(2, pendingRemovalS);

    // setState(() {
    //   removalButton = false;
    // });

    var res = await CallApi().postData(data, 'reject_removal');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode != 200) {
      // show error msg
      print('error');
        setState(() {
      removalButton = false;
    });
    } else if (res.statusCode == 200 && body['success'] == true){
       _showRemovalDialog(2, pendingRemovalS);
      for(var d in store.state.homepageCaseState['pendingRemovals']){
        if(d['id'] == pendingRemovalS['id']){
          print(pendingRemovalS['id']);
          store.state.homepageCaseState['pendingRemovals'].remove(pendingRemovalS);
          //print(store.state.homepageCaseState['New_Case_Invite']);
          break;
        }
      }
      setState(() {
      removalButton = false;
    });
    }else{
      print('did not work');
      setState(() {
      removalButton = false;
    });
    }
  }
//////////////////////// Removal Reject End /////////////////////////

////////////////////////  Removal Accept  STart  //////////////////////
  
  void _acceptRemoval(pendingRemovalS) async {
    setState(() {
      removalButton = true;
    });
    var data = {
      'id': pendingRemovalS['id'],
      'case_general_id': pendingRemovalS['case_general_id'],
      'member_id': pendingRemovalS['to_user'],
    };

    //print(data);

    // setState(() {
    //   removalButton = false;
    // });

    var res = await CallApi().postData(data, 'accept_removal');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode != 200) {
      // show error msg
      print('error');
        setState(() {
      removalButton = false;
    });
    } else if (res.statusCode == 200 && body['success'] == true){
       _showRemovalDialog(1, pendingRemovalS);
      for(var d in store.state.homepageCaseState['pendingRemovals']){
        if(d['id'] == pendingRemovalS['id']){
          print(pendingRemovalS['id']);
          store.state.homepageCaseState['pendingRemovals'].remove(pendingRemovalS);
          //print(store.state.homepageCaseState['New_Case_Invite']);
          break;
        }
      }
       for(var d in store.state.homepageCaseState['caseGeneral']){
        if(d['id'] ==  pendingRemovalS['case_general_id']){
          print(d);
          store.state.homepageCaseState['caseGeneral'].remove(d);
          //print(store.state.homepageCaseState['New_Case_Invite']);
          break;
        }
      }
      for(var d in store.state.homepageCaseState['withdrawalRequest']){
        if(d['case_general_id'] ==  pendingRemovalS['case_general_id']){
          print(d);
          store.state.homepageCaseState['withdrawalRequest'].remove(d);
          //print(store.state.homepageCaseState['New_Case_Invite']);
          break;
        }
      }
      setState(() {
      removalButton = false;
    });
    }else{
      print('did not work');
      setState(() {
      removalButton = false;
    });
    }
  }
//////////////////////// Removal Accept End /////////////////////////



////////////////////////  Close Reject  STart  //////////////////////
  
  void _rejectClose(pendingCloseS, index) async {
    setState(() {
      closeButton = true;
    });
    var data = {
      'case_general_id': pendingCloseS['case_general_id'],
      'to_user': pendingCloseS['to_user'],
    };
//_showCloseDialog(1);
    print(data);
    //_showCloseDialog(1);

    // setState(() {
    //   closeButton = false;
    // });
    

    var res = await CallApi().postData(data, 'reject_close');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode != 200) {
      // show error msg
      _errorDialog("Something went wrong");
        setState(() {
      closeButton = false;
    });
    } else if (res.statusCode == 200 && body['success'] == true){
       _showCloseDialog(1);
      for(var d in store.state.homepageCaseState['pendingCloses']){
        if(d['id'] == pendingCloseS['id']){
          print(pendingCloseS['is_accept']);
          store.state.homepageCaseState['pendingCloses'][index]['is_accept'] = 0;
          print(store.state.homepageCaseState['pendingCloses'][index]['is_accept']);
          //print(store.state.homepageCaseState['New_Case_Invite']);
          break;
        }
      }
      setState(() {
      closeButton = false;
    });
    }else{
      print('did not work');
      _errorDialog("Something went wrong");
      setState(() {
      closeButton = false;
    });
     }
  }
//////////////////////// Close Reject End /////////////////////////


////////////////////////  Close Accept  STart  //////////////////////
  
  void _acceptClose(pendingCloseS, index) async {
    setState(() {
      closeButton = true;
    });
    var data = {
      'case_general_id': pendingCloseS['case_general_id'],
      'to_user': pendingCloseS['to_user'],
    };

    // print(data);
    // _showCloseDialog(1);
    // setState(() {
    //   closeButton = false;
    // });

     var res = await CallApi().postData(data, 'accept_close');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode != 200) {
      // show error msg
      _errorDialog("Something went wrong");
        setState(() {
      closeButton = false;
    });
    } else if (res.statusCode == 200 && body['success'] == true){
       _showCloseDialog(1);
      for(var d in store.state.homepageCaseState['pendingCloses']){
        if(d['id'] == pendingCloseS['id']){
          print(pendingCloseS['is_accept']);
          store.state.homepageCaseState['pendingCloses'][index]['is_accept'] = 1;
          print(store.state.homepageCaseState['pendingCloses'][index]['is_accept']);
          //print(store.state.homepageCaseState['New_Case_Invite']);
          break;
        }
      }
      setState(() {
      closeButton = false;
    });
    }else{
      print('did not work');
      _errorDialog("Something went wrong");
      setState(() {
      closeButton = false;
    });
     }
  }
//////////////////////// Close Accept End /////////////////////////



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
                      child: Image.asset("assets/image/accept_close.png")),
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
