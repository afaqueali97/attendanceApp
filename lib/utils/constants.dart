/*Created By: Afaque Ali on 05-Aug-2023*/

const String kAppName = "Attendance Beta"; //
///*********************  Route Names   *********************/
const String kSplashScreenRoute = "/";
const String kLoginScreenRoute = "/LOGIN_SCREEN";
const String kDashboardScreenRoute = "/DASHBOARD_SCREEN";
const String kTaskManagementScreenRoute = "/TASK_MANAGEMENT_SCREEN";
const String kTaskProgressScreenRoute = "/TASK_PROGRESS_SCREEN";
const String kTaskAddScreenRoute = "/TASK_ADD_SCREEN";
const String kIntakeRegistrationListScreenRoute = "/INTAKE_REGISTRATION_LIST_SCREEN";
const String kIntakeRegistrationScreenRoute = "/INTAKE_REGISTRATION_SCREEN";
const String kComplaintScreenRoute = "/COMPLAINT_SCREEN";
const String kSettingScreenRoute = "/SETTING_SCREEN"; 
const String kHomeScreenRoute = "/HOME_SCREEN";

// Public Routes
const String kProgramScreenRoute = "/PROGRAM_SCREEN";
const String kProgramDetailScreenRoute = "/PROGRAM_DETAIL_SCREEN";
const String kCheckCnicEligibilityRoute = "/CHECK_CNIC_ELIGIBILITY_SCREEN";
const String kAddComplaintRoute = "/ADD_COMPLAINT_SCREEN";
const String kAddEMemoScreenRoute = "/ADD_TASK_SCREEN";
const String kEMemoScreenRoute = "/E_MEMO_SCREEN";
const String kProgramEligibilityRoute = "/PROGRAM_ELIGIBILITY_SCREEN";
const String kEligibilityQuestionsRoute = "/ELIGIBILITY_QUESTIONS_SCREEN";

///routes for attendance app
const String kScanFaceScreenRoute = "/SCAN_FACE_SCREEN";
const String kRegisterUserScreenRoute  = "/REGISTER_USER_SCREEN_ROUTE";
const String kViewRegisteredUsersScreenRoute  = "/VIEW_REGISTERED_USERS_SCREEN_ROUTE";
const String kDeleteUserScreenRoute  = "/DELETE_USER_SCREEN_ROUTE";


const String kSyncScreenRoute = "/SYNC_SCREEN";

//User Routes
const String kAddUserComplaintScreenRoute = "/ADD_USER_COMPLAINT_SCREEN";
const String kRegistrationScreenRoute = "/REGISTRATION_SCREEN";
const String kSignInScreenRoute = "/SIGN_IN_SCREEN";

///*********************  User Messages   *********************///
const String kPermissionPermanentlyDenied =  "Permission is Permanently Denied\nPlease allow permission from settings and try again.";
const String kStoragePermissionDenied = "Allow Storage Permission to Save photos.";
const String kStoragePermissionDeniedForCamera = "Allow Storage Permission to Select photos.";
const String kCameraPermissionDenied = "Allow Camera Permission to Capture photos.";
const String kManageStoragePermissionDenied = "Allow Manage Storage Permission to Save photos.";
const String kPermissionDenied = "Permission Denied";
// const String kNoInternetMsg = 'No Internet Connection!';
const String kNoInternetMsg = 'Please Check Your Internet!';
const String kPoorInternetConnection = "Poor network connection detected. Please check your internet connection!";
const String kNetworkError = "Network Error. Please change your internet connection!";
// const String kServiceError = "Service Currently Unavailable, Our technical team is working on it. Please try again later.";
const String kServiceError = "Could not to Connect with Server.\nPlease try later.";
const String kErrorMessage = "Something went wrong, Please try again later.";
const String kCnicFrontErrorMsg = "CNIC Front Image is required!";
const String kCnicBackErrorMsg = "CNIC Back Image is required!";
const String kSessionExpireMsg = 'Session Expired\nPlease login Again.';






const double kFieldRadius = 16;
const double kFieldVerticalMargin = 4;

const int kMaxFileSize = 800; // Max scan result image size in KBs.
