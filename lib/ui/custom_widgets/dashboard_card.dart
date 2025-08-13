import 'package:flutter/material.dart';

Expanded dashboardCard({String title="Title",Color shadowColor=const Color(0xff0F663E), String iconPath='assets/icons/programs.png',required VoidCallback onTap}) {
  return Expanded(
    child: GestureDetector(
      onTap:onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(color: const Color(0xffF4F3FF),borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: shadowColor,blurRadius: 0,offset: const Offset(8, 6)),BoxShadow(color: shadowColor,blurRadius: 0,offset: const Offset(8, 0))]),
        margin: const EdgeInsets.only(right: 8,top: 20),
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20),
              boxShadow:  const [BoxShadow(color: Colors.black12,blurRadius: 10,offset: Offset(0, 10))]),
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 60,width: 60,padding: const EdgeInsets.only(left: 7),child: Image.asset(iconPath)),
              const SizedBox(height: 5),
              Text(title,textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 2,
                  style:  const TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color(0xff000000)))
            ],
          ),
        ),
      ),
    ),
  );
}
