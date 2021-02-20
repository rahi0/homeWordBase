import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:homewardbase/screens/RequestSentPage/RequestSentPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';

class PlacementAddPeopleScreen extends StatefulWidget {
  @override
  _PlacementAddPeopleScreenState createState() =>
      _PlacementAddPeopleScreenState();
}

class _PlacementAddPeopleScreenState extends State<PlacementAddPeopleScreen> {

  bool isLoading = true;
  bool noData = false;
  var userList;
  List userFinalList = [];

  @override
  void initState() {
    super.initState();
    _getUsers();
    //menuSelected = 0;
  }


  _getUsers() async {

    setState(() {
      isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    //print(user);
    
    var res = await CallApi().getData('get_all_user');
    final body = json.decode(res.body);
    //var homePageData;
    print(body);
     if(body['status'] == 'Token is Expired'){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
      else if (res.statusCode != 200) {

     // print("Something went wrong");
      setState(() {
      isLoading = false;
      });
    }
    else if (res.statusCode == 200 && body['User'].length >= 1) { 

    //  print(body['User']);
      //if (body != null) {
      //  store.dispatch(HomepageCaseAction(body)); // update data in store...
      //  print(body['caseGeneral']);
      //  print(store.state.homepageCaseState);
      //  if (!mounted) return;
      //  setState(() {
      //    homeData = store.state.homepageCaseState;
      //  });
     // }
     setState(() {
      userList = body['User'];
     // isLoading = false;
      });

      // for(var d in userList){                 ///////////////// If user exist..remove from the list
      //   if(d['id'] == user['id']){
      //     userList.remove(d); 
      //     break;
      //   }
      // }
      // // var toRemoveList1 = userList.where((val) => val['id'] == user['id']).toList();
      // var toRemoveList1 = [];
      // for(var d in userList) {                   ///////////////// If userlist have store id..add to the list
      //   for(var p in store.state.biographicalInfoState['people_of_placements']){
      //     if(d['id'] == p['people_info']['id']) toRemoveList1.add(d);
      //   }
      // }
      // print(toRemoveList1.length);
      // for(var x in toRemoveList1){                 ///////////////// remove 2nd step List
      //   userList = userList.where((val) => val['id'] != x['id']).toList();
      // }
      
      userList = userList.where((val) => val['id'] != user['id']).toList();
      userList = userList.where((val){
        bool keep = true;
        store.state.biographicalInfoState['people_of_placements'].forEach((p){ 
          if (val['id'] ==  p['people_info']['id']) keep = false;
        });
        return keep;
      }
      ).toList();


      setState(() {
      //userList = body['User'];
      isLoading = false;
      });
    }
    else if (res.statusCode == 200 && body['User'].length <= 0) {

      setState(() {
      noData = true;
      isLoading = false;
      });
    }
    else{
      print("else o asi");
      setState(() {
      isLoading = false;
      });
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator()
      ),
    ) : Scaffold(
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
            "Add People",
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
      body: noData ? Container(
      color: Colors.white,
      child: Center(
        child: Text(
            "No data found",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "quicksand",
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
      ),
    ) : SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                  children: List.generate(userList.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                             //checkPotentialList.add(index);
                      if (userList[index]['checked'] == false) {
                        userList[index]['checked'] = true;
                       // print({'people_info' : userList[index]});
                        store.state.biographicalInfoState['people_of_placements'].add({'people_info' : userList[index]});
                        store.dispatch(BiographicalInfoAction(store.state.biographicalInfoState));
                      } else {
                        userList[index]['checked'] = false;
                        for (var d in store.state.biographicalInfoState['people_of_placements']){
                          if(d['people_info']['id'] == userList[index]['id']){
                            store.state.biographicalInfoState['people_of_placements'].remove(d);
                            store.dispatch(BiographicalInfoAction(store.state.biographicalInfoState));
                            break;
                          }
                        }
                        
                      }
                    });
                  },
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20, right: 5),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      color: 
                                      userList[index]
                                                  ['checked'] ==
                                              true
                                          ? mainColor
                                          : 
                                          Color(0xffD4DDE3),
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: EdgeInsets.all(2),
                                  child: Icon(Icons.done,
                                      color: 
                                      userList[index]
                                                  ['checked'] ==
                                              true
                                          ? Colors.white
                                          : 
                                          Color(0xffD4DDE3),
                                      size: 15)),

                              userList[index]['profile_picture'] == null
                                ? Container(
                                  margin: EdgeInsets.only(left: 20),
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        borderRadius: BorderRadius.circular(100)),
                                    height: 45,
                                    width: 45,
                                    child: Center(
                                        child: Text(
                                      "${userList[index]['first_name'][0].toUpperCase()}${userList[index]['last_name'][0].toUpperCase()}",
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
                                            "assets/image/pm2.png"),
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
                                                  "${userList[index]['first_name']} ${userList[index]['last_name']}",
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
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                "${userList[index]['user_type']}",
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
                                        userList[index]['organization'] == null ? "" :
                                        "${userList[index]['organization']}",
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
                            ],
                          ),
                        ),
                        userList.length - 1 == index
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
          ]),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.pop(context);
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
                      fontSize: 16,
                      fontFamily: "quicksand",
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// _getUsers() async {

