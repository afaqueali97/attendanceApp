class VersionCheckModel{
  String androidVersion = "";
  String whatsNew = "";
  bool isNecessary = false;

  VersionCheckModel.empty();
  // {
  //   androidVersion = '0.0.2';
  //   whatsNew = 'Added Limit in Scheme Progress Images;Madadgar data auto populate in Scheme Screen;Minor Bug Fixing';
  //   isNecessary = false;
  // }

  VersionCheckModel.fromJson(Map<String, dynamic> json) {
    androidVersion = json["app_version"] ??"";
    whatsNew = json["new_feature"] ??"";
    isNecessary = "${json["is_necessary"]}" == "1";
  }
}