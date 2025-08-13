class UserAttendanceModel{
  int id = 0;
  String userName = '';
  String userPicture = '';

  UserAttendanceModel.empty();
  UserAttendanceModel.named({this.id = 1,required this.userName,required this.userPicture,});

  @override
  String toString() {
    return 'UserModel{id: $id, userName: $userName, userPicture: $userPicture}';
  }
}