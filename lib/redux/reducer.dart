
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/redux/states.dart';

AppState reducer(AppState state, dynamic action){

  if(action is UserInfoAction){
    return state.copywith(
      userInfoState: action.userInfoAction  ///// your updating list where you store by applying logic 
    );
  } 

  if(action is HomepageCaseAction){
    return state.copywith(
      homepageCaseState: action.homepageCaseAction  ///// your updating list where you store by applying logic 
    );
  } 

  if(action is BiographicalInfoAction){
    return state.copywith(
      biographicalInfoState: action.biographicalInfoAction  ///// your updating list where you store by applying logic 
    );
  } 


  if(action is CommonLogAction){
    return state.copywith(
      commonLogInfoState: action.commonLogAction  ///// your updating list where you store by applying logic 
    );
  }


  if(action is LegalInfoAction){
    return state.copywith(
      legalInfoState: action.legalInfoAction  ///// your updating list where you store by applying logic 
    );
  } 


   if(action is CaseMemberInfoAction){
    return state.copywith(
      caseMemberInfoState: action.caseMemberInfoAction  ///// your updating list where you store by applying logic 
    );
  } 


  if(action is MedicalInfoAction){
    return state.copywith(
      medicalInfoState: action.medicalInfoAction  ///// your updating list where you store by applying logic 
    );
  }


  if(action is DentalInfoAction){
    return state.copywith(
      dentalInfoState: action.dentalInfoAction  ///// your updating list where you store by applying logic 
    );
  }

  if(action is TherapyInfoAction){
    return state.copywith(
      therapyInfoState: action.therapyInfoAction  ///// your updating list where you store by applying logic 
    );
  }

  if(action is EducationInfoAction){
    return state.copywith(
      educationInfoState: action.educationInfoAction  ///// your updating list where you store by applying logic 
    );
  }

  if(action is LogInfoAction){
    return state.copywith(
      logInfoState: action.logInfoAction  ///// your updating list where you store by applying logic 
    );
  }

  if(action is AppointmentInfoAction){
    return state.copywith(
      appointmentInfoState: action.appointmentInfoAction  ///// your updating list where you store by applying logic 
    );
  }

  if(action is CaseInfoAction){
    return state.copywith(
      caseInfoState: action.caseInfoAction  ///// your updating list where you store by applying logic 
    );
  }

  if(action is AppointmentDetailsInfoAction){
    return state.copywith(
      appointmentDetailsInfoState: action.appointmentDetailsInfoAction  ///// your updating list where you store by applying logic 
    );
  }

  if(action is AppointmentAddPepAction){
    return state.copywith(
      appointmentAddPepState: action.appointmentAddPepAction  ///// your updating list where you store by applying logic 
    );
  }

  if(action is LogSearchAction){
    return state.copywith(
      logSearchState: action.logSearchAction  ///// your updating list where you store by applying logic 
    );
  }

  return state;
} 
