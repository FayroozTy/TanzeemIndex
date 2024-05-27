
import 'dart:async';
import 'dart:convert';

import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tanzeem/Login/ui/loginScreen.dart';
import '../../TanzeemAttachment/ui/AttachmentScreen.dart';
import '../../Util/Constant.dart';
import '../../Util/FormFactor.dart';
import '../Model/HayList.dart';
import '../Model/TanzeemIndex.dart';
import '../bloc/TanzeemIndex/TanzeemIndex_bloc.dart';
import '../bloc/TanzeemIndex/TanzeemIndex_event.dart';
import '../bloc/TanzeemIndex/TanzeemIndex_state.dart';
import 'package:dropdown_button2/dropdown_button2.dart';





class searchFileScreen extends StatefulWidget{



  searchFileScreen();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _searchFileScreen();
  }

}

class _searchFileScreen extends State<searchFileScreen> {

  TextEditingController _fileNumbercontroller = TextEditingController();
  TextEditingController _orderNumbercontroller = TextEditingController();
  TextEditingController _hwdcontroller = TextEditingController();
  //TextEditingController _haycontroller = TextEditingController();
  TextEditingController _landNumbercontroller = TextEditingController();
  TextEditingController _userOfFilecontroller = TextEditingController();

  bool _isLoading = false;

  _searchFileScreen();

  bool useMobileLayout = false;

  List<TanzeemIndex> TanzeemIndexData = [];

  String? selectval ;

  List<HayList> hayList = [];

  List<String> hay = [];




  @override
  void initState() {

    super.initState();
    getHayList();


   //
   // getPref();
   //
   //
   //  print("gfgfyu");
   //
   //  for(var item in hay){
   //    print(item);
   //  }
   //
   //
   //  for(var item in Inthay_noList){
   //    print(item);
   //  }




    // BlocProvider.of<TanzeemIndexBloc>(
    //     context).add(SendData(
    //     "",0,0,"666666"));

  }

  getHayList() async {

    hay = [];

    setState(() {
      _isLoading = true;
    });

    // _showDialog(context, SimpleFontelicoProgressDialogType.normal, '');

    try {


      String url = BaseURL + "api/Lands/HayList";



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
        hayList =
            (json as List).map((x) => HayList.fromJson(x))
                .toList();




        setState(() {
          hay.add("الحي/غير محدد ");

          for(var item in hayList){
            hay.add(item.hayName);
          }




          print(hay.length);
        // selectval = hay[0];

        });

        print(json.toString());

      }

      setState(() {
        _isLoading = false;
      });

    }


