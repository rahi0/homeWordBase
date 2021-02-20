import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:homewardbase/redux/reducer.dart';
import 'package:homewardbase/redux/states.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:homewardbase/screens/SplashScreen/SplashScreen.dart';
import 'package:redux/redux.dart';




///////  store initialization///////////////
final store = Store<AppState>(
  reducer,
  initialState: AppState(
      userInfoState: {},
      homepageCaseState: {},
      biographicalInfoState: {},
      commonLogInfoState: {},
      legalInfoState: {},
      medicalInfoState: {},
      dentalInfoState: {},
      educationInfoState: {},
      logInfoState: {},
      caseMemberInfoState: {},
      therapyInfoState: {},
      appointmentInfoState: {},
      caseInfoState: {},
      appointmentDetailsInfoState: {},
      appointmentAddPepState: {},
      logSearchState: {}

     ),
);

Color mainColor = Color(0xFF003A5B);
Color subColor = Color(0xFFF6FFFC);
Color selectedColor = Color(0xFF7AE1BF);
Color unselectedColor = Color(0xFF9EC2C4);
Color itemColor = Color(0xFFf5fffb);
Color itemSelectedColor = Color(0xFFe9f9f7);
Color backColor = Color(0xFFBEF0DF);
Color progColor = Color(0xFF47AAAE);

int bottomNavIndex = 0;
int addCasePage = 1;
int menuSelected = 0;
List listLanguage = [];
List listRace = [];
var currentDrawer = 'cases';
////
var genEthnicity = "";
List genListLanguage = [];
var genRace = "";
var placementType = '';
List siblingsList = [];
////
List doctorList = [];
List conditionList = [];
List immunizationList = [];
List allergyList = [];
List medicationList = [];
List medicaInsuranceList = [];
/////
List dentalDocList = [];
List dentalConsitionList = [];
/////
List therapyDoctorList = [];
/////
List educationList = [];
////////////////////logFilter////


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(mainColor);
    return StoreProvider<AppState>(
      store: store,
      child: StoreConnector<AppState, AppState>(  ////// this is the connector which mainly changes state/ui
            converter: (store) => store.state,
            builder: (context, items) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
        ); }
      ),
    );
  }
}
