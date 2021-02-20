import 'package:flutter/material.dart';

import '../../../main.dart';
import 'BiographicalPage/BiographicalPage.dart';
import 'DentalPage/DentalPage.dart';
import 'EducationPage/EducationPage.dart';
import 'LegalPage/LegalPage.dart';
import 'MedicalPage/MedicalPage.dart';
import 'TherapyPage/TherapyPage.dart';

class BiographicalProfilePage extends StatefulWidget {
  final caseId;
  BiographicalProfilePage(this.caseId);
  @override
  _BiographicalProfilePageState createState() =>
      _BiographicalProfilePageState();
}

class _BiographicalProfilePageState extends State<BiographicalProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 6,
        child: Container(
          margin: EdgeInsets.only(top: 0),
          child: Column(
            children: <Widget>[
              Container(
                //height: 15,
                margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                child: Divider(
                  color: Colors.black,
                  height: 2,
                  thickness: 0.15,
                  //indent: 20,
                  endIndent: 0,
                ),
              ),
              Container(
                child: new Material(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: new TabBar(
                      isScrollable: true,
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: selectedColor,
                      ),
                      tabs: [
                        new Tab(
                          text: "Biographical",
                        ),
                        new Tab(
                          text: "Medical",
                        ),
                        new Tab(
                          text: "Dental",
                        ),
                        new Tab(
                          text: "Therapy",
                        ),
                        new Tab(
                          text: "Education",
                        ),
                        new Tab(
                          text: "Legal",
                        ),
                      ],
                      indicatorColor: selectedColor,
                      unselectedLabelColor: Color(0xff354D5B),
                      unselectedLabelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                      indicator: UnderlineTabIndicator(
                        borderSide:
                            BorderSide(width: 1.5, color: selectedColor),
                      ),
                      labelColor: selectedColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(children: [
                  BiographicalPage(widget.caseId), 
                  MedicalPage(widget.caseId),
                  DentalPage(widget.caseId),
                  TherapyPage(widget.caseId),
                  EducationPage(widget.caseId),
                  LegalPage(widget.caseId),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
