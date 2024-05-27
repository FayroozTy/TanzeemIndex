

import 'dart:async';
import 'dart:convert';

import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tanzeem/SearchfilesScreen/Model/HayList.dart';

import '../../SearchfilesScreen/bloc/TanzeemIndex/TanzeemIndex_bloc.dart';
import '../../SearchfilesScreen/repository/TanzeemServive.dart';
import '../../SearchfilesScreen/ui/searchFilePage.dart';
import '../../Util/Constant.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../../Util/network/logging.dart';

import 'package:flutter_offline/flutter_offline.dart';






class loginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _loginScreen();
  }

}

class _loginScreen extends State<loginScreen> {

  bool isDeviceConnected = false;
  bool isAlertSet = false;
  final TanzeemIndexBloc _tanzeemBloc = TanzeemIndexBloc(Tanzeemepository());


  TextEditingController userName = TextEditingController();
  var _userNamecontroller = TextEditingController();
  var _Passwordcontroller = TextEditingController();
  String token= "";
  //final DioClient _dioClient = DioClient();
  bool loading = false;
  StreamSubscription? internetconnection;
  bool isoffline = false;
  SimpleFontelicoProgressDialog? _dialog;
  bool _isLoading = false;

  bool _passwordVisible = false;



  List<HayList> hay = [];
  @override
  void initState() {

    super.initState();

  }

  @override
  void dispose() {

    super.dispose();

  }

