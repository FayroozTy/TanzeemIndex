
import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
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
import 'package:shared_preferences/shared_preferences.dart';



import '../../Util/Constant.dart';
import '../Model/Attachment.dart';
import 'mobile_attachPreview.dart';
class AttachmentScreen extends StatefulWidget{


  final orderNumber;
  final manualFileNo;

  AttachmentScreen(this.orderNumber, this.manualFileNo);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AttachmentScreenScreen(this.orderNumber,this.manualFileNo);
  }

}

class _AttachmentScreenScreen extends State<AttachmentScreen> {


  final orderNumber;
  final manualFileNo;

  _AttachmentScreenScreen(this.orderNumber, this.manualFileNo);

  bool useMobileLayout = false;
  final NetworkimgList = [
  ];
  final NetworkimgList_tapped = [
  ];
  final desList_tapped = [
  ];
  List<String>AttachList = [];
  List<String>documentTypeDesc = [];
  List<Widget> imgList = [
  ];
  List<Attachment> attachment = [];
  List<Attachment> attachment_filterList = [];

  List<Attachment> search_attachment = [];
  bool _isLoading = false;
  int filter_flage = 0;

  TextEditingController  _searchcontroller = TextEditingController();

  int tappedIndex=0;
  String title = "";


  @override
  void initState() {
    super.initState();
    if((orderNumber == 0 || orderNumber == null) && (manualFileNo != 0 || manualFileNo != null)){
      title =   "رقم الملف" + ":  " +"$manualFileNo" ;
    }
    else if(( orderNumber != 0 || orderNumber!= null) && (manualFileNo == 0 || manualFileNo == null)){
      title = "رقم الطلب" + ":  " +"$orderNumber" ;
    }
    else if(( orderNumber != 0 || orderNumber!= null) && (manualFileNo != 0 || manualFileNo != null)){
      title =   "رقم الملف" + ": " +"$manualFileNo" + "  /  "  "رقم الطلب" + ": " +"$orderNumber" ;
    }



    getAttachList();
  }


  @override
  void dispose() {

    super.dispose();

  }

  getAttachList() async {

    search_attachment = [];
    attachment = [];
    attachment_filterList = [];
    imgList= [];
    AttachList = [];
    documentTypeDesc = [];
    NetworkimgList.clear();
    NetworkimgList_tapped.clear();

    setState(() {
      _isLoading = true;
    });
    // _showDialog(context, SimpleFontelicoProgressDialogType.normal, '');

    try {

      print("orderNumber$orderNumber");
      print("manualFileNo$manualFileNo");
      String url = "";

      if((orderNumber == 0 || orderNumber == null) && (manualFileNo != 0 || manualFileNo != null)){
        url = BaseURL + "api/Tanzeem/Attachments/" +"0/$manualFileNo" ;
      }
      else if(( orderNumber != 0 || orderNumber!= null) && (manualFileNo == 0 || manualFileNo == null)){
        url =  BaseURL +"api/Tanzeem/Attachments/" +"$orderNumber" ;
      }
      else if(( orderNumber != 0 || orderNumber!= null) && (manualFileNo != 0 || manualFileNo != null)){
        url =  BaseURL +"api/Tanzeem/Attachments/" +"$orderNumber/$manualFileNo" ;
      }


      http.Response
      response = await http.get(Uri.parse(url), headers: <String, String>{
        "Accept":
        "application/json",
        "Access-Control-Allow-Credentials":
        "*",
        "content-type":
        "application/json"
      });


      if (response.statusCode == 200) {
        //print(response.body);
        var json = jsonDecode(response.body);


        attachment =
            (json as List).map((x) => Attachment.fromJson(x))
                .toList();

        if(filter_flage == 0){
          setState(() {
            attachment.sort((a, b) => a.sortSequence!.compareTo(b.sortSequence!));

          });


        }else if(filter_flage == 1){
          setState(() {
            attachment.sort((a, b) => a.libIndex!.compareTo(b.libIndex !));

          });
        }

       //



        AttachList.add(attachment[0].fileUrl);

        for (var item in attachment) {
          String fileurl = item.fileUrl.toString();
          String docId = item.documentId.toString();
          String documentType_Desc = item.documentTypeDesc.toString();

          if(fileurl.contains("png") ||fileurl.contains("jpg") ){


            SharedPreferences prefs = await SharedPreferences.getInstance();
            String networkType = prefs.getString("network")??"";
            if(networkType == "external" ){
              NetworkimgList.add(NetworkImage("$fileurl"))  ;
            }
            else{
          //    String url = fileurl.replaceAll("http://83.244.112.170:5146", "http://192.168.0.128:5146");
              /////
              NetworkimgList.add(NetworkImage("$fileurl"))  ;
            }





            ///AttachList.add("$fileurl");
           /// documentTypeDesc .add(documentType_Desc);


          }
          else{
            //pdf, ......




          }

        }

        setState(() {

          _isLoading = false;
        });
        //  getListOrderTransComments( reciever_Contact_Person_ID, orderNo );
      }

      else{
        setState(() {
          _isLoading = false;
        });
        //  getListOrderTransComments( reciever_Contact_Person_ID, orderNo );

      }
    }


    catch (e) {
      print('Error : $e');
      showAlertDialog( context , "" , "لا تتوفر بيانات");
      setState(() {
        _isLoading = false;
      });
      return null;
    } finally {

    }



  }



