import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Util/Constant.dart';






class Tanzeemepository {

  final String _Url =  BaseURL + "api/Tanzeem/GeneralIndex?sortBy=Id&isAscending=false&pageNumber=1&pageSize=100";


  Future<http.Response>  getList(String file_Manual_No,int hay_No,
      int hawd_No,
      String land_No,  String citizen_Name,
  int order_No)async {

print({
  "tanzeem_File_Index_ID": 0,
  "file_Manual_No": file_Manual_No,
  "hay_No":hay_No,
  "hawd_No": hawd_No,
  "land_No": land_No,
  "citizen_Name":citizen_Name.replaceAll(" ", "%"),
  "order_No":order_No
});

    return http.post(Uri.parse(_Url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode(<String, dynamic>{
      "tanzeem_File_Index_ID": 0,
      "file_Manual_No": file_Manual_No,
      "hay_No":hay_No,
      "hawd_No": hawd_No,
      "land_No": land_No,
      "citizen_Name":citizen_Name.replaceAll(" ", "%"),
      "order_No":order_No
    }),);




  }
}