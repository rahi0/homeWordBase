class AppState {
 

  ///  state where you want to store
  var userInfoState; 
  var homepageCaseState; 
  var biographicalInfoState; 
  var commonLogInfoState; 
  var legalInfoState;
  var caseMemberInfoState;
  var medicalInfoState;
  var dentalInfoState;
  var therapyInfoState;
  var educationInfoState;
  var logInfoState;
  var appointmentInfoState;
  var caseInfoState;
  var appointmentDetailsInfoState;
  var appointmentAddPepState;
  var logSearchState;
 


  AppState(
      {
       this.userInfoState,
       this.homepageCaseState,
       this.biographicalInfoState,
       this.commonLogInfoState,
       this.legalInfoState,
       this.caseMemberInfoState,
       this.medicalInfoState,
       this.dentalInfoState,
       this.therapyInfoState,
       this.educationInfoState,
       this.logInfoState,
       this.appointmentInfoState,
       this.caseInfoState,
       this.appointmentDetailsInfoState,
       this.appointmentAddPepState,
       this.logSearchState
      });

  AppState copywith(
      {userInfoState, homepageCaseState,biographicalInfoState, commonLogInfoState,legalInfoState, 
      caseMemberInfoState, medicalInfoState, dentalInfoState, therapyInfoState, educationInfoState,
      logInfoState, appointmentInfoState, caseInfoState, appointmentDetailsInfoState,
      appointmentAddPepState, logSearchState}) {


    return AppState(
      userInfoState: userInfoState ?? this.userInfoState,
      homepageCaseState: homepageCaseState ?? this.homepageCaseState,
      biographicalInfoState: biographicalInfoState ?? this.biographicalInfoState,
      commonLogInfoState: commonLogInfoState ?? this.commonLogInfoState,
      legalInfoState: legalInfoState ?? this.legalInfoState,
      caseMemberInfoState: caseMemberInfoState ?? this.caseMemberInfoState,
      medicalInfoState: medicalInfoState ?? this.medicalInfoState,
      dentalInfoState: dentalInfoState ?? this.dentalInfoState,
      therapyInfoState: therapyInfoState ?? this.therapyInfoState,
      educationInfoState: educationInfoState ?? this.educationInfoState,
      logInfoState: logInfoState ?? this.logInfoState,
      appointmentInfoState: appointmentInfoState ?? this.appointmentInfoState,
      caseInfoState: caseInfoState ?? this.caseInfoState,
      appointmentDetailsInfoState: appointmentDetailsInfoState ?? this.appointmentDetailsInfoState,
      appointmentAddPepState: appointmentAddPepState ?? this.appointmentAddPepState,
      logSearchState: logSearchState ?? this.logSearchState
     
    );
  }
}
