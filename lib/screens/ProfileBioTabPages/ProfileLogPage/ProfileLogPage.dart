import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/FileShowingPage/FileShowingPage.dart';
import 'package:homewardbase/screens/LogFilterPage/LogFilterPage.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';

class ProfileLogPage extends StatefulWidget {
  final caseId;
  ProfileLogPage(this.caseId);
  @override
  _ProfileLogPageState createState() => _ProfileLogPageState();
}

class _ProfileLogPageState extends State<ProfileLogPage> {
  bool isLoading = true;
  bool noData = false;
  var logPageData;
  var user;
  bool searchOpen = false;
  bool isSerching = false;

  String searchLog = "";
  TextEditingController searchLogController = new TextEditingController();


   @override
  void initState() {
    super.initState();
    _getLogData();
  }


  _getLogData() async {

    setState(() {
      isLoading = true;
      educationList = []; ///////////// have to fill it after getting response
    });

   SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    user = json.decode(userJson);
    //print(user);
    var data = {
      'case_general_id' : widget.caseId,
      'user_id' : user['id']
    };

   
    var res = await CallApi().postData(data, 'get_all_Logs');
    final body = json.decode(res.body);
    //var homePageData;
    //print(body);
     if(body['status'] == 'Token is Expired'){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
      else if (res.statusCode != 200) {

      print("Something went wrong");
      setState(() {
      isLoading = false;
      });
    }
    else if (res.statusCode == 200) {

       store.dispatch(LogInfoAction(body)); // update data in store...
       
       if (!mounted) return;
       setState(() {
         logPageData = store.state.logInfoState['Log'];
       });
       print(logPageData);

    setState(() {
      isLoading = false;
      });
    }
    else if (res.statusCode == 400) {
      print("beng amar");
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


// setState(() {
//       isLoading = false;
//       });
    
  }
  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator()
      ),
    ) :
    SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 20),
              //margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
              padding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
              child: TextField(
                // onChanged: (value) {
                //   if(value == ""){
                //     setState(() {
                //       searchOpen = false;
                //     });
                //   }else{
                //     setState(() {
                //       searchOpen = true;
                //     });
                //   }
                // },
                onSubmitted: (value){
                  _searchLogButton();
                  setState(() {
                      searchOpen = true;
                    });
                  // if(value == ""){
                  //   setState(() {
                  //     searchOpen = false;
                  //   });
                  // }else{
                  //   setState(() {
                  //     searchOpen = true;
                  //   });
                  // }
                },
                controller: searchLogController,
                textInputAction: TextInputAction.search,
                autofocus: false,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontSize: 17,
                    fontFamily: 'quicksand',
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  prefixIcon: Container(
                    padding: EdgeInsets.only(
                        left: 10, top: 10, right: 10, bottom: 10),
                    margin: EdgeInsets.only(left: 10),
                    child: Image.asset(
                      'assets/image/search1.png',
                      height: 12,
                      width: 12,
                    ),
                  ),
                  suffixIcon: Wrap(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogFilterPage())); 
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 10, top: 10, right: 10, bottom: 10),
                          margin: EdgeInsets.only(left: 10, top: 5),
                          child: Image.asset(
                            'assets/image/filter1.png',
                            height: 16,
                            width: 16,
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: 5, top: 10, right: 10, bottom: 10),
                          child: Icon(
                            Icons.done_all,
                            color: Color(0xff354D5B),
                          )),
                    ],
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(
                      color: Color(0xff354D5B),
                      fontSize: 17,
                      fontFamily: 'quicksand',
                      fontWeight: FontWeight.w400),
                  // labelStyle: TextStyle(
                  //     color: Color(0xff7A98A9),
                  //     fontSize: 15,
                  //     fontFamily: 'quicksand',
                  //     fontWeight: FontWeight.w500),
                  // labelText: "Old Password",
                  contentPadding: EdgeInsets.fromLTRB(12.0, 12, 12.0, 12),
                  border: InputBorder.none,
                ),
              ),
            ),

            searchOpen ? 
            ///////////////////////////// Search Result Log Start ////////////////
            isSerching ? Container(
              height: MediaQuery.of(context).size.height/2.5,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ) :
            Column(
                children: List.generate(store.state.logSearchState.length, (index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 10, right: 10, bottom: 10),
                      margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          color: selectedColor,
                          borderRadius: BorderRadius.circular(100)),
                      child: Image.asset(
                        store.state.logSearchState[index]['LogType'] == "Event" ?
                              'assets/image/calendar2.png' : store.state.logSearchState[index]['LogType'] == "Update" ? 'assets/image/redo.png' : 'assets/image/money.png',
                        height: 14,
                        width: 14,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              // margin: EdgeInsets.only(
                              //     right: logList[index]['status'] == "added"
                              //         ? 150
                              //         : 100),
                               margin: EdgeInsets.only( right: 100),
                              child: Text(
                                store.state.logSearchState[index]['LogType'] == "Event" ? 
                                      'An event "${store.state.logSearchState[index]['message']}" took place' :
                                      store.state.logSearchState[index]['LogType'] == "Update" ? 

                                       user['id'] == store.state.logSearchState[index]['user_info']['id'] ?
                                     "You${store.state.logSearchState[index]['message']}" : 
                                     "${store.state.logSearchState[index]['user_info']['first_name']} ${store.state.logSearchState[index]['message']}" : 

                                     user['id'] == store.state.logSearchState[index]['user_info']['id'] ?
                                     "You added to the log" :
                                     "${store.state.logSearchState[index]['user_info']['first_name']} ${store.state.logSearchState[index]['user_info']['last_name']} added to the log",
                                style: TextStyle(
                                    color: mainColor,
                                    fontSize: 12,
                                    fontFamily: "quicksand",
                                    // fontWeight:
                                    //     logList[index]['status'] == "event"
                                    //         ? FontWeight.w700
                                    //         : FontWeight.w500
                                    fontWeight:FontWeight.w700
                                    ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "${DateFormat("dd/MM/yyyy").format(DateTime.parse(store.state.logSearchState[index]['created_at']))}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff003A5B),
                                        fontSize: 12,
                                        fontFamily: "quicksand",
                                        fontWeight: FontWeight.w400),
                                  ),
                                  store.state.logSearchState[index]['LogType'] == "Log"
                                      ? Container(
                                                child: Row(
                                                 children: List.generate(store.state.logSearchState[index]['log_tags'].length, (ind){
                                                    return Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.25),
                                                  borderRadius: BorderRadius.circular( 100)),
                                                  padding: EdgeInsets.only(left: 5, top: 5,right: 5,bottom: 5),
                                                  margin: EdgeInsets.only(left: 0,top: 0,right: 5),
                                                  child: Image.asset(
                                                 // store.state.logSearchState[index]['log_tags'].length >= 1 &&
                                                  store.state.logSearchState[index]['log_tags'][ind]['tag'] == "Biographical" ?
                                                   'assets/image/growth1.png' :
                                                  store.state.logSearchState[index]['log_tags'][ind]['tag'] == "Medical" ?
                                                   'assets/image/stetho.png' :
                                                   store.state.logSearchState[index]['log_tags'][ind]['tag'] == "Dental" ?
                                                   'assets/image/teeth1.png' :
                                                   store.state.logSearchState[index]['log_tags'][ind]['tag'] == "Therapy" ?
                                                   'assets/image/feather1.png' :
                                                   store.state.logSearchState[index]['log_tags'][ind]['tag'] == "Education" ?
                                                   'assets/image/lesson1.png' :
                                                   store.state.logSearchState[index]['log_tags'][ind]['tag'] == "Legal" ?
                                                   'assets/image/legal.png' :
                                                   'assets/image/calendar1.png',
                                                    height: 8,
                                                    width: 8,
                                                      ),
                                                    );
                                                  })
                                                ),
                                              )
                                            : 
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.25),
                                                  borderRadius: BorderRadius.circular( 100)),
                                                  padding: EdgeInsets.only(left: 5, top: 5,right: 5,bottom: 5),
                                                  margin: EdgeInsets.only(left: 10,top: 0,right: 5),
                                                  child: Image.asset(
                                                  store.state.logSearchState[index]['tag'] == "Biographical" ?
                                                   'assets/image/growth1.png' :
                                                   store.state.logSearchState[index]['tag'] == "Medical" ?
                                                   'assets/image/stetho.png' :
                                                   store.state.logSearchState[index]['tag'] == "Dental" ?
                                                   'assets/image/teeth1.png' :
                                                   store.state.logSearchState[index]['tag'] == "Therapy" ?
                                                   'assets/image/feather1.png' :
                                                   store.state.logSearchState[index]['tag'] == "Education" ?
                                                   'assets/image/lesson1.png' :
                                                   store.state.logSearchState[index]['tag'] == "Legal" ?
                                                   'assets/image/legal.png' :
                                                   'assets/image/calendar1.png',
                                                    height: 8,
                                                    width: 8,
                                                      ),
                                                    ),
                                ],
                              ),
                            ),
                            store.state.logSearchState[index]['LogType'] == "Log"
                                ? Container(
                                    margin: EdgeInsets.only(top: 15, right: 10),
                                    child: Text(
                                      store.state.logSearchState[index]['description'] == null ? "" : "${store.state.logSearchState[index]['description']}",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          color: Color(0xff003A5B),
                                          fontSize: 12,
                                          fontFamily: "quicksand",
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                : Container(),
                           store.state.logSearchState[index]['LogType'] == "Log"
                                ? Container(
                                    margin:
                                        EdgeInsets.only(bottom: 20, top: 15),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      child: Wrap(
                                        children: List.generate(
                                            store.state.logSearchState[index]['log_documents'].length, (ind) {
                                          return GestureDetector(
                                                  onTap: (){
                                                    store.state.logSearchState[index]['log_documents'][ind]['extension'] == "pdf" ?
                                                    _launchURL(store.state.logSearchState[index]['log_documents'][ind]['url']) :
                                                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => FullScreenImage(store.state.logSearchState[index]['log_documents'][ind]['url'])));
                                                   
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 0, right: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        store.state.logSearchState[index]['log_documents'][ind]['extension'] == "pdf" ?
                                                        Container(
                                                          height: 95,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                              color: Color(0xffECF0F3),
                                                              borderRadius:BorderRadius.circular(5)
                                                              ),
                                                          child: Image.asset(
                                                                  "assets/image/pdf.png",
                                                                  fit: BoxFit.contain,
                                                                  ),
                                                        ) :
                                                        Container(
                                                          height: 95,
                                                          width: 105,
                                                          decoration: BoxDecoration(
                                                              color: Color(0xffECF0F3),
                                                              borderRadius:BorderRadius.circular(5)
                                                              ),
                                                          child: store.state.logSearchState[index]['log_documents'][ind]['url'] == null ?
                                                          Container() :
                                                          Hero(
                                                            tag: '${store.state.logSearchState[index]['log_documents'][ind]['url']}',
                                                            child: Image.network(
                                                                    CallApi().fileShowlurl +
                                                                    '${store.state.logSearchState[index]['log_documents'][ind]['url']}',
                                                                    fit: BoxFit.contain,
                                                                    loadingBuilder: (context, child, progress){
                                                                      return progress == null ?
                                                                      child : LinearProgressIndicator();
                                                                    },
                                                                    ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Container(
                                                          width: store.state.logSearchState[index]['log_documents'][ind]['extension'] == "pdf"? 80 : 105,
                                                          child: Text(
                                                            "${store.state.logSearchState[index]['log_documents'][ind]['doc_name']}.${store.state.logSearchState[index]['log_documents'][ind]['extension']}",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff354D5B),
                                                                fontFamily:
                                                                    "quicksand",
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                        }),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }))
            ///////////////////////////// Search Result Log Start ////////////////
            :
            //////////////////////////////////////////// Log Portion Start /////////////////////////////////////////
            Column(
                children: List.generate(logPageData.length, (index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 10, right: 10, bottom: 10),
                      margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          color: selectedColor,
                          borderRadius: BorderRadius.circular(100)),
                      child: Image.asset(
                        logPageData[index]['LogType'] == "Event" ?
                              'assets/image/calendar2.png' : logPageData[index]['LogType'] == "Update" ? 'assets/image/redo.png' : 'assets/image/money.png',
                        height: 14,
                        width: 14,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              // margin: EdgeInsets.only(
                              //     right: logList[index]['status'] == "added"
                              //         ? 150
                              //         : 100),
                               margin: EdgeInsets.only( right: 100),
                              child: Text(
                                logPageData[index]['LogType'] == "Event" ? 
                                      'An event "${logPageData[index]['message']}" took place' :
                                      logPageData[index]['LogType'] == "Update" ? 

                                       user['id'] == logPageData[index]['user_info']['id'] ?
                                     "You${logPageData[index]['message']}" : 
                                     "${logPageData[index]['user_info']['first_name']} ${logPageData[index]['message']}" : 

                                     user['id'] == logPageData[index]['user_info']['id'] ?
                                     "You added to the log" :
                                     "${logPageData[index]['user_info']['first_name']} ${logPageData[index]['user_info']['last_name']} added to the log",
                                style: TextStyle(
                                    color: mainColor,
                                    fontSize: 12,
                                    fontFamily: "quicksand",
                                    // fontWeight:
                                    //     logList[index]['status'] == "event"
                                    //         ? FontWeight.w700
                                    //         : FontWeight.w500
                                    fontWeight:FontWeight.w700
                                    ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "${DateFormat("dd/MM/yyyy").format(DateTime.parse(logPageData[index]['created_at']))}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff003A5B),
                                        fontSize: 12,
                                        fontFamily: "quicksand",
                                        fontWeight: FontWeight.w400),
                                  ),
                                  logPageData[index]['LogType'] == "Log"
                                      ? Container(
                                                child: Row(
                                                 children: List.generate(logPageData[index]['log_tags'].length, (ind){
                                                    return Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.25),
                                                  borderRadius: BorderRadius.circular( 100)),
                                                  padding: EdgeInsets.only(left: 5, top: 5,right: 5,bottom: 5),
                                                  margin: EdgeInsets.only(left: 0,top: 0,right: 5),
                                                  child: Image.asset(
                                                 // logPageData[index]['log_tags'].length >= 1 &&
                                                  logPageData[index]['log_tags'][ind]['tag'] == "Biographical" ?
                                                   'assets/image/growth1.png' :
                                                  logPageData[index]['log_tags'][ind]['tag'] == "Medical" ?
                                                   'assets/image/stetho.png' :
                                                   logPageData[index]['log_tags'][ind]['tag'] == "Dental" ?
                                                   'assets/image/teeth1.png' :
                                                   logPageData[index]['log_tags'][ind]['tag'] == "Therapy" ?
                                                   'assets/image/feather1.png' :
                                                   logPageData[index]['log_tags'][ind]['tag'] == "Education" ?
                                                   'assets/image/lesson1.png' :
                                                   logPageData[index]['log_tags'][ind]['tag'] == "Legal" ?
                                                   'assets/image/legal.png' :
                                                   'assets/image/calendar1.png',
                                                    height: 8,
                                                  width: 8,
                                                      ),
                                                    );
                                                  })
                                                ),
                                              )
                                            : 
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.25),
                                                  borderRadius: BorderRadius.circular( 100)),
                                                  padding: EdgeInsets.only(left: 5, top: 5,right: 5,bottom: 5),
                                                  margin: EdgeInsets.only(left: 10,top: 0,right: 5),
                                                  child: Image.asset(
                                                  logPageData[index]['tag'] == "Biographical" ?
                                                   'assets/image/growth1.png' :
                                                   logPageData[index]['tag'] == "Medical" ?
                                                   'assets/image/stetho.png' :
                                                   logPageData[index]['tag'] == "Dental" ?
                                                   'assets/image/teeth1.png' :
                                                   logPageData[index]['tag'] == "Therapy" ?
                                                   'assets/image/feather1.png' :
                                                   logPageData[index]['tag'] == "Education" ?
                                                   'assets/image/lesson1.png' :
                                                   logPageData[index]['tag'] == "Legal" ?
                                                   'assets/image/legal.png' :
                                                   'assets/image/calendar1.png',
                                                    height: 8,
                                                  width: 8,
                                                      ),
                                                    ),
                                ],
                              ),
                            ),
                            logPageData[index]['LogType'] == "Log"
                                ? Container(
                                    margin: EdgeInsets.only(top: 15, right: 10),
                                    child: Text(
                                      logPageData[index]['description'] == null ? "" : "${logPageData[index]['description']}",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          color: Color(0xff003A5B),
                                          fontSize: 12,
                                          fontFamily: "quicksand",
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                : Container(),
                           logPageData[index]['LogType'] == "Log"
                                ? Container(
                                    margin:
                                        EdgeInsets.only(bottom: 20, top: 15),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      child: Wrap(
                                        children: List.generate(
                                            logPageData[index]['log_documents'].length, (ind) {
                                          return GestureDetector(
                                                  onTap: (){
                                                    logPageData[index]['log_documents'][ind]['extension'] == "pdf" ?
                                                    _launchURL(logPageData[index]['log_documents'][ind]['url']) :
                                                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => FullScreenImage(logPageData[index]['log_documents'][ind]['url'])));
                                                   
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 0, right: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        logPageData[index]['log_documents'][ind]['extension'] == "pdf" ?
                                                        Container(
                                                          height: 95,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                              color: Color(0xffECF0F3),
                                                              borderRadius:BorderRadius.circular(5)
                                                              ),
                                                          child: Image.asset(
                                                                  "assets/image/pdf.png",
                                                                  fit: BoxFit.contain,
                                                                  ),
                                                        ) :
                                                        Container(
                                                          height: 95,
                                                          width: 105,
                                                          decoration: BoxDecoration(
                                                              color: Color(0xffECF0F3),
                                                              borderRadius:BorderRadius.circular(5)
                                                              ),
                                                          child: logPageData[index]['log_documents'][ind]['url'] == null ?
                                                          Container() :
                                                          Hero(
                                                            tag: '${logPageData[index]['log_documents'][ind]['url']}',
                                                            child: Image.network(
                                                                    CallApi().fileShowlurl +
                                                                    '${logPageData[index]['log_documents'][ind]['url']}',
                                                                    fit: BoxFit.contain,
                                                                    loadingBuilder: (context, child, progress){
                                                                      return progress == null ?
                                                                      child : LinearProgressIndicator();
                                                                    },
                                                                    ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Container(
                                                          width: logPageData[index]['log_documents'][ind]['extension'] == "pdf"? 80 : 105,
                                                          child: Text(
                                                            "${logPageData[index]['log_documents'][ind]['doc_name']}.${logPageData[index]['log_documents'][ind]['extension']}",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff354D5B),
                                                                fontFamily:
                                                                    "quicksand",
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                        }),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }))
            //////////////////////////////////////////// Log Portion End /////////////////////////////////////////
          ],
        ),
      ),
    );
  }
  _launchURL(urlsecondPart) async {
    var url = CallApi().fileShowlurl+"${urlsecondPart}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  /////////////////// pdf launch //////////////
  

  ///////////////////////// Search Log /////////////////////////
  void _searchLogButton() async{

    setState(() {
      isSerching = true;
    });

         var  data = {
          'case_general_id' : widget.caseId,
          'user_id' : user['id'],
          'text' : "${searchLogController.text}",
          'beginning': dateToBeginning == 'Beginning' ? null : DateFormat("yyyy-MM-dd").format(DateTime.parse("${DateFormat("dd-MM-yyyy").parse(dateToBeginning)}")),
          "present": dateToPresent == 'Present' ? null : DateFormat("yyyy-MM-dd").format(DateTime.parse("${DateFormat("dd-MM-yyyy").parse(dateToPresent)}")),
          "tag": checkedtagList,
          "type": checkedtypeList,
        };

        print(data);
        // setState(() {
        //   isSerching = false;
        // });


       var res = await CallApi().postData(data, 'filter_log');
       var body = json.decode(res.body);
       print(body);
    
        if (res.statusCode != 200) {
            setState(() {
                isSerching = false;
              });

              print("Something went wrong");
          }
          else if (res.statusCode == 200) {

            store.dispatch(LogSearchAction(body['result'])); // update data in store...
            setState(() {
              isSerching = false;
              });
            print("length 1 rebo");
              
          }
          else{
            print("Else o asi");
            setState(() {
                isSerching = false;
              });

          }
        
  }
  ///////////////////////// Search Log /////////////////////////
}
