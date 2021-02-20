import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/screens/AddCasePotentialmatch/AddCasePotentialmatch.dart';
import 'package:homewardbase/screens/ProfileBioPage/ProfileBioPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = new TextEditingController();
  bool showCrossSuffix = false;
  bool isPressed = false;
  bool noData = false;
  var data;
  var filterData;
  List result = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8FA),
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
                    "Search",
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
                  Navigator.pop(context);
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
      // bottomNavigationBar: GestureDetector(
      //   onTap: () {
      //      _searchButton();
      //   },
      //   child: Container(
      //     margin: EdgeInsets.all(20),
      //     child: Container(
      //       width: MediaQuery.of(context).size.width,
      //       padding: EdgeInsets.only(top: 15, bottom: 15),
      //       margin: EdgeInsets.only(top: 0),
      //       decoration: BoxDecoration(
      //           color: isPressed ? Colors.white : Color(0xFF7AE1BF),
      //           borderRadius: BorderRadius.circular(10),
      //           border: Border.all(color: Color(0xFF7AE1BF))),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: <Widget>[
      //           Text(
      //            isPressed ? "" : "Search",
      //             textAlign: TextAlign.center,
      //             style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 16,
      //                 fontFamily: "quicksand",
      //                 fontWeight: FontWeight.w700),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                            setState(() {
                              if (value.length >= 1){
                                _searchButton();
                                showCrossSuffix = true;
                              }
                              else
                                showCrossSuffix = false;
                            });
                          },
                          controller: searchController,
                          autofocus: false,
                          // onSubmitted: (value){
                          //   _searchButton();
                          // },
                          style: TextStyle(
                              color: Color(0xff003A5B).withOpacity(0.6),
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            // hintText: "Enter insurance name",
                            prefixIcon: Icon(Icons.search,
                                color: Color(0xff003A5B).withOpacity(0.6)),

                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  searchController.text = '';
                                  showCrossSuffix = false;
                                });
                              },
                              icon: Icon(Icons.close,
                                  color: showCrossSuffix
                                      ? Color(0xff003A5B).withOpacity(0.6)
                                      : Color(0xFFF8F8FA),),
                            ),
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
                            labelText: "Search",
                            contentPadding:
                                EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 15),
                child: Divider(
                  color: Colors.black,
                  height: 2,
                  thickness: 0.15,
                  endIndent: 0,
                ),
              ),
              ////////////////////// insuarnce name input field end //////////////////////////
              

              ///////////////////// List start ///////////////////
              Expanded(
                child: isPressed ?
                Container(
                      color: Colors.white,
                      child: Center(
                        child: CircularProgressIndicator()
                      ),
                    ) :

                    noData == true ?
                    Center(
                        child: Text(
                                        "No result found",
                                         style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontFamily: "quicksand",
                                            fontWeight: FontWeight.w600),
                                      )
                      ) :
                 SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    child: Column(
                      children: List.generate(result.length, (index) {
                    return Container(
                    child: GestureDetector(
                        onTap: () {
                          result[index]['is_member'] == "no" ?
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddCasePotentialmatch(result[index]['id']))) :
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileBioPage(result[index]['id'])));
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
                             result[index]['profile_picture'] == null
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: selectedColor,
                                          borderRadius: BorderRadius.circular(100)),
                                      height: 45,
                                      width: 45,
                                      child: Center(
                                          child: Text(
                                        "${result[index]['first_name'][0].toUpperCase()}${result[index]['last_name'][0].toUpperCase()}",
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
                                              image:NetworkImage(
                                                  CallApi().fileShowlurl +"${result[index]['profile_picture']}"),
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
                                          "${result[index]['first_name']} ${result[index]['last_name']}",
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
                                                 result[index]['placements'] == null ? "${result[index]['age']} yo" :
                                                result[index]['placements']['placement_type'] == null ? "${result[index]['age']} yo" :
                                              "${result[index]['placements']['placement_type']} - ${result[index]['age']} yo",
                                                
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
                              // Container(
                              //         margin: EdgeInsets.only(right: 5, left: 0),
                              //         //child: Image.asset("assets/image/boa.png"),
                              //         height: 23,
                              //         width: 23,
                              //         child: Icon(
                              //           Icons.notifications,
                              //           size: 18,
                              //           color: Color(0xffFFBA0D),
                              //         ),
                              //       )
                              //    : Container(),
                            ],
                          ),
                        ),
                      )
                  );
                  })
                    ),
                  ),
                ),
              )
              ///////////////////// List end ///////////////////
            ],
          ),
        ),
      ),
    );
  }


  void _searchButton() async{

    setState(() {
      isPressed = true;
      noData = false;
      result = [];
    });


        SharedPreferences localStorage = await SharedPreferences.getInstance();
        var filterJson = localStorage.getString('filter');
        // filterData = json.decode(filterJson);
        if (filterJson == null) {
          data = {
          'case_name': searchController.text,
          'to_age': 0,
          "from_age": 25,
          "placement_type": [],
          "gender": [],
          "language": [],
          "race": [],
          "ethnicity": [],
          "parental_right_status": [],
          "sibling_status": []
        };
          } 
          else {
 
          filterData = json.decode(filterJson);
           data = {
          'case_name': searchController.text,
          'to_age': filterData != null ? filterData['to_age'] : 0,
          "from_age": filterData['from_age'] != null ? filterData['from_age'] : 25,
          "placement_type": filterData['placement_type'] != null ? filterData['placement_type'] : [],
          "gender": filterData['gender'] != null ? filterData['gender'] : [],
          "language":filterData['language'] != null ? filterData['language'] : [],
          "race": filterData['race'] != null ? filterData['race'] : [],
          "ethnicity":filterData['ethnicity'] != null ? filterData['ethnicity'] : [],
          "parental_right_status": filterData['parental_right_status'] != null ? filterData['parental_right_status'] : [],
          "sibling_status": filterData['sibling_status'] != null ? filterData['sibling_status'] : [],
        };
       }

        print(data);
        setState(() {
          isPressed = false;
        });


       var res = await CallApi().postData(data, 'get_by_filter');
       var body = json.decode(res.body);
    
        if (res.statusCode != 200) {
            setState(() {
                isPressed = false;
              });

              print("Something went wrong");
          }
          else if (res.statusCode == 200 && body['data'].length == 0) {
            setState(() {
                noData = true;
                isPressed = false;
              });
              print("length nai");
              
          }
          else if (res.statusCode == 200 && body['data'].length >= 1) {
            setState(() {
              result = body['data'];
              isPressed = false;
              });
            print("length 1 rebo");
            print(body['data']);
              
          }
          else{
            print("Else o asi");
            // print(res.statusCode);
            // print(body['data']);
            _errorDialog('Something went wrong');
            setState(() {
                isPressed = false;
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
                      child: Image.asset("assets/image/accept_removal.png")),
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
