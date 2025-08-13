import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/custom_widget_controllers/browse_image_controller.dart';
import '../../models/image_model.dart';
import '../../services/web_services/general_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/b_camera_picker.dart';
import '../../utils/common_code.dart';
import 'custom_dialogs.dart';
import 'full_image_view_screen.dart';
import 'general_button.dart';

class CustomBrowseImageWidget extends StatelessWidget {

  final BrowseImageController controller;
  final double paddingHorizontal;
  final double paddingVertical;
  final bool readOnly;
  final bool onDownload;
  final bool withBrows;

  const CustomBrowseImageWidget({super.key,
    required this.controller,
    this.paddingHorizontal=4,
    this.readOnly=false,
    this.withBrows=false,
    this.onDownload=false,
    this.paddingVertical = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(text: controller.title,
                style: const TextStyle(color: kTextColor),
            children: controller.mandatory ? [
              const TextSpan(text: '*', style: TextStyle(color: kRequiredRedColor, fontWeight: FontWeight.bold))
            ] : null,
          )),
          const SizedBox(height: 5),
          // Text(controller.title, style: const TextStyle(color: kBlackColor, fontWeight: FontWeight.w500, fontSize: 14),),
          Obx(()=> Visibility(
              visible: controller.urls.length != controller.maxLength && !readOnly,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Visibility(
                    visible: withBrows,
                    child: SizedBox(
                      width: 120,
                      child: GeneralButton(
                        margin: 0,
                        radius: 6,
                        fontSize: 16,
                        text: 'Browse' ,
                        color: kPrimaryColor,
                        onPressed:() => _onBrowseButtonPressed(ImageSource.gallery),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed:() =>_onBrowseButtonPressed(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      backgroundColor: kPrimaryColor,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.camera_alt,color: Colors.white,),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Obx(() => controller.urls.isNotEmpty ? SizedBox(
              height: (Get.width/6)+24,
              child: ListView.builder(
                itemCount: controller.urls.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder:(context, index) => GestureDetector(
                  onTap: (){
                    if(controller.urls[index].imageData.isNotEmpty){
                    _onImageClicked(controller.urls[index]);
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 12, right: 11, left: 1),
                        width: Get.width/5,
                        height: Get.width/5,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          borderRadius:  BorderRadius.circular(2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Obx(
                            ()=> onDownload && controller.urls[index].imageData.isEmpty ?
                            GestureDetector(
                              onTap: (){
                                _onDownloadImage(index);
                              },
                              child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    controller.isImageLoading[index].value
                                    ? const SizedBox(height: 25, width: 25, child: CircularProgressIndicator(strokeWidth: 2,))
                                    : const Icon(
                                      Icons.cloud_download_outlined,
                                      color: kGreyColor,
                                    ),
                                    Text(
                                     controller.isImageLoading[index].value ? 'Downloading...' : 'Image',
                                      style: const TextStyle(
                                        color: kGreyColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                              ),
                            ) : _buildImageWidget(controller.urls[index]),
                          ),
                      ),
                    ),
                    Visibility(
                        visible: !readOnly,
                        child: Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: (){
                              _removedImage(controller.urls[index]);
                            },
                            child:  Container(
                              decoration: BoxDecoration(
                                color: kTextHintColor,
                                borderRadius:  BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(3),
                              child: const Icon(
                                Icons.clear,
                                color: kWhiteColor,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ) : const SizedBox()
          ),
          if(controller.hint!=null)
            Text(controller.hint!,  style: const TextStyle(color: kGreyColor, fontSize: 12),),
          Obx(()=> Text(controller.errorMessage.value, style: const TextStyle(color: kRequiredRedColor, fontSize: 12))),
        ],
      ),
    );
  }

  Future<void> _onDownloadImage(int index) async {
    controller.isImageLoading[index].value = true;
    ImageModel imageModel = await GeneralService().getDocById(controller.urls[index].id,"");
    controller.isImageLoading[index].value = false;
    if(imageModel.imageData.isNotEmpty) {
      controller.urls[index].filePath = imageModel.filePath;
      controller.urls[index].imageData = imageModel.imageData;
    }
  }

  Future<void> _removedImage(ImageModel imageModel) async {
    CustomDialogs().showAwesomeConfirmationDialog('Are you sure want to ${imageModel.filePath.isURL ? "delete" : "remove"} this image?', onOkBtnPressed: () async {
    // if(imageModel.filePath.isURL) {
    //     String result = await GeneralService().deleteFile(imageModel: imageModel);
    //     if(result == "Success") {
    //       controller.urls.remove(imageModel);
    //     }
    // } else{
    //   controller.urls.remove(imageModel);
    // }
    //   String result = await GeneralService().deleteFile(imageModel: imageModel);
    //   if(result == "Success") {
    //     controller.urls.remove(imageModel);
    //   }
    // if(imageModel.filePath.isURL) {
    //     String result = await GeneralService().deleteFile(id: imageModel.id);
    //     if(result == "Success") {
    //       controller.urls.remove(imageModel);
    //     }
    // } else{
    //   controller.urls.remove(imageModel);
    // }
      if(!controller.deletedUrls.any((element) => element.id == imageModel.id)) {
        controller.deletedUrls.add(imageModel);
      }

      controller.urls.remove(imageModel);
    });
    controller.urls.refresh();
    controller.validate();
  }

  Future<void> _onBrowseButtonPressed(ImageSource source) async {
    if(controller.maxLength==controller.urls.length){
      CommonCode().showToast(message: 'Max ${controller.maxLength} Attachment${controller.maxLength>1?'s are':'is'} allowed!');
      return;
    }
    String uri = '';
    final picker = ImagePicker();
    if(source == ImageSource.camera) {
      // XFile? pickedImageFile = await picker.pickImage(source: source);
      XFile? pickedImageFile;
       await availableCameras().then((value) async{
        if(value.isNotEmpty) {
         pickedImageFile= await Get.to(()=>  BCameraPicker(cameras: value));
        }
        });
        if (pickedImageFile != null) {
        uri = pickedImageFile!.path;
      }
      File? compressImage;
      if (uri.isNotEmpty) {
        compressImage = await CommonCode().compressImage(File(uri));
        if (compressImage.existsSync()) {
          // controller.urls.add(ImageModel(id: '${DateTime.now().millisecondsSinceEpoch}', filePath: compressImage.path));
          controller.urls.add(ImageModel(id: '', filePath: compressImage.path));
        }
      }
    }else{
      List<XFile> pickedImageFile = (await picker.pickMultiImage()).take(controller.maxLength-controller.urls.length).toList();
      for(var f in pickedImageFile) {
        uri = f.path;
        File? compressImage;
        if (uri.isNotEmpty) {
          compressImage = await CommonCode().compressImage(File(uri));
          if (compressImage.existsSync()) {
            // controller.urls.add(ImageModel(id: '${DateTime.now().millisecondsSinceEpoch}', filePath: compressImage.path));
            controller.urls.add(ImageModel(id: '', filePath: compressImage.path));
          }
        }
      }
    }
    controller.validate();
  }

  void _onImageClicked(ImageModel imageModel) {
    Get.to(()=>FullImageViewScreen(uri:imageModel.filePath , imageBytes: base64Decode(imageModel.imageData),));
  }
  Widget _buildImageWidget(ImageModel imageModel) {
    if (imageModel.imageData.isNotEmpty) {
      return Image.memory(
        base64Decode(imageModel.imageData),
        width: Get.width / 5,
        height: Get.width / 5,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Text(
              'Error: 404',
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
      );
    } else if (imageModel.filePath.isURL && imageModel.filePath.startsWith('http')) {
      return Image.network(
        imageModel.filePath,
        width: Get.width / 5,
        height: Get.width / 5,
        fit: BoxFit.cover,
        loadingBuilder: (c, w, p)=> (p == null) ? w:  Center(child: Image.asset('assets/icons_new/loadingd.gif', width: 30, height: 30)),
        errorBuilder: (c,o, ct) => const Icon(Icons.broken_image, color: kGreyColor),
      );
    } else if (imageModel.filePath.isNotEmpty) {
      return Image.file(
        File(imageModel.filePath),
        width: Get.width / 5,
        height: Get.width / 5,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Text(
              'Error: 404',
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
      );

    }
    return Container(); // Return an empty container if no valid image data is found
  }

  Widget buildImageContainer(int index) {
    return  Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(
              top: 12, right: 11, left: 1),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5),
            borderRadius: BorderRadius.circular(2),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: _buildImageWidget(controller.urls[index])
          ),
        ),
        Visibility(
          visible: !readOnly,
          child: Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                _removedImage(controller.urls[index]);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: kTextHintColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(3),
                child: const Icon(
                  Icons.clear,
                  color: kWhiteColor,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
