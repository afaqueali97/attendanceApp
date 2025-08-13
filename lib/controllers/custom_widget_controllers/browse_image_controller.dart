import 'package:get/get.dart';
import '../../models/image_model.dart';
import '../../utils/user_session.dart';


class BrowseImageController {

  RxString errorMessage=''.obs;
  String title;
  int maxLength;
  int minLength;
  String? hint;
  RxList<ImageModel> urls=RxList();
  RxList<ImageModel> deletedUrls = RxList();
  List<RxBool> isImageLoading = <RxBool>[].obs;

  bool mandatory;

  BrowseImageController({required this.title, this.mandatory=true, this.maxLength=5, this.minLength=1, this.hint});

  bool validate(){
    if(mandatory && urls.isEmpty){
      errorMessage.value = "$title is Required!";
    } else if(mandatory && urls.length < minLength){
      errorMessage.value = "Minimum $minLength Attachment${minLength == 1?' is': 's are'} Required!";
    } else {
      UserSession.isDataChanged.value = true;
      errorMessage.value = "";
    }
    return errorMessage.isEmpty;
  }

  Future<List<String>> onDeleteImages() async {
    List<String> ids = [];
    for(ImageModel imageModel in deletedUrls) {
      if(imageModel.filePath.isURL) {
        // String result = await GeneralService().deleteFile(imageModel: imageModel);
        // if (result == "Success") {
        //   ids.add(imageModel.id);
        //   CommonCode().showSuccessToast(message: "Image Deleted");
        // }
        // else{
        //   CommonCode().showToast(message: result);
        // }
      }
    }
    return ids;
  }

}