    catch (e) {
      print('Error : $e');
      showAlertDialog( context , "" , "خطا في الاتصال");

      return null;
    } finally {
      setState(() {
        _isLoading = false;
      });

    }

  }



  @override
  void dispose() {

    super.dispose();

  }

  showAlertDialogSetting(BuildContext context) {


    print(BaseURL);
    String msg = "";

    if(BaseURL == "http://192.168.0.128:7575/"){
     msg = "انت الان تستخدم الشبكة الداخلية للتعديل اختر نوع الشبكة";
    }else{
      msg = "انت الان تستخدم الشبكة الخارجية للتعديل اختر نوع الشبكة";
    }


    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("شبكة داخلية",style: TextStyle(
          fontSize: 15.0,fontFamily: "Al-Jazeera-Arabic-Bold",color: Color(0xFF923731)
      ),),
      onPressed:  () async {

        BaseURL  ="http://192.168.0.128:7575/";
        Navigator.of(context).pop();


      },
    );
    Widget continueButton = TextButton(
      child: Text("شبكة خارجية",style: TextStyle(
          fontSize: 15.0,fontFamily: "Al-Jazeera-Arabic-Bold", color: Color(0xFF923731)
      ),),
      onPressed:  () async {
        BaseURL = "http://83.244.112.170:7575/";
        Navigator.of(context).pop();


      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(


      title: Center(
        child: Text("اعدادات الشبكة",style: TextStyle(
            fontSize: 16.0,color: Colors.black,fontFamily: "Al-Jazeera-Arabic-Bold"
        ),),
      ),

      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(msg,style: TextStyle(
            fontSize: 17.0,color: Colors.black,fontFamily: "Al-Jazeera-Arabic-Regular"
        ),),
      ),
      actions: [
        cancelButton,
        continueButton,
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

  @override
  Widget build(BuildContext context) {


    final double shortsize = MediaQuery.of(context).size.shortestSide;

    useMobileLayout = shortsize < 600 ;

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,

            appBar: AppBar(


                actions: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu,color: Colors.white,),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                    ),
                  ),
                ],


                // leading: IconButton(
                //   icon: Icon(Icons.network_check, color: Colors.white),
                //   onPressed: () => showAlertDialogSetting(context),
                // ),


                automaticallyImplyLeading: false,



                backgroundColor: CustomColors.colorPrimary,
                title: Center(
                  child: Text(
                    textScaleFactor: textScaleFactor,
                    " الملفات ",
                    style:  Theme.of(context).textTheme.barTextStyles,
                  ),
                )),

            endDrawer:    Drawer(

              backgroundColor: CustomColors.colorPrimaryDark,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        DrawerHeader(

                          child: Column(
                            //  mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,

                                    children: [


                                      Text(
                                        textScaleFactor: textScaleFactor,
                                        "بلدية نابلس",
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            color: Color(0xFFF1F1F1),
                                            fontFamily:
                                            "Al-Jazeera-Arabic-Bold"),
                                      ),
                                      SizedBox(height: 10,),

                                      Text(
                                        textScaleFactor: textScaleFactor,
                                        "قسم التنظيم",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xFFF1F1F1),
                                            fontFamily:
                                            "Al-Jazeera-Arabic-Bold"),
                                      ),




                                    ],
                                  ),
                                  SizedBox(width: 4,),
                                  Image.asset('assets/Nablus_Logo.png', width: 70,height: 70,)



                                ],
                              ),



                            ],
                          ),

                        ),



                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10, left: 10),
                            child: Container(

                              child: InkWell(
                                  splashColor: Colors.grey,
                                  onTap: () async {
                                    CustomColors.index = 1;
                                    Navigator.pop(context);
                                    showAlertDialogSetting(context);


                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Container(
                                        height: 55,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text("اعدادات الشبكة",
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Color(0xFFF1F1F1),
                                                        fontFamily: "Al-Jazeera-Arabic-Bold")),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                ),
                                                Icon(Icons.network_check, color: Colors.white)

                                              ],
                                            ),
                                          ],
                                        )),
                                  )),
                            ),
                          ),
                        )




                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child:

                    InkWell(
                      onTap: () async {


                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        setState(() {
                          prefs.setString("isLogin", "false");



                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => loginScreen()));

                          //   Navigator.pop(context);

                        });

                      },
                      child: Container(
                        // This align moves the children to the bottom
                          child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              // This container holds all the children that will be aligned
                              // on the bottom and sh
                              //
                              // the above ListView
                              child:
                              Container(

                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(left: 10, right: 10),
                                width:180,
                                height: 30,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5)
                                  ),
                                  color: Color(0xFFFEFEFE),
                                  boxShadow: [
                                    // BoxShadow(
                                    //   color: Colors.grey,
                                    //   blurRadius: 15.0, // soften the shadow
                                    //   spreadRadius: 5.0, //extend the shadow
                                    //   offset: Offset(
                                    //     5.0, // Move to right 5  horizontally
                                    //     5.0, // Move to bottom 5 Vertically
                                    //   ),
                                    // )
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  ' تسجيل الخروج',
                                  style: TextStyle(fontSize: 13, color: CustomColors.colorPrimary, fontFamily: "Al-Jazeera-Arabic-Regular"),
                                ),
                              )
                          )),
                    ),
                  )
                ],
              ),
            ),


            body:


            hayList.length == 0 ?
            Container(
              padding: const EdgeInsets.all(50),
              margin:const EdgeInsets.all(50) ,
              color:Colors.white,
              //widget shown according to the state
              child: Center(
                child:
                CircularProgressIndicator(),
              ),)  :


            useMobileLayout ?  PhoneApp(): tabletApp()

            // FormFactor(
            //     phoneScreenSize: 6.0,
            //     phone: PhoneApp(),
            //     tablet:  BlocConsumer<TanzeemIndexBloc, TanzeemIndexState>(
            //       listener: (context, state) {},
            //       builder: (context, state) {
            //         if (state is TanzeemIndexLoaded) {
            //           //print(state.data.body);
            //
            //           if(state.data.body.contains("[]") ){
            //
            //             return    OrientationBuilder(builder: (_, orientation) {
            //               if (orientation == Orientation.portrait)
            //                 return
            //
            //
            //                   Column(
            //                     children: [
            //                       SizedBox(height: 10,),
            //                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                         children: [
            //
            //
            //
            //                           Flexible(
            //                             flex: 1,
            //                             child:
            //                             Padding(
            //                               padding: const EdgeInsets.only(  bottom: 5),
            //                               child: Container(
            //                                 height: 45,  //gives the height of the dropdown button
            //                                 width: MediaQuery.of(context).size.width, //gives the width of the dropdown button
            //                                 decoration: BoxDecoration(
            //
            //                                     border: Border.all(
            //                                       color:CustomColors.colorPrimary,
            //                                       width: 0.6,
            //                                     ),
            //                                     borderRadius: BorderRadius.all(Radius.circular(20)
            //
            //                                     ),
            //                                     color: Colors.white
            //                                 ),
            //                                 // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
            //                                 child: Theme(
            //                                     data: Theme.of(context).copyWith(
            //                                         canvasColor: Colors.white, // background color for the dropdown items
            //                                         buttonTheme: ButtonTheme.of(context).copyWith(
            //                                           alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
            //                                         )
            //                                     ),
            //                                     child:
            //                                     DropdownButtonHideUnderline(  // to hide the default underline of the dropdown button
            //                                       child: DropdownButton<String>(
            //                                         isExpanded: true,
            //
            //
            //                                         hint: Center(
            //                                           child: Text(
            //                                             'الحي',
            //                                             style: TextStyle(
            //                                               fontSize: 18,
            //                                               color: Theme.of(context).hintColor,
            //                                             ),
            //                                           ),
            //                                         ),
            //                                         iconEnabledColor: Colors.black,  // icon color of the dropdown button
            //                                         items: hay.map((String value){
            //                                           return DropdownMenuItem<String>(
            //                                             value: value,
            //                                             child: Center(
            //                                               child: Text(value,
            //                                                 style: TextStyle(
            //                                                     fontFamily: "Al-Jazeera-Arabic-Regular",
            //                                                     fontSize: 19
            //                                                 ),
            //                                               ),
            //                                             ),
            //                                           );
            //                                         }).toList(),
            //                                         // setting hint
            //                                         onChanged:  (String? newValue) {
            //                                           setState(() {
            //                                             selectval = newValue!;
            //                                           });
            //                                         },
            //                                         value: selectval,  // displaying the selected value
            //                                       ),
            //                                     )
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                           Flexible(
            //                             flex: 1,
            //                             child: Padding(
            //                               padding: EdgeInsets.all(8),
            //                               child: Container(
            //
            //                                 height: 50,
            //                                 child:  SizedBox(
            //                                   height: 45,
            //                                   child: Directionality(
            //                                     textDirection: TextDirection.rtl,
            //                                     child: Padding(
            //                                       padding: EdgeInsets.only(right: 10,left: 10),
            //                                       child: TextFormField(
            //                                           keyboardType:  TextInputType.multiline,
            //                                           obscureText: false,
            //
            //                                           textAlign: TextAlign.center,
            //                                           textAlignVertical: TextAlignVertical.center,
            //                                           onChanged: (_newValue) {
            //
            //                                             setState(() {
            //                                               _userOfFilecontroller .value = TextEditingValue(
            //                                                 text: _newValue,
            //                                                 selection: TextSelection.fromPosition(
            //                                                   TextPosition(offset: _newValue.length),
            //                                                 ),
            //                                               );
            //                                             });
            //                                           },
            //
            //                                           controller:_userOfFilecontroller,
            //
            //                                           decoration: InputDecoration(
            //                                             fillColor:  Colors.white,
            //                                             filled: true,
            //
            //                                             contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            //                                             hintText:"صاحب الملف ",
            //                                             hintStyle: TextStyle(
            //                                                 fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                             ),
            //
            //                                             border: myinputborder(),
            //                                             enabledBorder: myinputborder(),
            //                                             focusedBorder: myfocusborder(),
            //
            //                                           )
            //
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //
            //
            //                           Flexible(
            //                             flex: 1,
            //                             child: Padding(
            //                               padding: EdgeInsets.all(8),
            //
            //                               child: Container(
            //
            //                                 height: 50,
            //                                 child:  SizedBox(
            //                                   height: 45,
            //                                   child: Directionality(
            //                                     textDirection: TextDirection.rtl,
            //                                     child: Padding(
            //                                       padding: EdgeInsets.only(right: 10,left: 10),
            //                                       child: TextFormField(
            //                                           keyboardType:  TextInputType.number,
            //                                           obscureText: false,
            //
            //                                           textAlign: TextAlign.center,
            //                                           textAlignVertical: TextAlignVertical.center,
            //                                           onChanged: (_newValue) {
            //
            //                                             setState(() {
            //                                               _orderNumbercontroller.value = TextEditingValue(
            //                                                 text: _newValue,
            //                                                 selection: TextSelection.fromPosition(
            //                                                   TextPosition(offset: _newValue.length),
            //                                                 ),
            //                                               );
            //                                             });
            //                                           },
            //
            //                                           controller:_orderNumbercontroller,
            //
            //                                           decoration: InputDecoration(
            //                                             fillColor:  Colors.white,
            //                                             filled: true,
            //
            //                                             contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
            //                                             hintText:"رقم الطلب",
            //                                             hintStyle: TextStyle(
            //                                                 fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                             ),
            //
            //                                             border: myinputborder(),
            //                                             enabledBorder: myinputborder(),
            //                                             focusedBorder: myfocusborder(),
            //
            //                                           )
            //
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                           Flexible(
            //                             flex: 1,
            //                             child: Padding(
            //                               padding: EdgeInsets.all(8),
            //
            //                               child: Container(
            //
            //                                 height: 50,
            //                                 child:  SizedBox(
            //                                   height: 45,
            //                                   child: Directionality(
            //                                     textDirection: TextDirection.rtl,
            //                                     child: Padding(
            //                                       padding: EdgeInsets.only(right: 10,left: 10),
            //                                       child: TextFormField(
            //                                           keyboardType:  TextInputType.number,
            //                                           obscureText: false,
            //
            //                                           textAlign: TextAlign.center,
            //                                           textAlignVertical: TextAlignVertical.center,
            //                                           onChanged: (_newValue) {
            //
            //                                             setState(() {
            //                                               _fileNumbercontroller.value = TextEditingValue(
            //                                                 text: _newValue,
            //                                                 selection: TextSelection.fromPosition(
            //                                                   TextPosition(offset: _newValue.length),
            //                                                 ),
            //                                               );
            //                                             });
            //                                           },
            //
            //                                           controller:_fileNumbercontroller,
            //
            //                                           decoration: InputDecoration(
            //                                             fillColor:  Colors.white,
            //                                             filled: true,
            //
            //                                             contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
            //                                             hintText:"رقم الملف",
            //                                             hintStyle: TextStyle(
            //                                                 fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                             ),
            //
            //                                             border: myinputborder(),
            //                                             enabledBorder: myinputborder(),
            //                                             focusedBorder: myfocusborder(),
            //
            //                                           )
            //
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //
            //                         ],),
            //                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                         children: [
            //
            //
            //                           Flexible(
            //                             flex: 1,
            //                             child : Padding(
            //                               padding: EdgeInsets.all(8),
            //                               child: Container(
            //
            //                                 height: 50,
            //                                 child:
            //
            //                                 SizedBox(height: 55,
            //
            //                                     child: TextButton(
            //                                       onPressed: (){
            //                                         searchBtnPressed();
            //
            //
            //                                       },
            //                                       style: TextButton.styleFrom(
            //                                         shape: RoundedRectangleBorder(
            //                                           borderRadius:
            //                                           BorderRadius.circular(15),
            //                                         ),
            //                                         backgroundColor:
            //                                         CustomColors.colorPrimary,
            //                                       ),
            //                                       child: Center(
            //                                         child: Text(
            //                                           textScaleFactor: textScaleFactor,
            //                                           "بحث",
            //                                           style: TextStyle(
            //                                               color: Color(0xFFF5F5F5),
            //                                               fontFamily:
            //                                               "Al-Jazeera-Arabic-Bold",
            //                                               fontSize: 14),
            //                                         ),
            //                                       ),
            //                                     )
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //
            //
            //
            //                           Flexible(
            //                             flex: 1,
            //                             child: Padding(
            //                               padding: EdgeInsets.all(8),
            //
            //                               child: Container(
            //
            //                                 height: 50,
            //                                 child:  SizedBox(
            //                                   height: 45,
            //                                   child: Directionality(
            //                                     textDirection: TextDirection.rtl,
            //                                     child: Padding(
            //                                       padding: EdgeInsets.only(right: 10,left: 10),
            //                                       child: TextFormField(
            //                                           keyboardType:  TextInputType.multiline,
            //                                           obscureText: false,
            //
            //                                           textAlign: TextAlign.center,
            //                                           textAlignVertical: TextAlignVertical.center,
            //                                           onChanged: (_newValue) {
            //
            //                                             setState(() {
            //                                               _landNumbercontroller.value = TextEditingValue(
            //                                                 text: _newValue,
            //                                                 selection: TextSelection.fromPosition(
            //                                                   TextPosition(offset: _newValue.length),
            //                                                 ),
            //                                               );
            //                                             });
            //                                           },
            //
            //                                           controller:_landNumbercontroller,
            //
            //                                           decoration: InputDecoration(
            //                                             fillColor: Colors.white,
            //                                             filled: true,
            //
            //                                             contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
            //                                             hintText:"القطعة",
            //                                             hintStyle: TextStyle(
            //                                                 fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                             ),
            //
            //                                             border: myinputborder(),
            //                                             enabledBorder: myinputborder(),
            //                                             focusedBorder: myfocusborder(),
            //
            //                                           )
            //
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                           Flexible(
            //                             flex: 1,
            //                             child: Padding(
            //                               padding: EdgeInsets.all(8),
            //                               child: Container(
            //
            //                                 height: 50,
            //                                 child:  SizedBox(
            //                                   height: 45,
            //                                   child: Directionality(
            //                                     textDirection: TextDirection.rtl,
            //                                     child: Padding(
            //                                       padding: EdgeInsets.only(right: 10,left: 10),
            //                                       child: TextFormField(
            //                                           keyboardType:  TextInputType.number,
            //                                           obscureText: false,
            //
            //                                           textAlign: TextAlign.center,
            //                                           textAlignVertical: TextAlignVertical.center,
            //                                           onChanged: (_newValue) {
            //
            //                                             setState(() {
            //                                               _hwdcontroller.value = TextEditingValue(
            //                                                 text: _newValue,
            //                                                 selection: TextSelection.fromPosition(
            //                                                   TextPosition(offset: _newValue.length),
            //                                                 ),
            //                                               );
            //                                             });
            //                                           },
            //
            //                                           controller:_hwdcontroller,
            //
            //                                           decoration: InputDecoration(
            //                                             fillColor:  Colors.white,
            //                                             filled: true,
            //
            //                                             contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            //                                             hintText:" الحوض",
            //                                             hintStyle: TextStyle(
            //                                                 fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                             ),
            //
            //                                             border: myinputborder(),
            //                                             enabledBorder: myinputborder(),
            //                                             focusedBorder: myfocusborder(),
            //
            //                                           )
            //
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //
            //                         ],),
            //
            //                       SizedBox(height: 20,),
            //                       Center(child:   Text("لا تتوفر بيانات",style: TextStyle(color: Colors.red,
            //                           fontSize: 18,
            //                           fontFamily: "Al-Jazeera-Arabic-Bold")),)
            //
            //
            //
            //                     ],
            //                   ); // if orientation is portrait, show your portrait layout
            //               else
            //                 return  Column(
            //                   children: [
            //                     SizedBox(height: 10,),
            //                     Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                       children: [
            //
            //
            //
            //                         Flexible(
            //                           flex: 1,
            //                           child:
            //
            //                           Padding(
            //                             padding: const EdgeInsets.only(  bottom: 5),
            //                             child: Container(
            //                               height: 45,  //gives the height of the dropdown button
            //                               width: MediaQuery.of(context).size.width, //gives the width of the dropdown button
            //                               decoration: BoxDecoration(
            //
            //                                   border: Border.all(
            //                                     color:CustomColors.colorPrimary,
            //                                     width: 0.6,
            //                                   ),
            //                                   borderRadius: BorderRadius.all(Radius.circular(20)
            //
            //                                   ),
            //                                   color: Colors.white
            //                               ),
            //                               // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
            //                               child: Theme(
            //                                   data: Theme.of(context).copyWith(
            //                                       canvasColor: Colors.white, // background color for the dropdown items
            //                                       buttonTheme: ButtonTheme.of(context).copyWith(
            //                                         alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
            //                                       )
            //                                   ),
            //                                   child:
            //
            //                                   DropdownButtonHideUnderline(  // to hide the default underline of the dropdown button
            //                                     child: DropdownButton<String>(
            //                                       isExpanded: true,
            //
            //
            //                                       hint: Center(
            //                                         child: Text(
            //                                           'الحي',
            //                                           style: TextStyle(
            //                                             fontSize: 18,
            //                                             color: Theme.of(context).hintColor,
            //                                           ),
            //                                         ),
            //                                       ),
            //                                       iconEnabledColor: Colors.black,  // icon color of the dropdown button
            //                                       items: hay.map((String value){
            //                                         return DropdownMenuItem<String>(
            //                                           value: value,
            //                                           child: Center(
            //                                             child: Text(value,
            //                                               style: TextStyle(
            //                                                   fontFamily: "Al-Jazeera-Arabic-Regular",
            //                                                   fontSize: 19
            //                                               ),
            //                                             ),
            //                                           ),
            //                                         );
            //                                       }).toList(),
            //                                       // setting hint
            //                                       onChanged:  (String? newValue) {
            //                                         setState(() {
            //                                           selectval = newValue!;
            //                                         });
            //                                       },
            //                                       value: selectval,  // displaying the selected value
            //                                     ),
            //                                   )
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                         Flexible(
            //                           flex: 1,
            //                           child: Padding(
            //                             padding: EdgeInsets.all(8),
            //                             child: Container(
            //
            //                               height: 50,
            //                               child:  SizedBox(
            //                                 height: 45,
            //                                 child: Directionality(
            //                                   textDirection: TextDirection.rtl,
            //                                   child: Padding(
            //                                     padding: EdgeInsets.only(right: 10,left: 10),
            //                                     child: TextFormField(
            //                                         keyboardType:  TextInputType.multiline,
            //                                         obscureText: false,
            //
            //                                         textAlign: TextAlign.center,
            //                                         textAlignVertical: TextAlignVertical.center,
            //                                         onChanged: (_newValue) {
            //
            //                                           setState(() {
            //                                             _userOfFilecontroller .value = TextEditingValue(
            //                                               text: _newValue,
            //                                               selection: TextSelection.fromPosition(
            //                                                 TextPosition(offset: _newValue.length),
            //                                               ),
            //                                             );
            //                                           });
            //                                         },
            //
            //                                         controller:_userOfFilecontroller,
            //
            //                                         decoration: InputDecoration(
            //                                           fillColor:  Colors.white,
            //                                           filled: true,
            //
            //                                           contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            //                                           hintText:"صاحب الملف ",
            //                                           hintStyle: TextStyle(
            //                                               fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                           ),
            //
            //                                           border: myinputborder(),
            //                                           enabledBorder: myinputborder(),
            //                                           focusedBorder: myfocusborder(),
            //
            //                                         )
            //
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //
            //
            //                         Flexible(
            //                           flex: 1,
            //                           child: Padding(
            //                             padding: EdgeInsets.all(8),
            //
            //                             child: Container(
            //
            //                               height: 50,
            //                               child:  SizedBox(
            //                                 height: 45,
            //                                 child: Directionality(
            //                                   textDirection: TextDirection.rtl,
            //                                   child: Padding(
            //                                     padding: EdgeInsets.only(right: 10,left: 10),
            //                                     child: TextFormField(
            //                                         keyboardType:  TextInputType.number,
            //                                         obscureText: false,
            //
            //                                         textAlign: TextAlign.center,
            //                                         textAlignVertical: TextAlignVertical.center,
            //                                         onChanged: (_newValue) {
            //
            //                                           setState(() {
            //                                             _orderNumbercontroller.value = TextEditingValue(
            //                                               text: _newValue,
            //                                               selection: TextSelection.fromPosition(
            //                                                 TextPosition(offset: _newValue.length),
            //                                               ),
            //                                             );
            //                                           });
            //                                         },
            //
            //                                         controller:_orderNumbercontroller,
            //
            //                                         decoration: InputDecoration(
            //                                           fillColor:  Colors.white,
            //                                           filled: true,
            //
            //                                           contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
            //                                           hintText:"رقم الطلب",
            //                                           hintStyle: TextStyle(
            //                                               fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                           ),
            //
            //                                           border: myinputborder(),
            //                                           enabledBorder: myinputborder(),
            //                                           focusedBorder: myfocusborder(),
            //
            //                                         )
            //
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                         Flexible(
            //                           flex: 1,
            //                           child: Padding(
            //                             padding: EdgeInsets.all(8),
            //
            //                             child: Container(
            //
            //                               height: 50,
            //                               child:  SizedBox(
            //                                 height: 45,
            //                                 child: Directionality(
            //                                   textDirection: TextDirection.rtl,
            //                                   child: Padding(
            //                                     padding: EdgeInsets.only(right: 10,left: 10),
            //                                     child: TextFormField(
            //                                         keyboardType:  TextInputType.number,
            //                                         obscureText: false,
            //
            //                                         textAlign: TextAlign.center,
            //                                         textAlignVertical: TextAlignVertical.center,
            //                                         onChanged: (_newValue) {
            //
            //                                           setState(() {
            //                                             _fileNumbercontroller.value = TextEditingValue(
            //                                               text: _newValue,
            //                                               selection: TextSelection.fromPosition(
            //                                                 TextPosition(offset: _newValue.length),
            //                                               ),
            //                                             );
            //                                           });
            //                                         },
            //
            //                                         controller:_fileNumbercontroller,
            //
            //                                         decoration: InputDecoration(
            //                                           fillColor:  Colors.white,
            //                                           filled: true,
            //
            //                                           contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
            //                                           hintText:"رقم الملف",
            //                                           hintStyle: TextStyle(
            //                                               fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                           ),
            //
            //                                           border: myinputborder(),
            //                                           enabledBorder: myinputborder(),
            //                                           focusedBorder: myfocusborder(),
            //
            //                                         )
            //
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //
            //                       ],),
            //                     Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                       children: [
            //
            //
            //                         Flexible(
            //                           flex: 1,
            //                           child : Padding(
            //                             padding: EdgeInsets.all(8),
            //                             child: Container(
            //
            //                               height: 50,
            //                               child:
            //
            //                               SizedBox(height: 55,
            //
            //                                   child: TextButton(
            //                                     onPressed: (){
            //                                       searchBtnPressed();
            //
            //
            //                                     },
            //                                     style: TextButton.styleFrom(
            //                                       shape: RoundedRectangleBorder(
            //                                         borderRadius:
            //                                         BorderRadius.circular(15),
            //                                       ),
            //                                       backgroundColor:
            //                                       CustomColors.colorPrimary,
            //                                     ),
            //                                     child: Center(
            //                                       child: Text(
            //                                         textScaleFactor: textScaleFactor,
            //                                         "بحث",
            //                                         style: TextStyle(
            //                                             color: Color(0xFFF5F5F5),
            //                                             fontFamily:
            //                                             "Al-Jazeera-Arabic-Bold",
            //                                             fontSize: 14),
            //                                       ),
            //                                     ),
            //                                   )
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //
            //
            //
            //                         Flexible(
            //                           flex: 1,
            //                           child: Padding(
            //                             padding: EdgeInsets.all(8),
            //
            //                             child: Container(
            //
            //                               height: 50,
            //                               child:  SizedBox(
            //                                 height: 45,
            //                                 child: Directionality(
            //                                   textDirection: TextDirection.rtl,
            //                                   child: Padding(
            //                                     padding: EdgeInsets.only(right: 10,left: 10),
            //                                     child: TextFormField(
            //                                         keyboardType:  TextInputType.multiline,
            //                                         obscureText: false,
            //
            //                                         textAlign: TextAlign.center,
            //                                         textAlignVertical: TextAlignVertical.center,
            //                                         onChanged: (_newValue) {
            //
            //                                           setState(() {
            //                                             _landNumbercontroller.value = TextEditingValue(
            //                                               text: _newValue,
            //                                               selection: TextSelection.fromPosition(
            //                                                 TextPosition(offset: _newValue.length),
            //                                               ),
            //                                             );
            //                                           });
            //                                         },
            //
            //                                         controller:_landNumbercontroller,
            //
            //                                         decoration: InputDecoration(
            //                                           fillColor: Colors.white,
            //                                           filled: true,
            //
            //                                           contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
            //                                           hintText:"القطعة",
            //                                           hintStyle: TextStyle(
            //                                               fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                           ),
            //
            //                                           border: myinputborder(),
            //                                           enabledBorder: myinputborder(),
            //                                           focusedBorder: myfocusborder(),
            //
            //                                         )
            //
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                         Flexible(
            //                           flex: 1,
            //                           child: Padding(
            //                             padding: EdgeInsets.all(8),
            //                             child: Container(
            //
            //                               height: 50,
            //                               child:  SizedBox(
            //                                 height: 45,
            //                                 child: Directionality(
            //                                   textDirection: TextDirection.rtl,
            //                                   child: Padding(
            //                                     padding: EdgeInsets.only(right: 10,left: 10),
            //                                     child: TextFormField(
            //                                         keyboardType:  TextInputType.number,
            //                                         obscureText: false,
            //
            //                                         textAlign: TextAlign.center,
            //                                         textAlignVertical: TextAlignVertical.center,
            //                                         onChanged: (_newValue) {
            //
            //                                           setState(() {
            //                                             _hwdcontroller.value = TextEditingValue(
            //                                               text: _newValue,
            //                                               selection: TextSelection.fromPosition(
            //                                                 TextPosition(offset: _newValue.length),
            //                                               ),
            //                                             );
            //                                           });
            //                                         },
            //
            //                                         controller:_hwdcontroller,
            //
            //                                         decoration: InputDecoration(
            //                                           fillColor:  Colors.white,
            //                                           filled: true,
            //
            //                                           contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            //                                           hintText:" الحوض",
            //                                           hintStyle: TextStyle(
            //                                               fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                           ),
            //
            //                                           border: myinputborder(),
            //                                           enabledBorder: myinputborder(),
            //                                           focusedBorder: myfocusborder(),
            //
            //                                         )
            //
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //
            //                       ],),
            //
            //                     SizedBox(height: 20,),
            //                     Center(child:   Text("لا تتوفر بيانات",style: TextStyle(color: Colors.red,
            //                         fontSize: 18,
            //                         fontFamily: "Al-Jazeera-Arabic-Bold")),)
            //
            //
            //
            //
            //
            //
            //                   ],
            //                 ); // else show the landscape one
            //             });
            //
            //           }
            //           else{
            //
            //             TanzeemIndexData = [];
            //
            //             String jsonsDataString = state.data.body.toString();
            //             // toString of Response's body is assigned to jsonDataString
            //             String receivedJson = jsonsDataString;
            //
            //
            //             List<TanzeemIndex> responseobj =  (jsonDecode(jsonsDataString)as List).map((x) => TanzeemIndex.fromJson(x))
            //                 .toList();
            //             TanzeemIndexData = responseobj;
            //
            //
            //             return
            //
            //               OrientationBuilder(builder: (_, orientation) {
            //                 if (orientation == Orientation.portrait)
            //                   return _buildPortraitLayout(); // if orientation is portrait, show your portrait layout
            //                 else
            //                   return _buildLandscapeLayout(); // else show the landscape one
            //               });
            //
            //
            //           }
            //
            //
            //         }
            //
            //         else if (state is TanzeemIndexLoading) {
            //           return const Center(child: CircularProgressIndicator());
            //         } else {
            //
            //           return
            //             OrientationBuilder(builder: (_, orientation) {
            //               if (orientation == Orientation.portrait)
            //                 return
            //
            //
            //
            //                   Column(
            //                     children: [
            //                       SizedBox(height: 10,),
            //                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                         children: [
            //
            //
            //
            //                           Flexible(
            //                             flex: 1,
            //                             child:
            //
            //                             Padding(
            //                               padding: const EdgeInsets.only(  bottom: 5),
            //                               child: Container(
            //                                 height: 45,  //gives the height of the dropdown button
            //                                 width: MediaQuery.of(context).size.width, //gives the width of the dropdown button
            //                                 decoration: BoxDecoration(
            //
            //                                     border: Border.all(
            //                                       color:CustomColors.colorPrimary,
            //                                       width: 0.6,
            //                                     ),
            //                                     borderRadius: BorderRadius.all(Radius.circular(20)
            //
            //                                     ),
            //                                     color: Colors.white
            //                                 ),
            //                                 // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
            //                                 child: Theme(
            //                                     data: Theme.of(context).copyWith(
            //                                         canvasColor: Colors.white, // background color for the dropdown items
            //                                         buttonTheme: ButtonTheme.of(context).copyWith(
            //                                           alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
            //                                         )
            //                                     ),
            //                                     child:        DropdownButtonHideUnderline(  // to hide the default underline of the dropdown button
            //                                       child: DropdownButton<String>(
            //                                         isExpanded: true,
            //
            //
            //                                         hint: Center(
            //                                           child: Text(
            //                                             'الحي',
            //                                             style: TextStyle(
            //                                               fontSize: 18,
            //                                               color: Theme.of(context).hintColor,
            //                                             ),
            //                                           ),
            //                                         ),
            //                                         iconEnabledColor: Colors.black,  // icon color of the dropdown button
            //                                         items: hay.map((String value){
            //                                           return DropdownMenuItem<String>(
            //                                             value: value,
            //                                             child: Center(
            //                                               child: Text(value,
            //                                                 style: TextStyle(
            //                                                     fontFamily: "Al-Jazeera-Arabic-Regular",
            //                                                     fontSize: 19
            //                                                 ),
            //                                               ),
            //                                             ),
            //                                           );
            //                                         }).toList(),
            //                                         // setting hint
            //                                         onChanged:  (String? newValue) {
            //
            //                                           setState(() {
            //                                             selectval = newValue;
            //
            //                                             print(selectval);
            //
            //                                           });
            //                                         },
            //                                         value: selectval,  // displaying the selected value
            //                                       ),
            //                                     )
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                           Flexible(
            //                             flex: 1,
            //                             child: Padding(
            //                               padding: EdgeInsets.all(8),
            //                               child: Container(
            //
            //                                 height: 50,
            //                                 child:  SizedBox(
            //                                   height: 45,
            //                                   child: Directionality(
            //                                     textDirection: TextDirection.rtl,
            //                                     child: Padding(
            //                                       padding: EdgeInsets.only(right: 10,left: 10),
            //                                       child: TextFormField(
            //                                           keyboardType:  TextInputType.multiline,
            //                                           obscureText: false,
            //
            //                                           textAlign: TextAlign.center,
            //                                           textAlignVertical: TextAlignVertical.center,
            //                                           onChanged: (_newValue) {
            //
            //                                             setState(() {
            //                                               _userOfFilecontroller .value = TextEditingValue(
            //                                                 text: _newValue,
            //                                                 selection: TextSelection.fromPosition(
            //                                                   TextPosition(offset: _newValue.length),
            //                                                 ),
            //                                               );
            //                                             });
            //                                           },
            //
            //                                           controller:_userOfFilecontroller,
            //
            //                                           decoration: InputDecoration(
            //                                             fillColor:  Colors.white,
            //                                             filled: true,
            //
            //                                             contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            //                                             hintText:"صاحب الملف ",
            //                                             hintStyle: TextStyle(
            //                                                 fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                             ),
            //
            //                                             border: myinputborder(),
            //                                             enabledBorder: myinputborder(),
            //                                             focusedBorder: myfocusborder(),
            //
            //                                           )
            //
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //
            //
            //                           Flexible(
            //                             flex: 1,
            //                             child: Padding(
            //                               padding: EdgeInsets.all(8),
            //
            //                               child: Container(
            //
            //                                 height: 50,
            //                                 child:  SizedBox(
            //                                   height: 45,
            //                                   child: Directionality(
            //                                     textDirection: TextDirection.rtl,
            //                                     child: Padding(
            //                                       padding: EdgeInsets.only(right: 10,left: 10),
            //                                       child: TextFormField(
            //                                           keyboardType:  TextInputType.number,
            //                                           obscureText: false,
            //
            //                                           textAlign: TextAlign.center,
            //                                           textAlignVertical: TextAlignVertical.center,
            //                                           onChanged: (_newValue) {
            //
            //                                             setState(() {
            //                                               _orderNumbercontroller.value = TextEditingValue(
            //                                                 text: _newValue,
            //                                                 selection: TextSelection.fromPosition(
            //                                                   TextPosition(offset: _newValue.length),
            //                                                 ),
            //                                               );
            //                                             });
            //                                           },
            //
            //                                           controller:_orderNumbercontroller,
            //
            //                                           decoration: InputDecoration(
            //                                             fillColor:  Colors.white,
            //                                             filled: true,
            //
            //                                             contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
            //                                             hintText:"رقم الطلب",
            //                                             hintStyle: TextStyle(
            //                                                 fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                             ),
            //
            //                                             border: myinputborder(),
            //                                             enabledBorder: myinputborder(),
            //                                             focusedBorder: myfocusborder(),
            //
            //                                           )
            //
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                           Flexible(
            //                             flex: 1,
            //                             child: Padding(
            //                               padding: EdgeInsets.all(8),
            //
            //                               child: Container(
            //
            //                                 height: 50,
            //                                 child:  SizedBox(
            //                                   height: 45,
            //                                   child: Directionality(
            //                                     textDirection: TextDirection.rtl,
            //                                     child: Padding(
            //                                       padding: EdgeInsets.only(right: 10,left: 10),
            //                                       child: TextFormField(
            //                                           keyboardType:  TextInputType.number,
            //                                           obscureText: false,
            //
            //                                           textAlign: TextAlign.center,
            //                                           textAlignVertical: TextAlignVertical.center,
            //                                           onChanged: (_newValue) {
            //
            //                                             setState(() {
            //                                               _fileNumbercontroller.value = TextEditingValue(
            //                                                 text: _newValue,
            //                                                 selection: TextSelection.fromPosition(
            //                                                   TextPosition(offset: _newValue.length),
            //                                                 ),
            //                                               );
            //                                             });
            //                                           },
            //
            //                                           controller:_fileNumbercontroller,
            //
            //                                           decoration: InputDecoration(
            //                                             fillColor:  Colors.white,
            //                                             filled: true,
            //
            //                                             contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
            //                                             hintText:"رقم الملف",
            //                                             hintStyle: TextStyle(
            //                                                 fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                             ),
            //
            //                                             border: myinputborder(),
            //                                             enabledBorder: myinputborder(),
            //                                             focusedBorder: myfocusborder(),
            //
            //                                           )
            //
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //
            //                         ],),
            //                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                         children: [
            //
            //
            //                           Flexible(
            //                             flex: 1,
            //                             child : Padding(
            //                               padding: EdgeInsets.all(8),
            //                               child: Container(
            //
            //                                 height: 50,
            //                                 child:
            //
            //                                 SizedBox(height: 55,
            //
            //                                     child: TextButton(
            //                                       onPressed: (){
            //                                         searchBtnPressed();
            //
            //
            //                                       },
            //                                       style: TextButton.styleFrom(
            //                                         shape: RoundedRectangleBorder(
            //                                           borderRadius:
            //                                           BorderRadius.circular(15),
            //                                         ),
            //                                         backgroundColor:
            //                                         CustomColors.colorPrimary,
            //                                       ),
            //                                       child: Center(
            //                                         child: Text(
            //                                           textScaleFactor: textScaleFactor,
            //                                           "بحث",
            //                                           style: TextStyle(
            //                                               color: Color(0xFFF5F5F5),
            //                                               fontFamily:
            //                                               "Al-Jazeera-Arabic-Bold",
            //                                               fontSize: 14),
            //                                         ),
            //                                       ),
            //                                     )
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //
            //
            //
            //                           Flexible(
            //                             flex: 1,
            //                             child: Padding(
            //                               padding: EdgeInsets.all(8),
            //
            //                               child: Container(
            //
            //                                 height: 50,
            //                                 child:  SizedBox(
            //                                   height: 45,
            //                                   child: Directionality(
            //                                     textDirection: TextDirection.rtl,
            //                                     child: Padding(
            //                                       padding: EdgeInsets.only(right: 10,left: 10),
            //                                       child: TextFormField(
            //                                           keyboardType:  TextInputType.multiline,
            //                                           obscureText: false,
            //
            //                                           textAlign: TextAlign.center,
            //                                           textAlignVertical: TextAlignVertical.center,
            //                                           onChanged: (_newValue) {
            //
            //                                             setState(() {
            //                                               _landNumbercontroller.value = TextEditingValue(
            //                                                 text: _newValue,
            //                                                 selection: TextSelection.fromPosition(
            //                                                   TextPosition(offset: _newValue.length),
            //                                                 ),
            //                                               );
            //                                             });
            //                                           },
            //
            //                                           controller:_landNumbercontroller,
            //
            //                                           decoration: InputDecoration(
            //                                             fillColor: Colors.white,
            //                                             filled: true,
            //
            //                                             contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
            //                                             hintText:"القطعة",
            //                                             hintStyle: TextStyle(
            //                                                 fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                             ),
            //
            //                                             border: myinputborder(),
            //                                             enabledBorder: myinputborder(),
            //                                             focusedBorder: myfocusborder(),
            //
            //                                           )
            //
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                           Flexible(
            //                             flex: 1,
            //                             child: Padding(
            //                               padding: EdgeInsets.all(8),
            //                               child: Container(
            //
            //                                 height: 50,
            //                                 child:  SizedBox(
            //                                   height: 45,
            //                                   child: Directionality(
            //                                     textDirection: TextDirection.rtl,
            //                                     child: Padding(
            //                                       padding: EdgeInsets.only(right: 10,left: 10),
            //                                       child: TextFormField(
            //                                           keyboardType:  TextInputType.number,
            //                                           obscureText: false,
            //
            //                                           textAlign: TextAlign.center,
            //                                           textAlignVertical: TextAlignVertical.center,
            //                                           onChanged: (_newValue) {
            //
            //                                             setState(() {
            //                                               _hwdcontroller.value = TextEditingValue(
            //                                                 text: _newValue,
            //                                                 selection: TextSelection.fromPosition(
            //                                                   TextPosition(offset: _newValue.length),
            //                                                 ),
            //                                               );
            //                                             });
            //                                           },
            //
            //                                           controller:_hwdcontroller,
            //
            //                                           decoration: InputDecoration(
            //                                             fillColor:  Colors.white,
            //                                             filled: true,
            //
            //                                             contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            //                                             hintText:" الحوض",
            //                                             hintStyle: TextStyle(
            //                                                 fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                             ),
            //
            //                                             border: myinputborder(),
            //                                             enabledBorder: myinputborder(),
            //                                             focusedBorder: myfocusborder(),
            //
            //                                           )
            //
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //
            //                         ],),
            //
            //
            //
            //
            //                     ],
            //                   ); // if orientation is portrait, show your portrait layout
            //               else {
            //                 return  Column(
            //                   children: [
            //                     SizedBox(height: 10,),
            //                     Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                       children: [
            //
            //                         Flexible(
            //                             flex: 1,
            //                             child:
            //
            //                             Padding(
            //                               padding: const EdgeInsets.only(  bottom: 5),
            //                               child: Container(
            //                                 height: 45,  //gives the height of the dropdown button
            //                                 width: MediaQuery.of(context).size.width, //gives the width of the dropdown button
            //                                 decoration: BoxDecoration(
            //
            //                                     border: Border.all(
            //                                       color:CustomColors.colorPrimary,
            //                                       width: 0.6,
            //                                     ),
            //                                     borderRadius: BorderRadius.all(Radius.circular(20)
            //
            //                                     ),
            //                                     color: Colors.white
            //                                 ),
            //                                 // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
            //                                 child: Theme(
            //                                     data: Theme.of(context).copyWith(
            //                                         canvasColor: Colors.white, // background color for the dropdown items
            //                                         buttonTheme: ButtonTheme.of(context).copyWith(
            //                                           alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
            //                                         )
            //                                     ),
            //                                     child:
            //
            //                                     DropdownButtonHideUnderline(  // to hide the default underline of the dropdown button
            //                                       child: DropdownButton<String>(
            //                                         isExpanded: true,
            //
            //
            //                                         hint: Center(
            //                                           child: Text(
            //                                             'الحي',
            //                                             style: TextStyle(
            //                                               fontSize: 18,
            //                                               color: Theme.of(context).hintColor,
            //                                             ),
            //                                           ),
            //                                         ),
            //                                         iconEnabledColor: Colors.black,  // icon color of the dropdown button
            //                                         items: hay.map((String value){
            //                                           return DropdownMenuItem<String>(
            //                                             value: value,
            //                                             child: Center(
            //                                               child: Text(value,
            //                                                 style: TextStyle(
            //                                                     fontFamily: "Al-Jazeera-Arabic-Regular",
            //                                                     fontSize: 19
            //                                                 ),
            //                                               ),
            //                                             ),
            //                                           );
            //                                         }).toList(),
            //                                         // setting hint
            //                                         onChanged:  (String? newValue) {
            //                                           setState(() {
            //                                             print("newValue$newValue");
            //                                             selectval = newValue;
            //                                             print(selectval);
            //                                           });
            //                                         },
            //                                         value: selectval,  // displaying the selected value
            //                                       ),
            //                                     )
            //                                 ),
            //                               ),
            //                             )
            //                         ),
            //                         Flexible(
            //                           flex: 1,
            //                           child: Padding(
            //                             padding: EdgeInsets.all(8),
            //                             child: Container(
            //
            //                               height: 50,
            //                               child:  SizedBox(
            //                                 height: 45,
            //                                 child: Directionality(
            //                                   textDirection: TextDirection.rtl,
            //                                   child: Padding(
            //                                     padding: EdgeInsets.only(right: 10,left: 10),
            //                                     child: TextFormField(
            //                                         keyboardType:  TextInputType.multiline,
            //                                         obscureText: false,
            //
            //                                         textAlign: TextAlign.center,
            //                                         textAlignVertical: TextAlignVertical.center,
            //                                         onChanged: (_newValue) {
            //
            //                                           setState(() {
            //                                             _userOfFilecontroller .value = TextEditingValue(
            //                                               text: _newValue,
            //                                               selection: TextSelection.fromPosition(
            //                                                 TextPosition(offset: _newValue.length),
            //                                               ),
            //                                             );
            //                                           });
            //                                         },
            //
            //                                         controller:_userOfFilecontroller,
            //
            //                                         decoration: InputDecoration(
            //                                           fillColor:  Colors.white,
            //                                           filled: true,
            //
            //                                           contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            //                                           hintText:"صاحب الملف ",
            //                                           hintStyle: TextStyle(
            //                                               fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                           ),
            //
            //                                           border: myinputborder(),
            //                                           enabledBorder: myinputborder(),
            //                                           focusedBorder: myfocusborder(),
            //
            //                                         )
            //
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //
            //
            //                         Flexible(
            //                           flex: 1,
            //                           child: Padding(
            //                             padding: EdgeInsets.all(8),
            //
            //                             child: Container(
            //
            //                               height: 50,
            //                               child:  SizedBox(
            //                                 height: 45,
            //                                 child: Directionality(
            //                                   textDirection: TextDirection.rtl,
            //                                   child: Padding(
            //                                     padding: EdgeInsets.only(right: 10,left: 10),
            //                                     child: TextFormField(
            //                                         keyboardType:  TextInputType.number,
            //                                         obscureText: false,
            //
            //                                         textAlign: TextAlign.center,
            //                                         textAlignVertical: TextAlignVertical.center,
            //                                         onChanged: (_newValue) {
            //
            //                                           setState(() {
            //                                             _orderNumbercontroller.value = TextEditingValue(
            //                                               text: _newValue,
            //                                               selection: TextSelection.fromPosition(
            //                                                 TextPosition(offset: _newValue.length),
            //                                               ),
            //                                             );
            //                                           });
            //                                         },
            //
            //                                         controller:_orderNumbercontroller,
            //
            //                                         decoration: InputDecoration(
            //                                           fillColor:  Colors.white,
            //                                           filled: true,
            //
            //                                           contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
            //                                           hintText:"رقم الطلب",
            //                                           hintStyle: TextStyle(
            //                                               fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                           ),
            //
            //                                           border: myinputborder(),
            //                                           enabledBorder: myinputborder(),
            //                                           focusedBorder: myfocusborder(),
            //
            //                                         )
            //
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                         Flexible(
            //                           flex: 1,
            //                           child: Padding(
            //                             padding: EdgeInsets.all(8),
            //
            //                             child: Container(
            //
            //                               height: 50,
            //                               child:  SizedBox(
            //                                 height: 45,
            //                                 child: Directionality(
            //                                   textDirection: TextDirection.rtl,
            //                                   child: Padding(
            //                                     padding: EdgeInsets.only(right: 10,left: 10),
            //                                     child: TextFormField(
            //                                         keyboardType:  TextInputType.number,
            //                                         obscureText: false,
            //
            //                                         textAlign: TextAlign.center,
            //                                         textAlignVertical: TextAlignVertical.center,
            //                                         onChanged: (_newValue) {
            //
            //                                           setState(() {
            //                                             _fileNumbercontroller.value = TextEditingValue(
            //                                               text: _newValue,
            //                                               selection: TextSelection.fromPosition(
            //                                                 TextPosition(offset: _newValue.length),
            //                                               ),
            //                                             );
            //                                           });
            //                                         },
            //
            //                                         controller:_fileNumbercontroller,
            //
            //                                         decoration: InputDecoration(
            //                                           fillColor:  Colors.white,
            //                                           filled: true,
            //
            //                                           contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
            //                                           hintText:"رقم الملف",
            //                                           hintStyle: TextStyle(
            //                                               fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                           ),
            //
            //                                           border: myinputborder(),
            //                                           enabledBorder: myinputborder(),
            //                                           focusedBorder: myfocusborder(),
            //
            //                                         )
            //
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //
            //                       ],),
            //                     Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                       children: [
            //
            //
            //                         Flexible(
            //                           flex: 1,
            //                           child : Padding(
            //                             padding: EdgeInsets.all(8),
            //                             child: Container(
            //
            //                               height: 50,
            //                               child:
            //
            //                               SizedBox(height: 55,
            //
            //                                   child: TextButton(
            //                                     onPressed: (){
            //                                       searchBtnPressed();
            //
            //
            //                                     },
            //                                     style: TextButton.styleFrom(
            //                                       shape: RoundedRectangleBorder(
            //                                         borderRadius:
            //                                         BorderRadius.circular(15),
            //                                       ),
            //                                       backgroundColor:
            //                                       CustomColors.colorPrimary,
            //                                     ),
            //                                     child: Center(
            //                                       child: Text(
            //                                         textScaleFactor: textScaleFactor,
            //                                         "بحث",
            //                                         style: TextStyle(
            //                                             color: Color(0xFFF5F5F5),
            //                                             fontFamily:
            //                                             "Al-Jazeera-Arabic-Bold",
            //                                             fontSize: 14),
            //                                       ),
            //                                     ),
            //                                   )
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //
            //
            //
            //                         Flexible(
            //                           flex: 1,
            //                           child: Padding(
            //                             padding: EdgeInsets.all(8),
            //
            //                             child: Container(
            //
            //                               height: 50,
            //                               child:  SizedBox(
            //                                 height: 45,
            //                                 child: Directionality(
            //                                   textDirection: TextDirection.rtl,
            //                                   child: Padding(
            //                                     padding: EdgeInsets.only(right: 10,left: 10),
            //                                     child: TextFormField(
            //                                         keyboardType:  TextInputType.multiline,
            //                                         obscureText: false,
            //
            //                                         textAlign: TextAlign.center,
            //                                         textAlignVertical: TextAlignVertical.center,
            //                                         onChanged: (_newValue) {
            //
            //                                           setState(() {
            //                                             _landNumbercontroller.value = TextEditingValue(
            //                                               text: _newValue,
            //                                               selection: TextSelection.fromPosition(
            //                                                 TextPosition(offset: _newValue.length),
            //                                               ),
            //                                             );
            //                                           });
            //                                         },
            //
            //                                         controller:_landNumbercontroller,
            //
            //                                         decoration: InputDecoration(
            //                                           fillColor: Colors.white,
            //                                           filled: true,
            //
            //                                           contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
            //                                           hintText:"القطعة",
            //                                           hintStyle: TextStyle(
            //                                               fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                           ),
            //
            //                                           border: myinputborder(),
            //                                           enabledBorder: myinputborder(),
            //                                           focusedBorder: myfocusborder(),
            //
            //                                         )
            //
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                         Flexible(
            //                           flex: 1,
            //                           child: Padding(
            //                             padding: EdgeInsets.all(8),
            //                             child: Container(
            //
            //                               height: 50,
            //                               child:  SizedBox(
            //                                 height: 45,
            //                                 child: Directionality(
            //                                   textDirection: TextDirection.rtl,
            //                                   child: Padding(
            //                                     padding: EdgeInsets.only(right: 10,left: 10),
            //                                     child: TextFormField(
            //                                         keyboardType:  TextInputType.number,
            //                                         obscureText: false,
            //
            //                                         textAlign: TextAlign.center,
            //                                         textAlignVertical: TextAlignVertical.center,
            //                                         onChanged: (_newValue) {
            //
            //                                           setState(() {
            //                                             _hwdcontroller.value = TextEditingValue(
            //                                               text: _newValue,
            //                                               selection: TextSelection.fromPosition(
            //                                                 TextPosition(offset: _newValue.length),
            //                                               ),
            //                                             );
            //                                           });
            //                                         },
            //
            //                                         controller:_hwdcontroller,
            //
            //                                         decoration: InputDecoration(
            //                                           fillColor:  Colors.white,
            //                                           filled: true,
            //
            //                                           contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            //                                           hintText:" الحوض",
            //                                           hintStyle: TextStyle(
            //                                               fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
            //                                           ),
            //
            //                                           border: myinputborder(),
            //                                           enabledBorder: myinputborder(),
            //                                           focusedBorder: myfocusborder(),
            //
            //                                         )
            //
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //
            //                       ],),
            //
            //
            //
            //
            //                   ],
            //                 ); // else show the landscape one
            //               }
            //             });
            //
            //
            //         }
            //       },
            //
            //     )
            // ),






        ));

      }


  Widget   PhoneApp(){


      return  BlocConsumer<TanzeemIndexBloc, TanzeemIndexState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is TanzeemIndexLoaded) {
              //print(state.data.body);

              if(state.data.body.contains("[]") ){

                return
                  Column(
                    children: [
                      SizedBox(height: 10,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.multiline,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _userOfFilecontroller .value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_userOfFilecontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            hintText:"صاحب الملف ",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),

                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.number,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _orderNumbercontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_orderNumbercontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                            hintText:"رقم الطلب",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),

                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.number,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _fileNumbercontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_fileNumbercontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                            hintText:"رقم الملف",
                                            hintStyle: TextStyle(
                                                fontSize: 13.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],),


                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),

                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.multiline,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _landNumbercontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_landNumbercontroller,

                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                            hintText:"القطعة",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.number,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _hwdcontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_hwdcontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            hintText:"رقم الحوض",
                                            hintStyle: TextStyle(
                                                fontSize: 11.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child:

                            Padding(
                              padding: const EdgeInsets.only(  bottom: 5),
                              child:

            Container(
            height: 35,  //gives the height of the dropdown button
            width: MediaQuery.of(context).size.width, //gives the width of the dropdown button
            decoration: BoxDecoration(

            border: Border.all(
            color:CustomColors.colorPrimary,
            width: 0.6,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15)

            ),
            color: Colors.white
            ),
            // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
            child: Theme(
            data: Theme.of(context).copyWith(
            canvasColor: Colors.white, // background color for the dropdown items
            buttonTheme: ButtonTheme.of(context).copyWith(
            alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
            )
            ),
            child:
            DropdownButtonHideUnderline(  // to hide the default underline of the dropdown button
            child: DropdownButton<String>(
            isExpanded: true,


            hint: Center(
            child: Text(
            'الحي',
            style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).hintColor,
            ),
            ),
            ),
            iconEnabledColor: Colors.black,  // icon color of the dropdown button
            items: hay.map((String value){
            return DropdownMenuItem<String>(
            value: value,
            child: Center(
            child: Text(value,
            style: TextStyle(
            fontFamily: "Al-Jazeera-Arabic-Regular",
            fontSize: 19
            ),
            ),
            ),
            );
            }).toList(),
            // setting hint
            onChanged:  (String? newValue) {
            setState(() {
            selectval = newValue!;
            });
            },
            value: selectval,  // displaying the selected value
            ),
            )
            ),
            )




                            ),
                          ),

                        ],),



                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 1,
                            child : Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(

                                height: 50,
                                child:

                                SizedBox(height: 45,

                                    child: TextButton(
                                      onPressed: (){
                                        searchBtnPressed();


                                      },
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                        backgroundColor:
                                        CustomColors.colorPrimary,
                                      ),
                                      child: Center(
                                        child: Text(
                                          textScaleFactor: textScaleFactor,
                                          "بحث",
                                          style: TextStyle(
                                              color: Color(0xFFF5F5F5),
                                              fontFamily:
                                              "Al-Jazeera-Arabic-Bold",
                                              fontSize: 14),
                                        ),
                                      ),
                                    )
                                ),
                              ),
                            ),
                          ),



                        ],),

                      SizedBox(height: 20,),
                      Center(child:   Text("لا تتوفر بيانات",style: TextStyle(color: Colors.red,
                          fontSize: 18,
                          fontFamily: "Al-Jazeera-Arabic-Bold")),)


                    ],
                  );

              }
              else{

                TanzeemIndexData = [];

                String jsonsDataString = state.data.body.toString();
                // toString of Response's body is assigned to jsonDataString
                String receivedJson = jsonsDataString;



                List<TanzeemIndex> responseobj =  (jsonDecode(jsonsDataString)as List).map((x) => TanzeemIndex.fromJson(x))
                    .toList();
                TanzeemIndexData = responseobj;


                return

                  Column(
                    children: [
                      SizedBox(height: 10,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.multiline,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _userOfFilecontroller .value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_userOfFilecontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            hintText:"صاحب الملف ",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),

                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.number,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _orderNumbercontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_orderNumbercontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                            hintText:"رقم الطلب",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),

                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.number,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _fileNumbercontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_fileNumbercontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                            hintText:"رقم الملف",
                                            hintStyle: TextStyle(
                                                fontSize: 13.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),




                        ],),


                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),

                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.multiline,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _landNumbercontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_landNumbercontroller,

                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                            hintText:"القطعة",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.number,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _hwdcontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_hwdcontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            hintText:"رقم الحوض",
                                            hintStyle: TextStyle(
                                                fontSize: 11.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child:

                            Padding(
                              padding: const EdgeInsets.only(  bottom: 5),
                              child:
                              Container(
                                height: 35,  //gives the height of the dropdown button
                                width: MediaQuery.of(context).size.width, //gives the width of the dropdown button
                                decoration: BoxDecoration(

                                    border: Border.all(
                                      color:CustomColors.colorPrimary,
                                      width: 0.6,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(15)

                                    ),
                                    color: Colors.white
                                ),
                                // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
                                child: Theme(
                                    data: Theme.of(context).copyWith(
                                        canvasColor: Colors.white, // background color for the dropdown items
                                        buttonTheme: ButtonTheme.of(context).copyWith(
                                          alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
                                        )
                                    ),
                                    child:
                                    DropdownButtonHideUnderline(  // to hide the default underline of the dropdown button
                                      child: DropdownButton<String>(
                                        isExpanded: true,


                                        hint: Center(
                                          child: Text(
                                            'الحي',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                        ),
                                        iconEnabledColor: Colors.black,  // icon color of the dropdown button
                                        items: hay.map((String value){
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Center(
                                              child: Text(value,
                                                style: TextStyle(
                                                    fontFamily: "Al-Jazeera-Arabic-Regular",
                                                    fontSize: 19
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        // setting hint
                                        onChanged:  (String? newValue) {
                                          setState(() {
                                            selectval = newValue!;
                                          });
                                        },
                                        value: selectval,  // displaying the selected value
                                      ),
                                    )
                                ),
                              ),
                            ),
                          ),

                        ],),



                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 1,
                            child : Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(

                                height: 50,
                                child:

                                SizedBox(height: 45,

                                    child: TextButton(
                                      onPressed: (){
                                        searchBtnPressed();


                                      },
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                        backgroundColor:
                                        CustomColors.colorPrimary,
                                      ),
                                      child: Center(
                                        child: Text(
                                          textScaleFactor: textScaleFactor,
                                          "بحث",
                                          style: TextStyle(
                                              color: Color(0xFFF5F5F5),
                                              fontFamily:
                                              "Al-Jazeera-Arabic-Bold",
                                              fontSize: 14),
                                        ),
                                      ),
                                    )
                                ),
                              ),
                            ),
                          ),








                        ],),




                      Expanded(
                        child: GridView.builder(
                          itemCount:TanzeemIndexData.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.all(8.0),
                          physics: const ScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, // number of items in each row
                            mainAxisSpacing: 20.0, // spacing between rows
                            crossAxisSpacing: 20.0,
                            childAspectRatio: 1.2,// spacing between columns
                          ),
                          itemBuilder: (context, index) {
                            return Container(

                              color:   TanzeemIndexData[index].isArchived ?Colors.lightGreen.withOpacity(0.4):

                              Colors.grey.withOpacity(0.1),

                              // decoration: BoxDecoration(
                              //   color: Colors.grey.withOpacity(0.06),
                              //   borderRadius: BorderRadius.circular(20), //border corner radius
                              //   boxShadow:[
                              //     BoxShadow(
                              //       color: Colors.grey.withOpacity(0.1), //color of shadow
                              //       spreadRadius: 5, //spread radius
                              //       blurRadius: 2, // blur radius
                              //       offset: Offset(0, 2), // changes position of shadow
                              //       //first paramerter of offset is left-right
                              //       //second parameter is top to down
                              //     ),
                              //     //you can set more BoxShadow() here
                              //   ],
                              // ),

                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Container (
                                    width: MediaQuery.of(context).size.width*0.8,
                                    padding: EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Directionality(

                                            textDirection: TextDirection.rtl,
                                            child: Text(textScaleFactor: textScaleFactor,

                                              textAlign: TextAlign.right,

                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "Al-Jazeera-Arabic-Bold"),
                                              TanzeemIndexData[index].fileManualNo  ,
                                              softWrap: false,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,),
                                          ),
                                        ),
                                        SizedBox(width: 4,),

                                        Text(textScaleFactor: textScaleFactor,

                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Al-Jazeera-Arabic-Regular"),
                                            ":رقم الملف   ",
                                            softWrap: false),
                                        SizedBox(width: 8,),
                                        Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                        )

                                      ],
                                    ),
                                  ),


                                  Container (
                                    width: MediaQuery.of(context).size.width*0.8,
                                    padding: EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Directionality(

                                            textDirection: TextDirection.rtl,
                                            child: Text(textScaleFactor: textScaleFactor,

                                              textAlign: TextAlign.right,

                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "Al-Jazeera-Arabic-Bold"),
                                              TanzeemIndexData[index].orderTypeDesc.toString(),
                                              softWrap: false,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,),
                                          ),
                                        ),
                                        SizedBox(width: 4,),

                                        Text(textScaleFactor: textScaleFactor,

                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Al-Jazeera-Arabic-Regular"),
                                            ":نوع الطلب   ",
                                            softWrap: false),
                                        SizedBox(width: 8,),
                                        Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                        )

                                      ],
                                    ),
                                  ),

                                  Container (
                                    width: MediaQuery.of(context).size.width*0.8,
                                    padding: EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Directionality(

                                            textDirection: TextDirection.rtl,
                                            child: Text(textScaleFactor: textScaleFactor,

                                              textAlign: TextAlign.right,

                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "Al-Jazeera-Arabic-Bold"),
                                              TanzeemIndexData[index].orderNo.toString() ,
                                              softWrap: false,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,),
                                          ),
                                        ),
                                        SizedBox(width: 4,),

                                        Text(textScaleFactor: textScaleFactor,

                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Al-Jazeera-Arabic-Regular"),
                                            ":رقم الطلب  ",
                                            softWrap: false),
                                        SizedBox(width: 8,),
                                        Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                        )

                                      ],
                                    ),
                                  ),
                                  Container (
                                    width: MediaQuery.of(context).size.width*0.8,
                                    padding: EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Directionality(

                                            textDirection: TextDirection.rtl,
                                            child: Text(textScaleFactor: textScaleFactor,

                                              textAlign: TextAlign.right,

                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "Al-Jazeera-Arabic-Bold"),
                                              TanzeemIndexData[index].orderDate.toString().split("T").first,
                                              softWrap: false,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,),
                                          ),
                                        ),
                                        SizedBox(width: 4,),

                                        Text(textScaleFactor: textScaleFactor,

                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Al-Jazeera-Arabic-Regular"),
                                            ":تاريخ الطلب   ",
                                            softWrap: false),
                                        SizedBox(width: 8,),
                                        Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                        )

                                      ],
                                    ),
                                  ),



                                  Container (
                                    width: MediaQuery.of(context).size.width*0.8,
                                    padding: EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Directionality(

                                            textDirection: TextDirection.rtl,
                                            child: Text(textScaleFactor: textScaleFactor,

                                              textAlign: TextAlign.right,

                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "Al-Jazeera-Arabic-Bold"),
                                              TanzeemIndexData[index].hawdNo.toString() + " " +  TanzeemIndexData[index].hawdName.toString()  ,
                                              softWrap: false,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,),
                                          ),
                                        ),
                                        SizedBox(width: 4,),

                                        Text(textScaleFactor: textScaleFactor,

                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Al-Jazeera-Arabic-Regular"),
                                            ": حوض/حي ",
                                            softWrap: false),
                                        SizedBox(width: 8,),
                                        Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                        )

                                      ],
                                    ),
                                  ),


                                  Container (
                                    width: MediaQuery.of(context).size.width*0.8,
                                    padding: EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(textScaleFactor: textScaleFactor,

                                            textAlign: TextAlign.right,

                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Al-Jazeera-Arabic-Bold"),
                                            TanzeemIndexData[index].landNo.toString(),
                                            softWrap: false,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,),
                                        ),
                                        SizedBox(width: 4,),

                                        Text(textScaleFactor: textScaleFactor,

                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Al-Jazeera-Arabic-Regular"),
                                            ":قطعة  ",
                                            softWrap: false),
                                        SizedBox(width: 8,),
                                        Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                        )

                                      ],
                                    ),
                                  ),



                                  Container (
                                    width: MediaQuery.of(context).size.width*0.8,
                                    padding: EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(textScaleFactor: textScaleFactor,

                                            textAlign: TextAlign.right,

                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Al-Jazeera-Arabic-Bold"),
                                            TanzeemIndexData[index].citizenName.toString() == "null"? "NA": TanzeemIndexData[index].citizenName.toString(),
                                            softWrap: false,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,),
                                        ),
                                        SizedBox(width: 4,),

                                        Text(textScaleFactor: textScaleFactor,

                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Al-Jazeera-Arabic-Regular"),
                                            ":المواطن ",
                                            softWrap: false),
                                        SizedBox(width: 8,),
                                        Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                        )

                                      ],
                                    ),
                                  ),

                                  Container (
                                    width: MediaQuery.of(context).size.width*0.8,
                                    padding: EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            TanzeemIndexData[index].location,


                                            textScaleFactor: textScaleFactor,

                                            textAlign: TextAlign.right,

                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Al-Jazeera-Arabic-Bold"),

                                            softWrap: false,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,),
                                        ),
                                        SizedBox(width: 4,),

                                        Text(textScaleFactor: textScaleFactor,

                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Al-Jazeera-Arabic-Regular"),
                                            ":الموقع  ",
                                            softWrap: false),
                                        SizedBox(width: 8,),
                                        Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                        )

                                      ],
                                    ),
                                  ),
                                  Container (
                                    width: MediaQuery.of(context).size.width*0.8,
                                    padding: EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            TanzeemIndexData[index].notes != ""?TanzeemIndexData[index].notes: "لا يوجد ملاحظات",


                                            textScaleFactor: textScaleFactor,

                                            textAlign: TextAlign.right,

                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Al-Jazeera-Arabic-Bold"),

                                            softWrap: false,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,),
                                        ),
                                        SizedBox(width: 4,),

                                        Text(textScaleFactor: textScaleFactor,

                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Al-Jazeera-Arabic-Regular"),
                                            ":الملاحظات  ",
                                            softWrap: false),
                                        SizedBox(width: 8,),
                                        Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                        )

                                      ],
                                    ),
                                  ),





                                  SizedBox(height:5,),

                                  InkWell(
                                    onTap: (){

                                      int ordernumber = 0;
                                      String file_Manual_No = "0";



                                      if( TanzeemIndexData[index].fileManualNo == ""){
                                        file_Manual_No = "0";
                                      }else{
                                        file_Manual_No = TanzeemIndexData[index].fileManualNo;
                                      }

                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>

                                          AttachmentScreen(TanzeemIndexData[index].orderNo,file_Manual_No)

                                      ));


                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Align(alignment:
                                      Alignment.bottomLeft,
                                        child:

                                        Text(textScaleFactor: textScaleFactor,
                                          'الملف الالكتروني',
                                          style: TextStyle(

                                            shadows: [
                                              Shadow(
                                                blurRadius:10.0,  // shadow blur
                                                color: Colors.orange, // shadow color
                                                offset: Offset(2.0,2.0), // how much shadow will be shown
                                              ),
                                            ],
                                            fontSize: 14,
                                            fontFamily: "Al-Jazeera-Arabic-Bold",
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),


                                      ),
                                    ),
                                  )
                                ],
                              ),


                            );
                          },
                        ),
                      ),



                    ],
                  );


              }


            }

            else if (state is TanzeemIndexLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {

              return
                Column(
                  children: [
                    SizedBox(height: 10,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.multiline,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _userOfFilecontroller .value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_userOfFilecontroller,

                                        decoration: InputDecoration(
                                          fillColor:  Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          hintText:"صاحب الملف ",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),

                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.number,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _orderNumbercontroller.value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_orderNumbercontroller,

                                        decoration: InputDecoration(
                                          fillColor:  Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                          hintText:"رقم الطلب",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),

                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.number,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _fileNumbercontroller.value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_fileNumbercontroller,

                                        decoration: InputDecoration(
                                          fillColor:  Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                          hintText:"رقم الملف",
                                          hintStyle: TextStyle(
                                              fontSize: 13.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),



                      ],),


                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),

                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.multiline,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _landNumbercontroller.value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_landNumbercontroller,

                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                          hintText:"القطعة",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.number,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _hwdcontroller.value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_hwdcontroller,

                                        decoration: InputDecoration(
                                          fillColor:  Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          hintText:"رقم الحوض",
                                          hintStyle: TextStyle(
                                              fontSize: 11.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child:


                          Padding(
                              padding: const EdgeInsets.only(  bottom: 5),
                              child:
                              Container(
                                height: 35,  //gives the height of the dropdown button
                                width: MediaQuery.of(context).size.width, //gives the width of the dropdown button
                                decoration: BoxDecoration(

                                    border: Border.all(
                                      color:CustomColors.colorPrimary,
                                      width: 0.6,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(15)

                                    ),
                                    color: Colors.white
                                ),
                                // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
                                child: Theme(
                                    data: Theme.of(context).copyWith(
                                        canvasColor: Colors.white, // background color for the dropdown items
                                        buttonTheme: ButtonTheme.of(context).copyWith(
                                          alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
                                        )
                                    ),
                                    child:
                                    DropdownButtonHideUnderline(  // to hide the default underline of the dropdown button
                                      child: DropdownButton<String>(
                                        isExpanded: true,


                                        hint: Center(
                                          child: Text(
                                            'الحي',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                        ),
                                        iconEnabledColor: Colors.black,  // icon color of the dropdown button
                                        items: hay.map((String value){
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Center(
                                              child: Text(value,
                                                style: TextStyle(
                                                    fontFamily: "Al-Jazeera-Arabic-Regular",
                                                    fontSize: 19
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        // setting hint
                                        onChanged:  (String? newValue) {
                                          setState(() {
                                            selectval = newValue!;
                                          });
                                        },
                                        value: selectval,  // displaying the selected value
                                      ),
                                    )
                                ),
                              )
                          ),
                        ),

                      ],),



                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 1,
                          child : Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(

                              height: 50,
                              child:

                              SizedBox(height: 45,

                                  child: TextButton(
                                    onPressed: (){
                                      searchBtnPressed();


                                    },
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15),
                                      ),
                                      backgroundColor:
                                      CustomColors.colorPrimary,
                                    ),
                                    child: Center(
                                      child: Text(
                                        textScaleFactor: textScaleFactor,
                                        "بحث",
                                        style: TextStyle(
                                            color: Color(0xFFF5F5F5),
                                            fontFamily:
                                            "Al-Jazeera-Arabic-Bold",
                                            fontSize: 14),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ),








                      ],),


                  ],
                );


            }
          },

        );



      }

  Widget   tabletApp(){


    return  BlocConsumer<TanzeemIndexBloc, TanzeemIndexState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TanzeemIndexLoaded) {
          //print(state.data.body);

          if(state.data.body.contains("[]") ){

            return    OrientationBuilder(builder: (_, orientation) {
              if (orientation == Orientation.portrait)
                return


                  Column(
                    children: [
                      SizedBox(height: 10,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [



                          Flexible(
                            flex: 1,
                            child:
                            Padding(
                              padding: const EdgeInsets.only(  bottom: 5),
                              child: Container(
                                height: 45,  //gives the height of the dropdown button
                                width: MediaQuery.of(context).size.width, //gives the width of the dropdown button
                                decoration: BoxDecoration(

                                    border: Border.all(
                                      color:CustomColors.colorPrimary,
                                      width: 0.6,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20)

                                    ),
                                    color: Colors.white
                                ),
                                // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
                                child: Theme(
                                    data: Theme.of(context).copyWith(
                                        canvasColor: Colors.white, // background color for the dropdown items
                                        buttonTheme: ButtonTheme.of(context).copyWith(
                                          alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
                                        )
                                    ),
                                    child:
                                    DropdownButtonHideUnderline(  // to hide the default underline of the dropdown button
                                      child: DropdownButton<String>(
                                        isExpanded: true,


                                        hint: Center(
                                          child: Text(
                                            'الحي',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                        ),
                                        iconEnabledColor: Colors.black,  // icon color of the dropdown button
                                        items: hay.map((String value){
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Center(
                                              child: Text(value,
                                                style: TextStyle(
                                                    fontFamily: "Al-Jazeera-Arabic-Regular",
                                                    fontSize: 19
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        // setting hint
                                        onChanged:  (String? newValue) {
                                          setState(() {
                                            selectval = newValue!;
                                          });
                                        },
                                        value: selectval,  // displaying the selected value
                                      ),
                                    )
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.multiline,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _userOfFilecontroller .value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_userOfFilecontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            hintText:"صاحب الملف ",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),


                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),

                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.number,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _orderNumbercontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_orderNumbercontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                            hintText:"رقم الطلب",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),

                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.number,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _fileNumbercontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_fileNumbercontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                            hintText:"رقم الملف",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [


                          Flexible(
                            flex: 1,
                            child : Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(

                                height: 50,
                                child:

                                SizedBox(height: 55,

                                    child: TextButton(
                                      onPressed: (){
                                        searchBtnPressed();


                                      },
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                        backgroundColor:
                                        CustomColors.colorPrimary,
                                      ),
                                      child: Center(
                                        child: Text(
                                          textScaleFactor: textScaleFactor,
                                          "بحث",
                                          style: TextStyle(
                                              color: Color(0xFFF5F5F5),
                                              fontFamily:
                                              "Al-Jazeera-Arabic-Bold",
                                              fontSize: 14),
                                        ),
                                      ),
                                    )
                                ),
                              ),
                            ),
                          ),



                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),

                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.multiline,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _landNumbercontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_landNumbercontroller,

                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                            hintText:"القطعة",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.number,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _hwdcontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_hwdcontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            hintText:" الحوض",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],),

                      SizedBox(height: 20,),
                      Center(child:   Text("لا تتوفر بيانات",style: TextStyle(color: Colors.red,
                          fontSize: 18,
                          fontFamily: "Al-Jazeera-Arabic-Bold")),)



                    ],
                  ); // if orientation is portrait, show your portrait layout
              else
                return  Column(
                  children: [
                    SizedBox(height: 10,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [



                        Flexible(
                          flex: 1,
                          child:

                          Padding(
                            padding: const EdgeInsets.only(  bottom: 5),
                            child: Container(
                              height: 45,  //gives the height of the dropdown button
                              width: MediaQuery.of(context).size.width, //gives the width of the dropdown button
                              decoration: BoxDecoration(

                                  border: Border.all(
                                    color:CustomColors.colorPrimary,
                                    width: 0.6,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(20)

                                  ),
                                  color: Colors.white
                              ),
                              // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
                              child: Theme(
                                  data: Theme.of(context).copyWith(
                                      canvasColor: Colors.white, // background color for the dropdown items
                                      buttonTheme: ButtonTheme.of(context).copyWith(
                                        alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
                                      )
                                  ),
                                  child:

                                  DropdownButtonHideUnderline(  // to hide the default underline of the dropdown button
                                    child: DropdownButton<String>(
                                      isExpanded: true,


                                      hint: Center(
                                        child: Text(
                                          'الحي',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ),
                                      iconEnabledColor: Colors.black,  // icon color of the dropdown button
                                      items: hay.map((String value){
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Center(
                                            child: Text(value,
                                              style: TextStyle(
                                                  fontFamily: "Al-Jazeera-Arabic-Regular",
                                                  fontSize: 19
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      // setting hint
                                      onChanged:  (String? newValue) {
                                        setState(() {
                                          selectval = newValue!;
                                        });
                                      },
                                      value: selectval,  // displaying the selected value
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.multiline,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _userOfFilecontroller .value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_userOfFilecontroller,

                                        decoration: InputDecoration(
                                          fillColor:  Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          hintText:"صاحب الملف ",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),


                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),

                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.number,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _orderNumbercontroller.value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_orderNumbercontroller,

                                        decoration: InputDecoration(
                                          fillColor:  Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                          hintText:"رقم الطلب",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),

                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.number,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _fileNumbercontroller.value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_fileNumbercontroller,

                                        decoration: InputDecoration(
                                          fillColor:  Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                          hintText:"رقم الملف",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [


                        Flexible(
                          flex: 1,
                          child : Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(

                              height: 50,
                              child:

                              SizedBox(height: 55,

                                  child: TextButton(
                                    onPressed: (){
                                      searchBtnPressed();


                                    },
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15),
                                      ),
                                      backgroundColor:
                                      CustomColors.colorPrimary,
                                    ),
                                    child: Center(
                                      child: Text(
                                        textScaleFactor: textScaleFactor,
                                        "بحث",
                                        style: TextStyle(
                                            color: Color(0xFFF5F5F5),
                                            fontFamily:
                                            "Al-Jazeera-Arabic-Bold",
                                            fontSize: 14),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ),



                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),

                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.multiline,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _landNumbercontroller.value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_landNumbercontroller,

                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                          hintText:"القطعة",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.number,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _hwdcontroller.value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_hwdcontroller,

                                        decoration: InputDecoration(
                                          fillColor:  Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          hintText:" الحوض",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],),

                    SizedBox(height: 20,),
                    Center(child:   Text("لا تتوفر بيانات",style: TextStyle(color: Colors.red,
                        fontSize: 18,
                        fontFamily: "Al-Jazeera-Arabic-Bold")),)






                  ],
                ); // else show the landscape one
            });

          }
          else{

            TanzeemIndexData = [];

            String jsonsDataString = state.data.body.toString();
            // toString of Response's body is assigned to jsonDataString
            String receivedJson = jsonsDataString;


            List<TanzeemIndex> responseobj =  (jsonDecode(jsonsDataString)as List).map((x) => TanzeemIndex.fromJson(x))
                .toList();
            TanzeemIndexData = responseobj;


            return

              OrientationBuilder(builder: (_, orientation) {
                if (orientation == Orientation.portrait)
                  return _buildPortraitLayout(); // if orientation is portrait, show your portrait layout
                else
                  return _buildLandscapeLayout(); // else show the landscape one
              });


          }


        }

        else if (state is TanzeemIndexLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {

          return
            OrientationBuilder(builder: (_, orientation) {
              if (orientation == Orientation.portrait)
                return



                  Column(
                    children: [
                      SizedBox(height: 10,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [



                          Flexible(
                            flex: 1,
                            child:

                            Padding(
                              padding: const EdgeInsets.only(  bottom: 5),
                              child: Container(
                                height: 45,  //gives the height of the dropdown button
                                width: MediaQuery.of(context).size.width, //gives the width of the dropdown button
                                decoration: BoxDecoration(

                                    border: Border.all(
                                      color:CustomColors.colorPrimary,
                                      width: 0.6,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20)

                                    ),
                                    color: Colors.white
                                ),
                                // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
                                child: Theme(
                                    data: Theme.of(context).copyWith(
                                        canvasColor: Colors.white, // background color for the dropdown items
                                        buttonTheme: ButtonTheme.of(context).copyWith(
                                          alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
                                        )
                                    ),
                                    child:        DropdownButtonHideUnderline(  // to hide the default underline of the dropdown button
                                      child: DropdownButton<String>(
                                        isExpanded: true,


                                        hint: Center(
                                          child: Text(
                                            'الحي',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                        ),
                                        iconEnabledColor: Colors.black,  // icon color of the dropdown button
                                        items: hay.map((String value){
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Center(
                                              child: Text(value,
                                                style: TextStyle(
                                                    fontFamily: "Al-Jazeera-Arabic-Regular",
                                                    fontSize: 19
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        // setting hint
                                        onChanged:  (String? newValue) {

                                          setState(() {
                                            selectval = newValue;

                                            print(selectval);

                                          });
                                        },
                                        value: selectval,  // displaying the selected value
                                      ),
                                    )
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.multiline,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _userOfFilecontroller .value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_userOfFilecontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            hintText:"صاحب الملف ",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),


                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),

                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.number,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _orderNumbercontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_orderNumbercontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                            hintText:"رقم الطلب",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),

                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.number,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _fileNumbercontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_fileNumbercontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                            hintText:"رقم الملف",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [


                          Flexible(
                            flex: 1,
                            child : Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(

                                height: 50,
                                child:

                                SizedBox(height: 55,

                                    child: TextButton(
                                      onPressed: (){
                                        searchBtnPressed();


                                      },
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                        backgroundColor:
                                        CustomColors.colorPrimary,
                                      ),
                                      child: Center(
                                        child: Text(
                                          textScaleFactor: textScaleFactor,
                                          "بحث",
                                          style: TextStyle(
                                              color: Color(0xFFF5F5F5),
                                              fontFamily:
                                              "Al-Jazeera-Arabic-Bold",
                                              fontSize: 14),
                                        ),
                                      ),
                                    )
                                ),
                              ),
                            ),
                          ),



                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),

                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.multiline,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _landNumbercontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_landNumbercontroller,

                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                            hintText:"القطعة",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(

                                height: 50,
                                child:  SizedBox(
                                  height: 45,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10,left: 10),
                                      child: TextFormField(
                                          keyboardType:  TextInputType.number,
                                          obscureText: false,

                                          textAlign: TextAlign.center,
                                          textAlignVertical: TextAlignVertical.center,
                                          onChanged: (_newValue) {

                                            setState(() {
                                              _hwdcontroller.value = TextEditingValue(
                                                text: _newValue,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: _newValue.length),
                                                ),
                                              );
                                            });
                                          },

                                          controller:_hwdcontroller,

                                          decoration: InputDecoration(
                                            fillColor:  Colors.white,
                                            filled: true,

                                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            hintText:" الحوض",
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                            ),

                                            border: myinputborder(),
                                            enabledBorder: myinputborder(),
                                            focusedBorder: myfocusborder(),

                                          )

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],),




                    ],
                  ); // if orientation is portrait, show your portrait layout
              else {
                return  Column(
                  children: [
                    SizedBox(height: 10,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Flexible(
                            flex: 1,
                            child:

                            Padding(
                              padding: const EdgeInsets.only(  bottom: 5),
                              child: Container(
                                height: 45,  //gives the height of the dropdown button
                                width: MediaQuery.of(context).size.width, //gives the width of the dropdown button
                                decoration: BoxDecoration(

                                    border: Border.all(
                                      color:CustomColors.colorPrimary,
                                      width: 0.6,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20)

                                    ),
                                    color: Colors.white
                                ),
                                // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
                                child: Theme(
                                    data: Theme.of(context).copyWith(
                                        canvasColor: Colors.white, // background color for the dropdown items
                                        buttonTheme: ButtonTheme.of(context).copyWith(
                                          alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
                                        )
                                    ),
                                    child:

                                    DropdownButtonHideUnderline(  // to hide the default underline of the dropdown button
                                      child: DropdownButton<String>(
                                        isExpanded: true,


                                        hint: Center(
                                          child: Text(
                                            'الحي',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                        ),
                                        iconEnabledColor: Colors.black,  // icon color of the dropdown button
                                        items: hay.map((String value){
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Center(
                                              child: Text(value,
                                                style: TextStyle(
                                                    fontFamily: "Al-Jazeera-Arabic-Regular",
                                                    fontSize: 19
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        // setting hint
                                        onChanged:  (String? newValue) {
                                          setState(() {
                                            print("newValue$newValue");
                                            selectval = newValue;
                                            print(selectval);
                                          });
                                        },
                                        value: selectval,  // displaying the selected value
                                      ),
                                    )
                                ),
                              ),
                            )
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.multiline,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _userOfFilecontroller .value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_userOfFilecontroller,

                                        decoration: InputDecoration(
                                          fillColor:  Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          hintText:"صاحب الملف ",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),


                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),

                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.number,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _orderNumbercontroller.value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_orderNumbercontroller,

                                        decoration: InputDecoration(
                                          fillColor:  Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                          hintText:"رقم الطلب",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),

                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.number,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _fileNumbercontroller.value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_fileNumbercontroller,

                                        decoration: InputDecoration(
                                          fillColor:  Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                          hintText:"رقم الملف",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [


                        Flexible(
                          flex: 1,
                          child : Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(

                              height: 50,
                              child:

                              SizedBox(height: 55,

                                  child: TextButton(
                                    onPressed: (){
                                      searchBtnPressed();


                                    },
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15),
                                      ),
                                      backgroundColor:
                                      CustomColors.colorPrimary,
                                    ),
                                    child: Center(
                                      child: Text(
                                        textScaleFactor: textScaleFactor,
                                        "بحث",
                                        style: TextStyle(
                                            color: Color(0xFFF5F5F5),
                                            fontFamily:
                                            "Al-Jazeera-Arabic-Bold",
                                            fontSize: 14),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ),



                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),

                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.multiline,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _landNumbercontroller.value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_landNumbercontroller,

                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                          hintText:"القطعة",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(

                              height: 50,
                              child:  SizedBox(
                                height: 45,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10,left: 10),
                                    child: TextFormField(
                                        keyboardType:  TextInputType.number,
                                        obscureText: false,

                                        textAlign: TextAlign.center,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {
                                            _hwdcontroller.value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );
                                          });
                                        },

                                        controller:_hwdcontroller,

                                        decoration: InputDecoration(
                                          fillColor:  Colors.white,
                                          filled: true,

                                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          hintText:" الحوض",
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                          ),

                                          border: myinputborder(),
                                          enabledBorder: myinputborder(),
                                          focusedBorder: myfocusborder(),

                                        )

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],),




                  ],
                ); // else show the landscape one
              }
            });


        }
      },

    );
  }


  Widget _buildPortraitLayout(){



    return



      Column(
        children: [
          SizedBox(height: 10,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [



              Flexible(
                flex: 1,
                child:

                Padding(
                  padding: const EdgeInsets.only(  bottom: 5),
                  child: Container(
                    height: 45,  //gives the height of the dropdown button
                    width: MediaQuery.of(context).size.width, //gives the width of the dropdown button
                    decoration: BoxDecoration(

                        border: Border.all(
                          color:CustomColors.colorPrimary,
                          width: 0.6,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)

                        ),
                        color: Colors.white
                    ),
                    // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
                    child: Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor: Colors.white, // background color for the dropdown items
                            buttonTheme: ButtonTheme.of(context).copyWith(
                              alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
                            )
                        ),
                        child:
                        DropdownButtonHideUnderline(  // to hide the default underline of the dropdown button
                          child: DropdownButton<String>(
                            isExpanded: true,


                            hint: Center(
                              child: Text(
                                'الحي',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                            iconEnabledColor: Colors.black,  // icon color of the dropdown button
                            items: hay.map((String value){
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(
                                  child: Text(value,
                                    style: TextStyle(
                                        fontFamily: "Al-Jazeera-Arabic-Regular",
                                        fontSize: 19
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            // setting hint
                            onChanged:  (String? newValue) {
                              setState(() {
                                selectval = newValue!;
                              });
                            },
                            value: selectval,  // displaying the selected value
                          ),
                        )
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(

                    height: 50,
                    child:  SizedBox(
                      height: 45,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: TextFormField(
                              keyboardType:  TextInputType.multiline,
                              obscureText: false,

                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (_newValue) {

                                setState(() {
                                  _userOfFilecontroller .value = TextEditingValue(
                                    text: _newValue,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: _newValue.length),
                                    ),
                                  );
                                });
                              },

                              controller:_userOfFilecontroller,

                              decoration: InputDecoration(
                                fillColor:  Colors.white,
                                filled: true,

                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                hintText:"صاحب الملف ",
                                hintStyle: TextStyle(
                                    fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                ),

                                border: myinputborder(),
                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),

                              )

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),


              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8),

                  child: Container(

                    height: 50,
                    child:  SizedBox(
                      height: 45,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: TextFormField(
                              keyboardType:  TextInputType.number,
                              obscureText: false,

                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (_newValue) {

                                setState(() {
                                  _orderNumbercontroller.value = TextEditingValue(
                                    text: _newValue,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: _newValue.length),
                                    ),
                                  );
                                });
                              },

                              controller:_orderNumbercontroller,

                              decoration: InputDecoration(
                                fillColor:  Colors.white,
                                filled: true,

                                contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                hintText:"رقم الطلب",
                                hintStyle: TextStyle(
                                    fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                ),

                                border: myinputborder(),
                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),

                              )

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8),

                  child: Container(

                    height: 50,
                    child:  SizedBox(
                      height: 45,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: TextFormField(
                              keyboardType:  TextInputType.number,
                              obscureText: false,

                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (_newValue) {

                                setState(() {
                                  _fileNumbercontroller.value = TextEditingValue(
                                    text: _newValue,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: _newValue.length),
                                    ),
                                  );
                                });
                              },

                              controller:_fileNumbercontroller,

                              decoration: InputDecoration(
                                fillColor:  Colors.white,
                                filled: true,

                                contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                hintText:"رقم الملف",
                                hintStyle: TextStyle(
                                    fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                ),

                                border: myinputborder(),
                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),

                              )

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [


              Flexible(
                flex: 1,
                child : Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(

                    height: 50,
                    child:

                    SizedBox(height: 55,

                        child: TextButton(
                          onPressed: (){
                            searchBtnPressed();


                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(15),
                            ),
                            backgroundColor:
                            CustomColors.colorPrimary,
                          ),
                          child: Center(
                            child: Text(
                              textScaleFactor: textScaleFactor,
                              "بحث",
                              style: TextStyle(
                                  color: Color(0xFFF5F5F5),
                                  fontFamily:
                                  "Al-Jazeera-Arabic-Bold",
                                  fontSize: 14),
                            ),
                          ),
                        )
                    ),
                  ),
                ),
              ),



              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8),

                  child: Container(

                    height: 50,
                    child:  SizedBox(
                      height: 45,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: TextFormField(
                              keyboardType:  TextInputType.multiline,
                              obscureText: false,

                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (_newValue) {

                                setState(() {
                                  _landNumbercontroller.value = TextEditingValue(
                                    text: _newValue,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: _newValue.length),
                                    ),
                                  );
                                });
                              },

                              controller:_landNumbercontroller,

                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,

                                contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                hintText:"القطعة",
                                hintStyle: TextStyle(
                                    fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                ),

                                border: myinputborder(),
                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),

                              )

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(

                    height: 50,
                    child:  SizedBox(
                      height: 45,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: TextFormField(
                              keyboardType:  TextInputType.number,
                              obscureText: false,

                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (_newValue) {

                                setState(() {
                                  _hwdcontroller.value = TextEditingValue(
                                    text: _newValue,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: _newValue.length),
                                    ),
                                  );
                                });
                              },

                              controller:_hwdcontroller,

                              decoration: InputDecoration(
                                fillColor:  Colors.white,
                                filled: true,

                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                hintText:" الحوض",
                                hintStyle: TextStyle(
                                    fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                ),

                                border: myinputborder(),
                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),

                              )

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],),


          Expanded(
            child: GridView.builder(
              itemCount:TanzeemIndexData.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(8.0),
              physics: const ScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // number of items in each row
                mainAxisSpacing: 20.0, // spacing between rows
                crossAxisSpacing: 20.0,
                childAspectRatio: 0.65,// spacing between columns
              ),
              itemBuilder: (context, index) {
                return Container(

                  color:   TanzeemIndexData[index].isArchived ?Colors.lightGreen.withOpacity(0.4):

                  Colors.grey.withOpacity(0.1),

                  // decoration: BoxDecoration(
                  //   color: Colors.grey.withOpacity(0.06),
                  //   borderRadius: BorderRadius.circular(20), //border corner radius
                  //   boxShadow:[
                  //     BoxShadow(
                  //       color: Colors.grey.withOpacity(0.1), //color of shadow
                  //       spreadRadius: 5, //spread radius
                  //       blurRadius: 2, // blur radius
                  //       offset: Offset(0, 2), // changes position of shadow
                  //       //first paramerter of offset is left-right
                  //       //second parameter is top to down
                  //     ),
                  //     //you can set more BoxShadow() here
                  //   ],
                  // ),

                  child: Column(
                    children: [
                      SizedBox(height: 5,),

                      Container (
                        width: MediaQuery.of(context).size.width*0.8,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(textScaleFactor: textScaleFactor,

                                  textAlign: TextAlign.right,

                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Al-Jazeera-Arabic-Bold"),
                                  TanzeemIndexData[index].fileManualNo,
                                  softWrap: false,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                            SizedBox(width: 4,),

                            Text(textScaleFactor: textScaleFactor,

                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Regular"),
                                ":رقم الملف   "
                                ,
                                softWrap: false),
                            SizedBox(width: 8,),
                            Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                            )

                          ],
                        ),
                      ),


                      Container (
                        width: MediaQuery.of(context).size.width*0.8,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(textScaleFactor: textScaleFactor,

                                  textAlign: TextAlign.right,

                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Al-Jazeera-Arabic-Bold"),
                                  TanzeemIndexData[index].orderTypeDesc.toString(),
                                  softWrap: false,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                            SizedBox(width: 4,),

                            Text(textScaleFactor: textScaleFactor,

                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Regular"),
                                ":نوع الطلب   "
                                ,
                                softWrap: false),
                            SizedBox(width: 8,),
                            Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                            )

                          ],
                        ),
                      ),

                      Container (
                        width: MediaQuery.of(context).size.width*0.8,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(textScaleFactor: textScaleFactor,

                                  textAlign: TextAlign.right,

                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Al-Jazeera-Arabic-Bold"),
                                  TanzeemIndexData[index].orderNo.toString(),
                                  softWrap: false,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                            SizedBox(width: 4,),

                            Text(textScaleFactor: textScaleFactor,

                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Regular"),
                                ":رقم الطلب   "
                                ,
                                softWrap: false),
                            SizedBox(width: 8,),
                            Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                            )

                          ],
                        ),
                      ),

                      Container (
                        width: MediaQuery.of(context).size.width*0.8,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(textScaleFactor: textScaleFactor,

                                  textAlign: TextAlign.right,

                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Al-Jazeera-Arabic-Bold"),
                                  TanzeemIndexData[index].orderDate.toString().split("T").first,
                                  softWrap: false,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                            SizedBox(width: 4,),

                            Text(textScaleFactor: textScaleFactor,

                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Regular"),
                                ":تاريخ الطلب   "
                                ,
                                softWrap: false),
                            SizedBox(width: 8,),
                            Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                            )

                          ],
                        ),
                      ),


                      Container (
                        width: MediaQuery.of(context).size.width*0.8,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(textScaleFactor: textScaleFactor,

                                  textAlign: TextAlign.right,

                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Al-Jazeera-Arabic-Bold"),
                                  TanzeemIndexData[index].hawdNo.toString() + " " +  TanzeemIndexData[index].hayName.toString(),
                                  softWrap: false,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                            SizedBox(width: 4,),

                            Text(textScaleFactor: textScaleFactor,

                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Regular"),
                                ":  حوض/حي  "
                                ,
                                softWrap: false),
                            SizedBox(width: 8,),
                            Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                            )

                          ],
                        ),
                      ),


                      Container (
                        width: MediaQuery.of(context).size.width*0.8,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(textScaleFactor: textScaleFactor,

                                textAlign: TextAlign.right,

                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Bold"),
                                TanzeemIndexData[index].landNo.toString(),
                                softWrap: false,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,),
                            ),
                            SizedBox(width: 4,),

                            Text(textScaleFactor: textScaleFactor,

                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Regular"),
                                ": قطعة  ",
                                softWrap: false),
                            SizedBox(width: 8,),
                            Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                            )

                          ],
                        ),
                      ),

                      Container (
                        width: MediaQuery.of(context).size.width*0.8,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(textScaleFactor: textScaleFactor,
                                TanzeemIndexData[index].citizenName.toString() == "null"? "NA": TanzeemIndexData[index].citizenName.toString(),
                                textAlign: TextAlign.right,

                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Bold"),

                                softWrap: false,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,),
                            ),
                            SizedBox(width: 4,),

                            Text(textScaleFactor: textScaleFactor,

                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Regular"),
                                ": المواطن ",
                                softWrap: false),
                            SizedBox(width: 8,),
                            Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                            )

                          ],
                        ),
                      ),

                      Container (
                        width: MediaQuery.of(context).size.width*0.8,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(textScaleFactor: textScaleFactor,
                                TanzeemIndexData[index].location,
                                textAlign: TextAlign.right,

                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Bold"),

                                softWrap: false,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,),
                            ),
                            SizedBox(width: 4,),

                            Text(textScaleFactor: textScaleFactor,

                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Regular"),
                                ":الموقع ",
                                softWrap: false),
                            SizedBox(width: 8,),
                            Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                            )

                          ],
                        ),
                      ),

                      Container (
                        width: MediaQuery.of(context).size.width*0.8,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(textScaleFactor: textScaleFactor,
                                TanzeemIndexData[index].notes != "" ?TanzeemIndexData[index].notes : "لا يوجد ملاحظات",
                                textAlign: TextAlign.right,

                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Bold"),

                                softWrap: false,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,),
                            ),
                            SizedBox(width: 4,),

                            Text(textScaleFactor: textScaleFactor,

                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Regular"),
                                ":الملاحظات ",
                                softWrap: false),
                            SizedBox(width: 8,),
                            Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                            )

                          ],
                        ),
                      ),




                      SizedBox(height:8,),

                      InkWell(
                        onTap: (){

                          int ordernumber = 0;
                          String file_Manual_No = "0";



                          if( TanzeemIndexData[index].fileManualNo == ""){
                            file_Manual_No = "0";
                          }else{
                            file_Manual_No = TanzeemIndexData[index].fileManualNo;
                          }

                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>

                              AttachmentScreen(TanzeemIndexData[index].orderNo,file_Manual_No)

                          ));


                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(alignment:
                          Alignment.bottomLeft,
                            child:




                            Text(textScaleFactor: textScaleFactor,
                              'الملف الالكتروني',
                              style: TextStyle(

                                shadows: [
                                  Shadow(
                                    blurRadius:10.0,  // shadow blur
                                    color: Colors.orange, // shadow color
                                    offset: Offset(2.0,2.0), // how much shadow will be shown
                                  ),
                                ],
                                fontSize: 14,
                                fontFamily: "Al-Jazeera-Arabic-Bold",
                                decoration: TextDecoration.underline,
                              ),
                            ),


                          ),
                        ),
                      )


                    ],
                  ),


                );
              },
            ),
          ),



        ],
      ) ;


  }


  Widget _buildLandscapeLayout(){
    return
      Column(
        children: [
          SizedBox(height: 10,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [



              Flexible(
                flex: 1,
                child:
                Padding(
                  padding: const EdgeInsets.only(  bottom: 5),
                  child: Container(
                    height: 45,  //gives the height of the dropdown button
                    width: MediaQuery.of(context).size.width, //gives the width of the dropdown button
                    decoration: BoxDecoration(

                        border: Border.all(
                          color:CustomColors.colorPrimary,
                          width: 0.6,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)

                        ),
                        color: Colors.white
                    ),
                    // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
                    child: Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor: Colors.white, // background color for the dropdown items
                            buttonTheme: ButtonTheme.of(context).copyWith(
                              alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
                            )
                        ),
                        child:
                        DropdownButtonHideUnderline(  // to hide the default underline of the dropdown button
                          child: DropdownButton<String>(
                            isExpanded: true,


                            hint: Center(
                              child: Text(
                                'الحي',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                            iconEnabledColor: Colors.black,  // icon color of the dropdown button
                            items: hay.map((String value){
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(
                                  child: Text(value,
                                    style: TextStyle(
                                        fontFamily: "Al-Jazeera-Arabic-Regular",
                                        fontSize: 19
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            // setting hint
                            onChanged:  (String? newValue) {
                              setState(() {
                                selectval = newValue!;
                              });
                            },
                            value: selectval,  // displaying the selected value
                          ),
                        )
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(

                    height: 50,
                    child:  SizedBox(
                      height: 45,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: TextFormField(
                              keyboardType:  TextInputType.multiline,
                              obscureText: false,

                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (_newValue) {

                                setState(() {
                                  _userOfFilecontroller .value = TextEditingValue(
                                    text: _newValue,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: _newValue.length),
                                    ),
                                  );
                                });
                              },

                              controller:_userOfFilecontroller,

                              decoration: InputDecoration(
                                fillColor:  Colors.white,
                                filled: true,

                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                hintText:"صاحب الملف ",
                                hintStyle: TextStyle(
                                    fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                ),

                                border: myinputborder(),
                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),

                              )

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),


              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8),

                  child: Container(

                    height: 50,
                    child:  SizedBox(
                      height: 45,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: TextFormField(
                              keyboardType:  TextInputType.number,
                              obscureText: false,

                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (_newValue) {

                                setState(() {
                                  _orderNumbercontroller.value = TextEditingValue(
                                    text: _newValue,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: _newValue.length),
                                    ),
                                  );
                                });
                              },

                              controller:_orderNumbercontroller,

                              decoration: InputDecoration(
                                fillColor:  Colors.white,
                                filled: true,

                                contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                hintText:"رقم الطلب",
                                hintStyle: TextStyle(
                                    fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                ),

                                border: myinputborder(),
                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),

                              )

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8),

                  child: Container(

                    height: 50,
                    child:  SizedBox(
                      height: 45,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: TextFormField(
                              keyboardType:  TextInputType.number,
                              obscureText: false,

                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (_newValue) {

                                setState(() {
                                  _fileNumbercontroller.value = TextEditingValue(
                                    text: _newValue,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: _newValue.length),
                                    ),
                                  );
                                });
                              },

                              controller:_fileNumbercontroller,

                              decoration: InputDecoration(
                                fillColor:  Colors.white,
                                filled: true,

                                contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                hintText:"رقم الملف",
                                hintStyle: TextStyle(
                                    fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                ),

                                border: myinputborder(),
                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),

                              )

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [


              Flexible(
                flex: 1,
                child : Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(

                    height: 50,
                    child:

                    SizedBox(height: 55,

                        child: TextButton(
                          onPressed: (){
                            searchBtnPressed();


                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(15),
                            ),
                            backgroundColor:
                            CustomColors.colorPrimary,
                          ),
                          child: Center(
                            child: Text(
                              textScaleFactor: textScaleFactor,
                              "بحث",
                              style: TextStyle(
                                  color: Color(0xFFF5F5F5),
                                  fontFamily:
                                  "Al-Jazeera-Arabic-Bold",
                                  fontSize: 14),
                            ),
                          ),
                        )
                    ),
                  ),
                ),
              ),



              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8),

                  child: Container(

                    height: 50,
                    child:  SizedBox(
                      height: 45,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: TextFormField(
                              keyboardType:  TextInputType.multiline,
                              obscureText: false,

                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (_newValue) {

                                setState(() {
                                  _landNumbercontroller.value = TextEditingValue(
                                    text: _newValue,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: _newValue.length),
                                    ),
                                  );
                                });
                              },

                              controller:_landNumbercontroller,

                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,

                                contentPadding: EdgeInsets.fromLTRB(4, 4, 10, 10),
                                hintText:"القطعة",
                                hintStyle: TextStyle(
                                    fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                ),

                                border: myinputborder(),
                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),

                              )

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(

                    height: 50,
                    child:  SizedBox(
                      height: 45,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: TextFormField(
                              keyboardType:  TextInputType.number,
                              obscureText: false,

                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (_newValue) {

                                setState(() {
                                  _hwdcontroller.value = TextEditingValue(
                                    text: _newValue,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: _newValue.length),
                                    ),
                                  );
                                });
                              },

                              controller:_hwdcontroller,

                              decoration: InputDecoration(
                                fillColor:  Colors.white,
                                filled: true,

                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                hintText:" الحوض",
                                hintStyle: TextStyle(
                                    fontSize: 14.0,color: Colors.grey,fontFamily: "Al-Jazeera-Arabic-Regular"
                                ),

                                border: myinputborder(),
                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),

                              )

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: GridView.builder(
                itemCount:TanzeemIndexData.length,
                shrinkWrap: true,

                padding: EdgeInsets.all(8.0),
                physics: const ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // number of items in each row
                  mainAxisSpacing: 20.0, // spacing between rows
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 0.9,// spacing between columns
                ),
                itemBuilder: (context, index) {
                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(

                    color:   TanzeemIndexData[index].isArchived ?Colors.lightGreen.withOpacity(0.4):

                      Colors.grey.withOpacity(0.1),

                      // decoration: BoxDecoration(
                      //   color: Colors.grey.withOpacity(0.06),
                      //   borderRadius: BorderRadius.circular(20), //border corner radius
                      //   boxShadow:[
                      //     BoxShadow(
                      //       color: Colors.grey.withOpacity(0.1), //color of shadow
                      //       spreadRadius: 5, //spread radius
                      //       blurRadius: 2, // blur radius
                      //       offset: Offset(0, 2), // changes position of shadow
                      //       //first paramerter of offset is left-right
                      //       //second parameter is top to down
                      //     ),
                      //     //you can set more BoxShadow() here
                      //   ],
                      // ),

                      child: Column(

                        children: [
                          SizedBox(height: 5,),
                          Container (
                            width: MediaQuery.of(context).size.width*0.8,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(textScaleFactor: textScaleFactor,

                                      textAlign: TextAlign.right,

                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Al-Jazeera-Arabic-Bold"),
                                      TanzeemIndexData[index].fileManualNo,
                                      softWrap: false,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,),
                                  ),
                                ),
                                SizedBox(width: 4,),

                                Text(textScaleFactor: textScaleFactor,

                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Al-Jazeera-Arabic-Regular"),
                                    ":رقم الملف   "
                                    ,
                                    softWrap: false),
                                SizedBox(width: 8,),
                                Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                )

                              ],
                            ),
                          ),


                          Container (
                            width: MediaQuery.of(context).size.width*0.8,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(textScaleFactor: textScaleFactor,

                                      textAlign: TextAlign.right,

                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Al-Jazeera-Arabic-Bold"),
                                      TanzeemIndexData[index].orderTypeDesc.toString(),
                                      softWrap: false,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,),
                                  ),
                                ),
                                SizedBox(width: 4,),

                                Text(textScaleFactor: textScaleFactor,

                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Al-Jazeera-Arabic-Regular"),
                                    ":نوع الطلب   "
                                    ,
                                    softWrap: false),
                                SizedBox(width: 8,),
                                Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                )

                              ],
                            ),
                          ),

                          Container (
                            width: MediaQuery.of(context).size.width*0.8,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(textScaleFactor: textScaleFactor,

                                      textAlign: TextAlign.right,

                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Al-Jazeera-Arabic-Bold"),
                                      TanzeemIndexData[index].orderNo.toString(),
                                      softWrap: false,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,),
                                  ),
                                ),
                                SizedBox(width: 4,),

                                Text(textScaleFactor: textScaleFactor,

                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Al-Jazeera-Arabic-Regular"),
                                    ":رقم الطلب   "
                                    ,
                                    softWrap: false),
                                SizedBox(width: 8,),
                                Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                )

                              ],
                            ),
                          ),

                          Container (
                            width: MediaQuery.of(context).size.width*0.8,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(textScaleFactor: textScaleFactor,

                                      textAlign: TextAlign.right,

                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Al-Jazeera-Arabic-Bold"),
                                      TanzeemIndexData[index].orderDate.toString().split("T").first,
                                      softWrap: false,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,),
                                  ),
                                ),
                                SizedBox(width: 4,),

                                Text(textScaleFactor: textScaleFactor,

                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Al-Jazeera-Arabic-Regular"),
                                    ":تاريخ الطلب   "
                                    ,
                                    softWrap: false),
                                SizedBox(width: 8,),
                                Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                )

                              ],
                            ),
                          ),


                          Container (
                            width: MediaQuery.of(context).size.width*0.8,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(textScaleFactor: textScaleFactor,

                                      textAlign: TextAlign.right,

                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Al-Jazeera-Arabic-Bold"),
                                      TanzeemIndexData[index].hawdNo.toString() + " " +  TanzeemIndexData[index].hayName.toString(),
                                      softWrap: false,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,),
                                  ),
                                ),
                                SizedBox(width: 4,),

                                Text(textScaleFactor: textScaleFactor,

                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Al-Jazeera-Arabic-Regular"),
                                    ":  حوض/حي  "
                                    ,
                                    softWrap: false),
                                SizedBox(width: 8,),
                                Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                )

                              ],
                            ),
                          ),


                          Container (
                            width: MediaQuery.of(context).size.width*0.8,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(textScaleFactor: textScaleFactor,

                                    textAlign: TextAlign.right,

                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Al-Jazeera-Arabic-Bold"),
                                    TanzeemIndexData[index].landNo.toString(),
                                    softWrap: false,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,),
                                ),
                                SizedBox(width: 4,),

                                Text(textScaleFactor: textScaleFactor,

                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Al-Jazeera-Arabic-Regular"),
                                    ": قطعة  ",
                                    softWrap: false),
                                SizedBox(width: 8,),
                                Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                )

                              ],
                            ),
                          ),

                          Container (
                            width: MediaQuery.of(context).size.width*0.8,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(textScaleFactor: textScaleFactor,
                                    TanzeemIndexData[index].citizenName.toString() == "null"? "NA": TanzeemIndexData[index].citizenName.toString(),
                                    textAlign: TextAlign.right,

                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Al-Jazeera-Arabic-Bold"),

                                    softWrap: false,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,),
                                ),
                                SizedBox(width: 4,),

                                Text(textScaleFactor: textScaleFactor,

                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Al-Jazeera-Arabic-Regular"),
                                    ": المواطن ",
                                    softWrap: false),
                                SizedBox(width: 8,),
                                Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                )

                              ],
                            ),
                          ),

                          Container (
                            width: MediaQuery.of(context).size.width*0.8,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(textScaleFactor: textScaleFactor,
                                    TanzeemIndexData[index].location,
                                    textAlign: TextAlign.right,

                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Al-Jazeera-Arabic-Bold"),

                                    softWrap: false,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,),
                                ),
                                SizedBox(width: 4,),

                                Text(textScaleFactor: textScaleFactor,

                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Al-Jazeera-Arabic-Regular"),
                                    ":الموقع ",
                                    softWrap: false),
                                SizedBox(width: 8,),
                                Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                )

                              ],
                            ),
                          ),

                          Container (
                            width: MediaQuery.of(context).size.width*0.8,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(textScaleFactor: textScaleFactor,
                                    TanzeemIndexData[index].notes != "" ?TanzeemIndexData[index].notes : "لا يوجد ملاحظات",
                                    textAlign: TextAlign.right,

                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Al-Jazeera-Arabic-Bold"),

                                    softWrap: false,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,),
                                ),
                                SizedBox(width: 4,),

                                Text(textScaleFactor: textScaleFactor,

                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Al-Jazeera-Arabic-Regular"),
                                    ":الملاحظات ",
                                    softWrap: false),
                                SizedBox(width: 8,),
                                Icon(Icons.star,color: CustomColors.colorpriority_1,size: 14,
                                )

                              ],
                            ),
                          ),




                          SizedBox(height:9,),

                          InkWell(
                            onTap: (){

                              int ordernumber = 0;
                              String file_Manual_No = "0";



                              if( TanzeemIndexData[index].fileManualNo == ""){
                                file_Manual_No = "0";
                              }else{
                                file_Manual_No = TanzeemIndexData[index].fileManualNo;
                              }

                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>

                                  AttachmentScreen(TanzeemIndexData[index].orderNo,file_Manual_No)

                              ));


                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Align(alignment:
                              Alignment.bottomLeft,
                                child:




                                Text(textScaleFactor: textScaleFactor,
                                  'الملف الالكتروني',
                                  style: TextStyle(

                                    shadows: [
                                      Shadow(
                                        blurRadius:10.0,  // shadow blur
                                        color: Colors.orange, // shadow color
                                        offset: Offset(2.0,2.0), // how much shadow will be shown
                                      ),
                                    ],
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Bold",
                                    decoration: TextDecoration.underline,
                                  ),
                                ),


                              ),
                            ),
                          )
                        ],
                      ),


                    ),
                  );
                },
              ),
            ),
          ),



        ],
      );


  }


  searchBtnPressed(){
    int hayitem = 0;

      print("sss$selectval");


      print(selectval);

      if(selectval == "الحي/غير محدد"){
        hayitem = 0;
      }else{
        for (var item in hayList) {


          if(selectval == item.hayName){
            hayitem = item.hayNo;
            print("hayitem$hayitem");
          }

        }
      }



      if(_orderNumbercontroller.text == ""
          && _hwdcontroller.text == ""

          && _userOfFilecontroller.text == ""
          && _landNumbercontroller.text == ""
          && _fileNumbercontroller.text == ""
          && (hayitem == 0 ||selectval == null )


      ){


        showAlertDialog(context, "تنبيه", "الرجاء ادخال بيانات البحث");
      }else{

        int ordernum = 0;

        int hwd = 0;
        if( _orderNumbercontroller.text == ""){
          ordernum = 0;
        }else{


          ordernum = int.parse(replaceArabicNumber(_orderNumbercontroller.text ));
        }

        if( _hwdcontroller.text == ""){
          hwd = 0;
        }else{

          hwd = int.parse(replaceArabicNumber(_hwdcontroller.text ));

        }


        BlocProvider.of<TanzeemIndexBloc>(
            context).add(SendData(
            replaceArabicNumber(_fileNumbercontroller.text),hayitem,hwd,_landNumbercontroller.text,_userOfFilecontroller.text,ordernum));



      }







  }




  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return OutlineInputBorder( //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 0.6,
        )
    );
  }


  OutlineInputBorder myfocusborder(){
    return OutlineInputBorder(

        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 0.6,
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
  String replaceArabicNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['۰', '۱', '۲', '۳', '٤', '٥', '٦', '٧', '۸', '۹'];
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
  }

}