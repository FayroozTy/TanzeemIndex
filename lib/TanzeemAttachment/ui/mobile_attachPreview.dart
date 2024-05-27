


import 'dart:async';
import 'dart:convert';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';


import '../../Util/Constant.dart';
import '../Model/Attachment.dart';
class mobile_attachPreview extends StatefulWidget{
final String fileUrl ;


final  imgList;
// final  docList;
final count;

  mobile_attachPreview(this.fileUrl , this.imgList,this.count);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _mobile_attachPreviewScreen(this.fileUrl, this.imgList,this.count);
  }

}

class _mobile_attachPreviewScreen extends State<mobile_attachPreview> {

  final String fileUrl ;
  final  imgList;
// final  docList;
  final count;

  _mobile_attachPreviewScreen(this.fileUrl, this.imgList,this.count);



  @override
  void initState() {
    super.initState();

  }


  @override
  void dispose() {

    super.dispose();

  }

  shareImageToprint(String url) async {


    final url_link = Uri.parse(url);


    await Share.share(url);
  }

  @override
  Widget build(BuildContext context) {


    return  Scaffold(
        resizeToAvoidBottomInset: true,


        appBar: AppBar(

            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.print,color: Colors.white,),
                  onPressed: () =>{  shareImageToprint(fileUrl)},

                ),
              ),
            ],

            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            automaticallyImplyLeading: false,

            backgroundColor: CustomColors.colorPrimary,
            title: Center(
              child: Text(
                textScaleFactor: textScaleFactor,
                " الوثائق ",
                style:  Theme.of(context).textTheme.barTextStyles,
              ),
            )),


        body:

        Container(color:  Color(0xFF7D5E5E).withOpacity(0.25),

          child:


          fileUrl != ""? InkWell(
            onTap: (){

            },
            child:


            PhotoViewGallery.builder(
              itemCount: count,
              enableRotation: true,
              builder: (BuildContext context, int index) {
                return
              PhotoViewGalleryPageOptions(
                  imageProvider: imgList[index]
            ,



              initialScale: PhotoViewComputedScale.contained * 0.8,
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
              heroAttributes: PhotoViewHeroAttributes(tag: index),

              );
            },
           // scrollPhysics: BouncingScrollPhysics(),
            loadingBuilder: (context, event) => Center(
            child: Container(
            width: 20.0,
            height: 20.0,
            child: const CircularProgressIndicator(),
            ),
            ),
            backgroundDecoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            ),
            )


            )

          : Container(),
          //  child:

          // Card(
          //   clipBehavior: Clip.antiAliasWithSaveLayer,
          //   child: SizedBox(
          //
          //
          //     child: Image.network(
          //       AttachList[0],
          //       fit: BoxFit.fill,
          //     ),
          //   ),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(14.0),
          //   ),
          // // elevation: 5,
          //
          // ),

          // GridView.builder(
          //     itemCount: AttachList.length,
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 3),
          //     itemBuilder: (context, index) {
          //       return Padding(
          //         padding: EdgeInsets.all(5),
          //         child:
          //
          //
          //         GestureDetector(
          //           onTap: () {
          //
          //
          //             // AttachList[index]
          //
          //             NetworkimgList_tapped.clear();
          //
          //             NetworkimgList_tapped.add(NetworkImage(AttachList[index]));
          //             print("NetworkimgList_tapped${NetworkimgList_tapped.length}");
          //
          //             Navigator.push(context, MaterialPageRoute(builder: (_) {
          //               return DetailScreen(NetworkimgList_tapped,1);
          //             }));
          //
          //           },
          //           child: Container(
          //             width: 335,
          //
          //
          //
          //             child:
          //             Card(
          //               clipBehavior: Clip.antiAliasWithSaveLayer,
          //               child: SizedBox(
          //
          //
          //                 child: Image.network(
          //                   AttachList[index],
          //                   fit: BoxFit.fill,
          //                 ),
          //               ),
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(10.0),
          //               ),
          //               elevation: 5,
          //
          //             ),
          //           ),
          //         ),
          //
          //
          //
          //       )
          //
          //
          //
          //       ;
          //
          //
          //
          //     }),


        )



    );


  }







  showAlertDialog(BuildContext context, String title, String content) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("موافق"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return OutlineInputBorder( //Outline border type for TextFeild
      // borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color:Colors.grey,
          width: 0.6,
        )
    );
  }
}
