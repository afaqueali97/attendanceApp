import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import '../../utils/app_colors.dart';


class FullImageViewScreen extends StatelessWidget{

  final String uri;
  final String desc;
  final String title;
  final Uint8List? imageBytes;

  const FullImageViewScreen({super.key, required this.uri, this.desc='', this.title = '', this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlackColor,
        body: Stack(
          children: [
        if(imageBytes != null && imageBytes!.isNotEmpty)
          PhotoView(
            imageProvider: MemoryImage(imageBytes!)
          )
        else if (uri.startsWith('http'))
         PhotoView(
           imageProvider:  NetworkImage(uri),
           minScale: PhotoViewComputedScale.contained,
           maxScale: PhotoViewComputedScale.covered * 3,
         )
         else
         PhotoView(
           imageProvider: FileImage(File(uri)),
           minScale: PhotoViewComputedScale.contained,
           maxScale: PhotoViewComputedScale.covered * 3,
         ),
         Padding(
           padding: const EdgeInsets.only(left: 12, top: 12),
           child: GestureDetector(
             onTap: ()=> Get.back(),
             child: const Icon(Icons.arrow_back_sharp, color: kWhiteColor, size: 28,),
           ),
         ),
         Visibility(
           visible: title.isNotEmpty || desc.isNotEmpty,
           child: Align(
             alignment: Alignment.bottomCenter,
             child: Container(
               color: kBlack45Color,
               width: Get.width,
               padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24, top: 8),
               child: Column(
                 // mainAxisAlignment: MainAxisAlignment.end,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Visibility(
                       visible: title.isNotEmpty,
                       child: Text(title, style: const TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),)),
                   Visibility(
                       visible: title.isNotEmpty && desc.isNotEmpty,
                       child: const Divider(color: kWhiteColor,)),
                   Visibility(
                     visible: desc.isNotEmpty,
                     child: Padding(
                         padding: const EdgeInsets.only(left: 8),
                         child: Text(desc, style: const TextStyle(color: kFieldShadowColor),)),
                   ),
                 ],
               ),
             ),
           ),
         ),
          ],
        ),
      ),
    );
  }

}