  @override
  Widget build(BuildContext context) {

    final double shortsize = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = shortsize < 600 ;

    return  Scaffold(
        resizeToAvoidBottomInset: true,


        appBar: AppBar(

            actions: [
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                position: PopupMenuPosition.under,
                icon: Icon(Icons.filter_list, color: Colors.white,),
                itemBuilder: (BuildContext context) {
                  return[
                    PopupMenuItem(
                        onTap: (){
                          print('الترتيب حسب الورقة');

                            filter_flage = 0;
                          getAttachList();

                        },
                       // padding: EdgeInsets.all(5.0),
                        child: Row(
                          children: const [


                            Text('الترتيب حسب الورقة',style:  TextStyle(fontSize: 16,fontFamily: "Al-Jazeera-Arabic-Regular",color: Colors.black)),
                            SizedBox(width: 17,),
                            Icon(Icons.file_copy_outlined, color: Colors.black,),
                          ],
                        )
                    ),
                    PopupMenuItem(
                        onTap: (){

                            filter_flage = 1;
                            getAttachList();



                        },
                       // padding: EdgeInsets.all(5.0),
                        child: Row(
                          children: const [


                            Text("الترتيب حسب الادخال" ,style:  TextStyle(fontSize: 16,fontFamily: "Al-Jazeera-Arabic-Regular",color: Colors.black)),
                            SizedBox(width: 15,),
                            Icon(Icons.input, color: Colors.black),
                          ],
                        )
                    ),

                  ];
                },
              ),
            ],

            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            automaticallyImplyLeading: false,

            backgroundColor: CustomColors.colorPrimary,
            title:

            useMobileLayout?
            Center(
              child: Text(
                textScaleFactor: textScaleFactor,
                title,
                style:  TextStyle(fontSize: 14,fontFamily: "Al-Jazeera-Arabic-Regular",color: Colors.white)
              ),
            ): Center(
              child: Text(
                  textScaleFactor: textScaleFactor,
                  title,
                  style:  TextStyle(fontSize: 20,fontFamily: "Al-Jazeera-Arabic-Regular",color: Colors.white)
              ),
            ) ),


        floatingActionButton: FloatingActionButton.extended(
        label  :Text(textScaleFactor: textScaleFactor,

            textAlign: TextAlign.right,

            style:  TextStyle(
                fontSize: ( useMobileLayout? 15 :19),
                fontFamily: "Al-Jazeera-Arabic-Bold"),
             "عدد الملفات" + " : "+ attachment.length.toString(),
            softWrap: false,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,),
          onPressed: () {
           // print("pressed it");
          },
        ),


        body:
        OrientationBuilder(builder: (_, orientation) {
          if (orientation == Orientation.portrait)
            return _buildPortraitLayout(); // if orientation is portrait, show your portrait layout
          else
            return _buildLandscapeLayout(); // else show the landscape one
        })




    );


  }





  Widget _buildPortraitLayout(){

    return
      useMobileLayout?

      Container(color: Colors.grey.shade50,

        child:


        Column(

          children: [

            TextField(
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {

                  search_attachment = [];

                  print(value);


                  for(var item in attachment){
                    if(item.documentTypeDesc.contains(value)){
                      print("yea");
                      search_attachment.add(item);
                    }
                  }

                  attachment = [];

                  setState(() {
                    attachment = search_attachment;
                  });

                },
                keyboardType: TextInputType.text,
                obscureText: false,
                maxLines: 1,
                textAlign: TextAlign.right,

                textAlignVertical: TextAlignVertical.center,
                onChanged: (_newValue) {

                  setState(() {

                    _searchcontroller.value = TextEditingValue(
                      text: _newValue,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: _newValue.length),
                      ),
                    );

                  });
                },

                controller:_searchcontroller,

                decoration: InputDecoration(


                  suffixIcon:
                  _searchcontroller.text.length > 0 ?IconButton(
                    onPressed:() {
                      _searchcontroller.clear();
                      getAttachList();


                    },
                    icon: Icon(Icons.clear,color: Colors.black,),
                  ):
                  IconButton(
                    onPressed:() {
                      _searchcontroller.clear();
                      //  getAttachList();


                    },
                    icon: Icon(Icons.clear,color: Colors.grey.shade200,),
                  ),

                  contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),

                  labelStyle: TextStyle(fontSize: 14,fontFamily: "Al-Jazeera-Arabic-Regular",color: Colors.grey),
                  hintText:  "بحث",
                  // hintStyle: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                  border: myinputborder(),
                  //hintStyle: TextStyle(fontSize: 18.0, color: Colors.white),


                )

            ),
            SizedBox(height: 5,),

            _isLoading ?  Container(
              padding: const EdgeInsets.all(50),
              margin:const EdgeInsets.all(50) ,
              color:Colors.transparent,
              //widget shown according to the state
              child: Center(
                child:
                CircularProgressIndicator(),
              ),
            ):   Expanded(
              child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  reverse: false,
                  padding: const EdgeInsets.only(top: 5,right: 1,left: 5,bottom: 80),
                  itemCount:attachment.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        setState((){
                          tappedIndex=index;
                        });
                        String url =  attachment[index].fileUrl;

                        NetworkimgList_tapped.clear();

                        for(var item in NetworkimgList.sublist(tappedIndex)){
                          NetworkimgList_tapped.add(item);
                        }


                        print("NetworkimgList_tapped${NetworkimgList_tapped.length}");



                        AttachList = [];
                        AttachList.add(url);
                        setState(() {
                          AttachList.add(url);
                        });

                                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                                      return mobile_attachPreview(url, NetworkimgList_tapped,NetworkimgList_tapped.length);
                                    }));




                      },
                      child: Container(
                        color: tappedIndex == index ? Color(0xFFE6ECEC) : Colors.white,


                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Row(
                              children: [

                                Expanded(
                                  child: Text(textScaleFactor: textScaleFactor,

                                    textAlign: TextAlign.right,

                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontFamily: "Al-Jazeera-Arabic-Regular"),
                                    attachment[index].documentTypeDesc,
                                    softWrap: false,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,),
                                ),
                                SizedBox(width: 5,),

                                Icon(Icons.file_copy_outlined,color: Color(0xFF5F8780),),

                              ],
                            )





                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(
                    color: Colors.grey,
                    // height: 20,
                  )),
            ),
          ],



        ),


      )

      :
      Row(


        children: [

          Flexible(flex: 3,
              child:

              Container(color:  Color(0xFF7D5E5E).withOpacity(0.25),

                child:


                AttachList.length != 0? Center(
                  child: InkWell(
                    onTap: (){

                      documentItemTapped();
                    },
                    child:
                    CachedNetworkImage(
                      imageUrl:
                      BaseURL == "http://83.244.112.170:7575/" ? 
                      AttachList[0] :AttachList[0].replaceAll("http://83.244.112.170:5146", "http://192.168.0.170:5146") ,
                      placeholder: (context, url) => new CircularProgressIndicator(),
                      errorWidget: (context, url, error) => new Icon(Icons.error),
                    ),


                  ),

                ): Container(),
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


              )),

          Flexible(flex: 2,
              child: Container(color: Colors.grey.shade50,

                child:


                Column(

                  children: [

                    TextField(
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value) {

                          search_attachment = [];

                          print(value);


                          for(var item in attachment){
                            if(item.documentTypeDesc.contains(value)){
                              print("yea");
                              search_attachment.add(item);
                            }
                          }

                          attachment = [];

                          setState(() {
                            attachment = search_attachment;
                          });

                        },
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        maxLines: 1,
                        textAlign: TextAlign.right,

                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (_newValue) {

                          setState(() {

                            _searchcontroller.value = TextEditingValue(
                              text: _newValue,
                              selection: TextSelection.fromPosition(
                                TextPosition(offset: _newValue.length),
                              ),
                            );

                          });
                        },

                        controller:_searchcontroller,

                        decoration: InputDecoration(


                          suffixIcon:
                          _searchcontroller.text.length > 0 ?IconButton(
                            onPressed:() {
                              _searchcontroller.clear();
                              getAttachList();


                            },
                            icon: Icon(Icons.clear,color: Colors.black,),
                          ):
                          IconButton(
                            onPressed:() {
                              _searchcontroller.clear();
                              //  getAttachList();


                            },
                            icon: Icon(Icons.clear,color: Colors.grey.shade200,),
                          ),

                          contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),

                          labelStyle: TextStyle(fontSize: 14,fontFamily: "Al-Jazeera-Arabic-Regular",color: Colors.grey),
                          hintText:  "بحث",
                          // hintStyle: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                          border: myinputborder(),
                          //hintStyle: TextStyle(fontSize: 18.0, color: Colors.white),


                        )

                    ),
                    SizedBox(height: 5,),

                    _isLoading ?  Container(
                      padding: const EdgeInsets.all(50),
                      margin:const EdgeInsets.all(50) ,
                      color:Colors.transparent,
                      //widget shown according to the state
                      child: Center(
                        child:
                        CircularProgressIndicator(),
                      ),
                    ):   Expanded(
                      child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          reverse: false,
                          padding: const EdgeInsets.only(top: 5,right: 1,left: 5,bottom: 80),
                          itemCount:attachment.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: (){
                                setState((){
                                  tappedIndex=index;
                                });
                                String url =  attachment[index].fileUrl;
                                AttachList = [];
                                AttachList.add(url);
                                setState(() {
                                  AttachList.add(url);
                                });

                              },
                              child: Container(
                                color: tappedIndex == index ? Color(0xFFE6ECEC) : Colors.white,


                                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    Row(
                                      children: [

                                        Expanded(
                                          child: Text(textScaleFactor: textScaleFactor,

                                            textAlign: TextAlign.right,

                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontFamily: "Al-Jazeera-Arabic-Regular"),
                                            attachment[index].documentTypeDesc,
                                            softWrap: false,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,),
                                        ),
                                        SizedBox(width: 5,),

                                        Icon(Icons.file_copy_outlined,color: Color(0xFF5F8780),),

                                      ],
                                    )





                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => const Divider(
                            color: Colors.grey,
                            // height: 20,
                          )),
                    ),
                  ],



                ),


              )

          ),



        ],









      );


  }


  Widget _buildLandscapeLayout(){

    return

        Row(

           children: [

              Flexible(flex: 3,
                  child:

                  Container(color:  Color(0xFF7D5E5E).withOpacity(0.25),

                child:

                AttachList.length != 0?

                Center(
                  child: InkWell(
                    onTap: (){

                   documentItemTapped();
                    },
                    child:
                    CachedNetworkImage(
                      imageUrl:   BaseURL == "http://83.244.112.170:7575/" ?
                      AttachList[0] :AttachList[0].replaceAll("http://83.244.112.170:5146", "http://192.168.0.170:5146") ,
                      placeholder: (context, url) => new CircularProgressIndicator(),
                      errorWidget: (context, url, error) => new Icon(Icons.error),
                    ),


                  ),

                ): Container(),



                  )

              ),

            Flexible(flex: 2,
                  child: Container(color: Colors.grey.shade50,

                    child:

                    Column(

                      children: [

                        TextField(
                            textInputAction: TextInputAction.go,
                            onSubmitted: (value) {

                              search_attachment = [];

                              print(value);


                              for(var item in attachment){
                                if(item.documentTypeDesc.contains(value)){
                                  print("yea");
                                  search_attachment.add(item);
                                }
                              }

                              attachment = [];

                              setState(() {
                                attachment = search_attachment;
                              });

                            },
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            maxLines: 1,
                            textAlign: TextAlign.right,

                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (_newValue) {

                              setState(() {

                                _searchcontroller.value = TextEditingValue(
                                  text: _newValue,
                                  selection: TextSelection.fromPosition(
                                    TextPosition(offset: _newValue.length),
                                  ),
                                );

                              });
                            },

                            controller:_searchcontroller,

                            decoration: InputDecoration(


                              suffixIcon:
                              _searchcontroller.text.length > 0 ?IconButton(
                                onPressed:() {
                                  _searchcontroller.clear();
                                 getAttachList();


                                },
                                icon: Icon(Icons.clear,color: Colors.black,),
                              ):
                              IconButton(
                                onPressed:() {
                                  _searchcontroller.clear();
                                //  getAttachList();


                                },
                                icon: Icon(Icons.clear,color: Colors.grey.shade200,),
                              ),

                              contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),

                              labelStyle: TextStyle(fontSize: 14,fontFamily: "Al-Jazeera-Arabic-Regular",color: Colors.grey),
                              hintText:  "بحث",
                              // hintStyle: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                              border: myinputborder(),
                              //hintStyle: TextStyle(fontSize: 18.0, color: Colors.white),


                            )

                        ),




                        SizedBox(height: 5,),

                        _isLoading ?  Container(
                          padding: const EdgeInsets.all(50),
                          margin:const EdgeInsets.all(50) ,
                          color:Colors.transparent,
                          //widget shown according to the state
                          child: Center(
                            child:
                            CircularProgressIndicator(),
                          ),
                        ):  Expanded(
                          child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              reverse: false,
                              padding: const EdgeInsets.only(top: 5,right: 1,left: 5,bottom: 80),
                              itemCount:attachment.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: (){
                                    setState((){
                                      tappedIndex=index;
                                    });
                                    String url =  attachment[index].fileUrl;
                                    AttachList = [];
                                    AttachList.add(url);
                                    setState(() {
                                      AttachList.add(url);
                                    });
                          
                                  },
                                  child: Container(
                                    color: tappedIndex == index ? Color(0xFFE6ECEC) : Colors.white,

                                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                          
                                        Row(
                                          children: [
                          
                                            Expanded(
                                              child: Text(textScaleFactor: textScaleFactor,
                          
                                                textAlign: TextAlign.right,
                          
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontFamily: "Al-Jazeera-Arabic-Regular"),
                                                attachment[index].documentTypeDesc,
                                                softWrap: false,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,),
                                            ),
                                            SizedBox(width: 5,),
                          
                                            Icon(Icons.file_copy_outlined,color: Color(0xFF5F8780),),
                          
                                          ],
                                        )

                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) => const Divider(
                                color: Colors.grey,
                                // height: 20,
                              )),
                        ),
                      ],
                    ),


                  )

              ),


            ],

      );


  }





  documentItemTapped() async {
    NetworkimgList_tapped.clear();
    desList_tapped.clear();

    for(var item in NetworkimgList.sublist(tappedIndex)){






        NetworkimgList_tapped.add(item);

      //print(item.toString().replaceAll("http://83.244.112.170:5146", "http://192.168.0.128:7575"));

    }


    for(var item in attachment.sublist(tappedIndex)){
      desList_tapped.add(item.documentTypeDesc);

    }
    print("NetworkimgList_tapped${NetworkimgList_tapped.length}");



    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return DetailScreen(NetworkimgList_tapped,NetworkimgList_tapped.length,AttachList[0],desList_tapped);
    }));

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
          color:CustomColors.colorpriority_1,
          width: 0.6,
        )
    );
  }
}



