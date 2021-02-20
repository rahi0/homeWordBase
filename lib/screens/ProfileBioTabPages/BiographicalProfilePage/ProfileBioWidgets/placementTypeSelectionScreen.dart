import 'package:flutter/material.dart';
import 'package:homewardbase/main.dart';

class PlacementTypeSelectionScreen extends StatefulWidget {
  @override
  _PlacementTypeSelectionScreenState createState() =>
      _PlacementTypeSelectionScreenState();
}

class _PlacementTypeSelectionScreenState
    extends State<PlacementTypeSelectionScreen> {
  List placementTypeList = [
    {'placementType': 'Adoptive'},
    {'placementType': 'Foster'},
    {'placementType': 'Residential'},
    {'placementType': 'Emergency'},
  ];

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
                    "Placement Type",
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
                    placementType = '';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(right: 0, left: 0),
                  child: Center(
                      child: Text(
                    "Clear All",
                    style: TextStyle(
                        color: Color(0xff7A98A9),
                        fontSize: 13,
                        fontFamily: "quicksand",
                        fontWeight: FontWeight.w400),
                  )),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
            children: List.generate(placementTypeList.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                if (placementType == placementTypeList[index]['placementType']) {
                  placementType = '';
                } else {
                  placementType = placementTypeList[index]['placementType'];
                }
                print(placementType);
              });
            },
            child: Container(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 5),
              margin: EdgeInsets.only(right: 0, left: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Container(
                      child: Text(
                        "${placementTypeList[index]['placementType']}",
                        style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: 14,
                            fontFamily: "quicksand",
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  placementType == placementTypeList[index]['placementType']
                      ? Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(3)),
                          child:
                              Icon(Icons.done, color: Colors.white, size: 14),
                        )
                      : Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                              color: Color(0xffD4DDE3),
                              borderRadius: BorderRadius.circular(3)))
                ],
              ),
            ),
          );
        })),
      ),
      bottomNavigationBar: Wrap(
        children: <Widget>[
          Container(
            //height: 15,
            margin: EdgeInsets.only(left: 0, right: 0, top: 5),
            child: Divider(
              color: Colors.black,
              height: 2,
              thickness: 0.1,
              //indent: 20,
              endIndent: 0,
            ),
          ),
          GestureDetector(
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
                      "OK",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
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
    );
  }
}
