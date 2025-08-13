
// const String kBaseURL = "http://pspaintservices.pspa.local/mobile_api/"; // PSPA Staging
const String kBaseURL = "http://pspaservices.sapphirecs.net:8081/mobile_api/"; // Staging
const String kMediaBaseURL = "http://pspaservices.sapphirecs.net:8081/";
//TODO also update app name and package name to PSPA Beta



const String kLoginURL = "${kBaseURL}login";

const String kConnectionCheckURL = "${kBaseURL}check_connection";

// const String kTokenURL = "${kBaseURL}oauth/token/";

const String kGetDivisionListURL = '${kBaseURL}divisions';
const String kGetDistrictListURL = "${kBaseURL}districts_by_division";
const String kGetTalukaListByDistrictIdURL = "${kBaseURL}talukas_by_district";
const String kGetUnionCouncilListByTalukaIdURL = "${kBaseURL}ucs_by_taluka";
const String kGetVillageListByUcIdURL = "${kBaseURL}villages_by_uc";
const String kGetDehListByUCIdURL = "${kBaseURL}deh/";

const String kGetComplaintTypeURL = '${kBaseURL}complaint_types';
const String kGetProgramsURL = '${kBaseURL}programs';
const String kGetProgramsDetailURL = '${kBaseURL}program/show';
const String kGetProgramImagePathByIdURL = '${kBaseURL}program_image';
const String kIntakeRegistrationURL = '${kBaseURL}intake_registration/create';
const String kGetProgramEligibilityCriteriaURL = '${kBaseURL}intake_registration/get-eligbility-criteria-by-program';
const String kGetIntakeRegisteredUsersList = '${kBaseURL}intake_registration/index';
const String kGetBenefitForList = '${kBaseURL}intake_registration/benefit-for';
const String kGetUsersByCnicAndBenefitFor = '${kBaseURL}intake_registration/search-by-cnic';
const String kGetEligibilityCriteriaGroupsURL = '${kBaseURL}program_eligibility_criterias_new';

const String kGetSchemeTypeURL = "${kBaseURL}program-type";

const String kDeleteMediaUrlURL = "${kBaseURL}media/delete/";
const String kVersionCheckURL = "${kBaseURL}get_latest_version";
