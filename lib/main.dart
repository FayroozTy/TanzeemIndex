import 'dart:async';

import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import 'Login/ui/loginScreen.dart';
import 'SearchfilesScreen/Model/HayList.dart';
import 'SearchfilesScreen/bloc/TanzeemIndex/TanzeemIndex_bloc.dart';
import 'SearchfilesScreen/repository/TanzeemServive.dart';
import 'SearchfilesScreen/ui/searchFilePage.dart';
import 'Util/Constant.dart';


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

import '../../TanzeemAttachment/ui/AttachmentScreen.dart';
import '../../Util/Constant.dart';


void main() { WidgetsFlutterBinding.ensureInitialized();
runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {

    // This widget is the root of your application.

    return MaterialApp(
      navigatorKey:navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      //builder: (context, child) => SafeArea(child: BookingListScreen()),

      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) =>  SplashScreen(),
        '/loginPage()': (context) =>  loginScreen(),



        //  '/InboxScreen()': (context) =>  InboxScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.

      },
      //home: Inform_List(),
    );
  }
}

class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {

  final TanzeemIndexBloc _tanzeemBloc = TanzeemIndexBloc(Tanzeemepository());

  bool _isLoading = false;

  List<HayList> hay = [];
  List<int> hay_noList = [];
  List<String> hay_nameList = [];

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    Timer(
        const Duration(seconds: 6),
            () async =>{
          movenext()
        }

    );

    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,


        body: Stack(
          children: <Widget>[

            Align(alignment: Alignment.topLeft,
                child: Image.asset('assets/splash_cur2.png',height: 180,)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                    child:
                    Image.asset('assets/Nablus_Logo.png')
                ),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "بلدية نابلس",
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.black,
                        fontFamily: "Al-Jazeera-Arabic-Bold"),
                  ),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "قسم التنظيم",
                    style: TextStyle(
                        fontSize: 28.0,
                        color: Color(0xFF333333),
                        fontFamily: "Al-Jazeera-Arabic-Regular"),
                  ),
                ),

              ],
            ),
            Align(alignment: Alignment.bottomRight,
                child: Image.asset('assets/splash_cur1.png',height: 150,)),
          ],
        ));
  }
  movenext() async {
    // /InboxScreen()

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String networkType = prefs.getString("network")??"";
    if(networkType == "external" || networkType == "intenal"){

      SharedPreferences prefs = await SharedPreferences.getInstance();


      String isLogin = prefs.getString("isLogin") ?? "false";

      print("islogin$isLogin");

      if (isLogin == "false"){

        navigatorKey.currentState?.pushNamed('/loginPage()');


      }else{


        Navigator.push(context,
            MaterialPageRoute(
              builder: (_) => BlocProvider<TanzeemIndexBloc>.value(
                value: _tanzeemBloc,
                child:  searchFileScreen(),
              ),

            ));


        //  navigatorKey.currentState?.pushNamed('/searchFilePage()');


      }




    }else{
      showAlertDialog( context);
    }





    // mainPage()

    // Navigator.push(context, new MaterialPageRoute(builder: (context) => InboxPage()));
  }


   showAlertDialog(BuildContext context) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("شبكة داخلية",style: TextStyle(
        fontSize: 15.0,fontFamily: "Al-Jazeera-Arabic-Bold",color: Color(0xFF923731)
    ),),
    onPressed:  () async {

      BaseURL  ="http://192.168.0.128:7575/";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("network", "intenal");

      String isLogin = prefs.getString("isLogin") ?? "false";

      print("islogin$isLogin");

      if (isLogin == "false"){

        navigatorKey.currentState?.pushNamed('/loginPage()');


      }else{

        SharedPreferences prefs = await SharedPreferences.getInstance();


        Navigator.push(context,
            MaterialPageRoute(
              builder: (_) => BlocProvider<TanzeemIndexBloc>.value(
                value: _tanzeemBloc,
                child:  searchFileScreen(),
              ),

            ));


        //  navigatorKey.currentState?.pushNamed('/searchFilePage()');


      }


    },
  );
  Widget continueButton = TextButton(
    child: Text("شبكة خارجية",style: TextStyle(
        fontSize: 15.0,fontFamily: "Al-Jazeera-Arabic-Bold", color: Color(0xFF923731)
    ),),
    onPressed:  () async {
      BaseURL = "http://83.244.112.170:7575/";

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString("network", "external");
      String isLogin = prefs.getString("isLogin") ?? "false";

      print("islogin$isLogin");

      if (isLogin == "false"){

        navigatorKey.currentState?.pushNamed('/loginPage()');


      }else{




        Navigator.push(context,
            MaterialPageRoute(
              builder: (_) => BlocProvider<TanzeemIndexBloc>.value(
                value: _tanzeemBloc,
                child:  searchFileScreen(),
              ),

            ));


        //  navigatorKey.currentState?.pushNamed('/searchFilePage()');


      }

    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    
    
    title: Center(
      child: Text("اعدادات الشبة",style: TextStyle(
          fontSize: 16.0,color: Colors.black,fontFamily: "Al-Jazeera-Arabic-Bold"
      ),),
    ),

    content: Directionality(
      textDirection: TextDirection.rtl,
      child: Text(" الرجاء اختيار نوع  الشبكة المستخدمة",style: TextStyle(
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





}
///Receive message when app is in background solution for on message