  String replaceArabicNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['۰', '۱', '۲', '۳', '٤', '٥', '٦', '٧', '۸', '۹'];
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
  }





  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,


            body:

            OfflineBuilder(
              connectivityBuilder: (
                  BuildContext context,
                  ConnectivityResult connectivity,
                  Widget child,
                  ) {
                final bool connected = connectivity != ConnectivityResult.none;


                return
                  connected == false ?
                  Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        height:30.0,
                        top: 20.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                          child: Center(
                            child: Text("${connected ? '' : 'you are offline check your internet connection'}",style: TextStyle(color: Colors.black),),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(25),
                        child: ListView(

                          children: <Widget>[

                            _isLoading ?   Center(
                              child:
                              CircularProgressIndicator(),
                            ): Container(),
                            Center(
                                child:
                                Image.asset('assets/Nablus_Logo.png', width: 160,height: 160,)
                            ),
                            SizedBox(height: 7,),

                            Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                "بلدية نابلس",
                                style: TextStyle(
                                    fontSize: 27.0,
                                    color: Colors.black,
                                    fontFamily: "Al-Jazeera-Arabic-Bold"),
                              ),
                            ),

                            SizedBox(height: 20,),

                            Padding(
                              padding: EdgeInsets.only(right: 10,left: 10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: Text ( textScaleFactor: textScaleFactor,"رقم الهوية",
                                        style: TextStyle( fontSize: 18.0,
                                            fontFamily: "Al-Jazeera-Arabic-Regular"),),
                                    ),
                                  ]


                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 10,left: 10),
                                child: _TextFieldCustom(1  , "",Icon(Icons.person_outline) , false)),
                            SizedBox(height: 15,),
                            Padding(
                              padding: EdgeInsets.only(right: 10,left: 10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: Text ( textScaleFactor: textScaleFactor,"كلمة المرور",
                                        style: TextStyle( fontSize: 18.0,
                                            fontFamily: "Al-Jazeera-Arabic-Regular"),),
                                    ),
                                  ]


                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 10,left: 10),
                                child:
                                SizedBox(
                                  height: 45,

                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextFormField(


                                        obscureText: !_passwordVisible,




                                        textAlign: TextAlign.right,
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (_newValue) {

                                          setState(() {



                                            _Passwordcontroller.value = TextEditingValue(
                                              text: _newValue,
                                              selection: TextSelection.fromPosition(
                                                TextPosition(offset: _newValue.length),
                                              ),
                                            );

                                          });

                                        },


                                        controller:  _Passwordcontroller,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xFFF7F7F7),
                                          contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          hintText:"",
                                          border: InputBorder.none,




                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              // Based on passwordVisible state choose the icon
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.black26,
                                            ),
                                            onPressed: () {
                                              // Update the state i.e. toogle the state of passwordVisible variable
                                              setState(() {
                                                _passwordVisible = !_passwordVisible;
                                              });
                                            },
                                          ),

                                          //

                                        )
                                    ),
                                  ),
                                )


                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.only(right: 10,left: 10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: Text ( textScaleFactor: textScaleFactor," نسيت كلمة المرور",
                                        style: TextStyle( fontSize: 18.0,color: Colors.red,
                                            fontFamily: "Al-Jazeera-Arabic-Regular"),),
                                    ),
                                  ]


                              ),
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 180,
                                  height: 45,
                                  child: OutlinedButton(

                                    child: Text(
                                      textScaleFactor: textScaleFactor,"تسجيل الدخول", style: TextStyle(color: Colors.white,fontFamily: "Al-Jazeera-Arabic-Bold"),),
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor: Color(0xFF4A587A)
                                    ),
                                    onPressed: () {

                                      loginButtomPressed();



                                    },
                                  ),
                                ),
                              ],

                            ),
                          ],
                        ),
                      )
                    ],
                  ) : Padding(
                    padding: EdgeInsets.all(15),
                    child: ListView(

                      children: <Widget>[

                        _isLoading ?   Center(
                          child:
                          CircularProgressIndicator(),
                        ): Container(),
                        Center(
                            child:
                            Image.asset('assets/Nablus_Logo.png', width: 160,height: 160,)
                        ),
                        SizedBox(height: 7,),

                        Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            "بلدية نابلس",
                            style: TextStyle(
                                fontSize: 27.0,
                                color: Colors.black,
                                fontFamily: "Al-Jazeera-Arabic-Bold"),
                          ),
                        ),

                        SizedBox(height: 20,),

                        Padding(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Directionality(
                                  textDirection: ui.TextDirection.rtl,
                                  child: Text ( textScaleFactor: textScaleFactor,"رقم الهوية",
                                    style: TextStyle( fontSize: 18.0,
                                        fontFamily: "Al-Jazeera-Arabic-Regular"),),
                                ),
                              ]


                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 10,left: 10),
                            child: _TextFieldCustom(1  , "",Icon(Icons.person_outline) , false)),
                        SizedBox(height: 15,),
                        Padding(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Directionality(
                                  textDirection: ui.TextDirection.rtl,
                                  child: Text ( textScaleFactor: textScaleFactor,"كلمة المرور",
                                    style: TextStyle( fontSize: 18.0,
                                        fontFamily: "Al-Jazeera-Arabic-Regular"),),
                                ),
                              ]


                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 10,left: 10),
                            child:       SizedBox(
                              height: 45,

                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(


                                    obscureText: !_passwordVisible,




                                    textAlign: TextAlign.right,
                                    textAlignVertical: TextAlignVertical.center,
                                    onChanged: (_newValue) {

                                      setState(() {



                                        _Passwordcontroller.value = TextEditingValue(
                                          text: _newValue,
                                          selection: TextSelection.fromPosition(
                                            TextPosition(offset: _newValue.length),
                                          ),
                                        );

                                      });

                                    },


                                    controller:  _Passwordcontroller,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFFF7F7F7),
                                      contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      hintText:"",
                                      border: InputBorder.none,




                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black26,
                                        ),
                                        onPressed: () {
                                          // Update the state i.e. toogle the state of passwordVisible variable
                                          setState(() {
                                            _passwordVisible = !_passwordVisible;
                                          });
                                        },
                                      ),

                                      //

                                    )
                                ),
                              ),
                            )),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Directionality(
                                  textDirection: ui.TextDirection.rtl,
                                  child: Text ( textScaleFactor: textScaleFactor," نسيت كلمة المرور",
                                    style: TextStyle( fontSize: 18.0,color: Colors.red,
                                        fontFamily: "Al-Jazeera-Arabic-Regular"),),
                                ),
                              ]


                          ),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 180,
                              height: 45,
                              child: OutlinedButton(

                                child: Text(
                                  textScaleFactor: textScaleFactor,"تسجيل الدخول", style: TextStyle(color: Colors.white,fontFamily: "Al-Jazeera-Arabic-Bold"),),
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Color(0xFF4A587A)
                                ),
                                onPressed: () {

                                  loginButtomPressed();



                                },
                              ),
                            ),
                          ],

                        ),
                      ],
                    ),
                  );
              },
              child: Container(),



            )
        ));



  }


  loginButtomPressed() async {


    String text1 =
        _userNamecontroller.text;
    String text2 =
        _Passwordcontroller.text;


    text1 =replaceArabicNumber(text1);
    text2 =replaceArabicNumber(text2);



    if (text1 == '' || text2 == '') {
      showAlertDialog(context, "تنبيه", "الرجاء ادخال كافة البيانات");

    }

    else {
      print(text1);
      print(text2);
      setState(() {
        _isLoading = true;
      });
      // _showDialog(context, SimpleFontelicoProgressDialogType.normal, '');

      try {

        http.Response
        response = await http.post(Uri.parse(BaseURL + "api/Auth/Login"), headers: <String, String>{
          "Accept":
          "application/json",
          "Access-Control-Allow-Credentials":
          "*",
          "content-type":
          "application/json"
        }, body: jsonEncode(<String, dynamic>{
          "username": text1,
          "password": text2
        }),);




        SharedPreferences prefs =  await SharedPreferences.getInstance();

        if (response.statusCode == 200) {

            print('Add : ${response.body}');

            prefs.setString("isLogin","true");


            Navigator.push(context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider<TanzeemIndexBloc>.value(
                    value: _tanzeemBloc,
                    child:  searchFileScreen(),
                  ),

                ));



           // VerifyLoginPressed(text1);

            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return InboxScreen();
            // }));
        }
        else if (response.statusCode == 400){

          if(response.body.contains("username or password incorrect") ){
            showAlertDialog( context , "" , "خطأ في اسم المستخدم او كلمة المرور");
          }





            prefs.setString("isLogin","false");
            print(response.statusCode);

            setState(() {
              _isLoading = false;
            });

        }


        else {

          if (response.statusCode == 404){

            if(response.body.contains("username or password incorrect") ){
              showAlertDialog( context , "" , "خطأ في اسم المستخدم او كلمة المرور");
            }



          }
          prefs.setString("isLogin","false");
          print(response.statusCode);

          setState(() {
            _isLoading = false;
          });

        }
      }

      catch (e) {

        print('Error : $e');

        showAlertDialog( context , "" , "خطا في الاتصال");
        return null;
      } finally {

      }



    }

  }











  Widget _TextFieldCustom(int flag  , String lableText , Icon icon , bool obscureText) {

    return
      SizedBox(
        height: 45,

        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(


              obscureText: obscureText,




              textAlign: TextAlign.right,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (_newValue) {

                setState(() {

                  if (flag == 1) {


                    _userNamecontroller.value = TextEditingValue(
                      text: _newValue,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: _newValue.length),
                      ),
                    );
                  }
                  else{
                    _Passwordcontroller.value = TextEditingValue(
                      text: _newValue,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: _newValue.length),
                      ),
                    );
                  }
                });

              },


              controller: flag == 1 ? _userNamecontroller: _Passwordcontroller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF7F7F7),
                contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                hintText:lableText,
                border: InputBorder.none,




                suffixIcon: IconTheme(data: IconThemeData(
                    color: Colors.grey
                ), child: icon),

                //

              )
          ),
        ),
      );

  }


  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return OutlineInputBorder( //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          //color:CustomColors.backgroundColor,
          width: 1,
        )
    );
  }

  OutlineInputBorder myfocusborder(){
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          // color:CustomColors.backgroundColor,
          width: 1,
        )
    );
  }
  void _showDialog(BuildContext context, SimpleFontelicoProgressDialogType type, String text) async{
    _dialog ??= SimpleFontelicoProgressDialog(context: context);
    if(type == SimpleFontelicoProgressDialogType.custom) {
      _dialog!.show(message: text, type: type, width: 150.0, height: 75.0, loadingIndicator: const Text('C', style: TextStyle(fontSize: 24.0),));
    } else if (text == 'Normal Vertical') {
      _dialog!.show(message: text, type: SimpleFontelicoProgressDialogType.normal, horizontal: false, width: 150.0, height: 75.0, hideText: false, indicatorColor: Colors.red);
    } else if (text == 'Updating') {
      _dialog!.show(message: text, type: SimpleFontelicoProgressDialogType.normal, horizontal: true, width: 150.0, height: 75.0, hideText: false, indicatorColor: Colors.red);
      await Future.delayed(const Duration(seconds: 1));
      _dialog!.updateMessageText('Changing text');
    } else {
      _dialog!.show(message: text, type: type, horizontal: true, width: 150.0, height: 75.0, hideText: false, indicatorColor: Colors.red);
    }


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
}