//     setState(() {
//       isLoading = true;
//     });

//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var userJson = localStorage.getString('user');
//     var user = json.decode(userJson);
//     //print(user);
    
//     var res = await CallApi().getData('get_all_user');
//     final body = json.decode(res.body);
//     //var homePageData;
//     print(body);
//      if(body['status'] == 'Token is Expired'){
//         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
//       }
//       else if (res.statusCode != 200) {

//       print("Something went wrong");
//       setState(() {
//       isLoading = false;
//       });
//     }
//     else if (res.statusCode == 200 && body['User'].length >= 1) {

//     //  print(body['User']);
//       //if (body != null) {
//       //  store.dispatch(HomepageCaseAction(body)); // update data in store...
//       //  print(body['caseGeneral']);
//       //  print(store.state.homepageCaseState);
//       //  if (!mounted) return;
//       //  setState(() {
//       //    homeData = store.state.homepageCaseState;
//       //  });
//      // }
//      setState(() {
//       userList = body['User'];
//      // isLoading = false;
//       });

//       // for(var d in userList){
//       //   if(d['id'] == user['id']){
//       //     userList.remove(d);
//       //     break;
//       //   }
//       // }
//       //userList = userList.where((val) => val['id'] != user['id']).toList();
//       // userList = userList
//       //     .where((val){
//       //       if(val['id'] != user['id']) return true;
//       //       store.state.biographicalInfoState['people_of_placements'].forEach((p) => {
//       //         if(val['id'] != p['people_info']['id']) return true
//       //       });
//       //     })
//       //     .toList();

//       // true = accept
//       // false = remove
//       // 8 - 2

//       userList = userList.where((val){
//          print("1  ${val['id']}${user['id']}");
//         // print(user['id']);
//         if( val['id'] != user['id']) {
//           store.state.biographicalInfoState['people_of_placements'].forEach((p){
//           // print('2 ' + val['id'] + ' ' +p['people_info']['id']);
//           print("2  ${val['id']} ${p['people_info']['id']}");
//             if(val['id'] != p['people_info']['id']) return true;
//             // return false;
//           });
//         }
//         return false;
//       } 
//       ).toList();


//       setState(() {
//       //userList = body['User'];
//       isLoading = false;
//       });
//     //  store.dispatch(CaseGeneralAction(body['caseGeneral'])); // update data in store...
//       //add the fresh copy in local storage
//       // SharedPreferences localStorage = await SharedPreferences.getInstance();
//       // localStorage.setString(key, json.encode(body));
//     }
//     else if (res.statusCode == 200 && body['User'].length <= 0) {

//       setState(() {
//       noData = true;
//       isLoading = false;
//       });
//     }
//     else{
//       print("else o asi");
//       setState(() {
//       isLoading = false;
//       });
//     }

    
//   }