class DetailScreen extends StatefulWidget {
  final  imgList;
  final count;
  final String fileurl;

  final desList_tapped;
  // final  docList;
  DetailScreen(this.imgList, this.count,this.fileurl,this.desList_tapped);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailScreen(this.imgList, this.count,this.fileurl,this.desList_tapped);
  }
}
class _DetailScreen extends State<DetailScreen> {
 final String fileurl;

 final desList_tapped;
  final  imgList;
  // final  docList;
  final count;
  _DetailScreen(this.imgList,this.count,this.fileurl,this.desList_tapped);
  late int currentIndex = 0;




  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(

            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.print,color: Colors.white,),
                  onPressed: () =>{  shareImageToprint(fileurl)},

                ),
              ),
            ],

            leading: IconButton(
              //menu icon button at start left of appbar
              onPressed: () {
                Navigator.pop(context);
                //code to execute when this button is pressed
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),

            backgroundColor: CustomColors.colorPrimary,
            title: Center(
              child: Text(
                textScaleFactor: textScaleFactor,
                   desList_tapped[currentIndex].toString(),
                style:  Theme.of(context).textTheme.barTextStyles,
              ),
            )),
        body:


        Stack(
          alignment: Alignment.bottomLeft,

          children: [


           PhotoViewGallery.builder(
             itemCount: count,
             enableRotation: true,
             builder: (BuildContext context, int index) {
               currentIndex = index;

               return PhotoViewGalleryPageOptions(
                 imageProvider:

                 imgList[index],


                 initialScale: PhotoViewComputedScale.contained ,
                 minScale: PhotoViewComputedScale.contained * 0.8,
                 maxScale: PhotoViewComputedScale.covered * 2,
                 heroAttributes: PhotoViewHeroAttributes(tag: index),
                 onTapUp: (_, __, ___)  async {
                 //  shareImageToprint(fileurl);
                   print("mflmlfd")

                   ;                  },


               );
             },
            //scrollPhysics: BouncingScrollPhysics(),
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
             onPageChanged: onPageChanged,



           ),

           Padding(
             padding: EdgeInsets.only(bottom: 10,left: 5),

             child: Row(
                 children: [
                   for(int i = 0; i < imgList.length; i++)
                     Container(
                         margin: EdgeInsets.all(3),
                         height: 10, width: 10,
                         decoration: BoxDecoration(
                             color: i == currentIndex ? Color(0xFF923731) : Colors.grey,
                             borderRadius: BorderRadius.circular(5)
                         )
                     )
                 ]
             ),
           )





          ],

        )
    );
  }

  shareImageToprint(String url) async {


    final url_link = Uri.parse(url);


    await Share.share(url);
  }
  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}