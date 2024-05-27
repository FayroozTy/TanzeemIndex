// To parse this JSON data, do
//
//     final hayList = hayListFromJson(jsonString);

import 'dart:convert';

List<HayList> hayListFromJson(String str) => List<HayList>.from(json.decode(str).map((x) => HayList.fromJson(x)));

String hayListToJson(List<HayList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HayList {
  int hayNo;
  String hayName;

  HayList({
    required this.hayNo,
    required this.hayName,
  });

  factory HayList.fromJson(Map<String, dynamic> json) => HayList(
    hayNo: json["hay_No"],
    hayName: json["hay_Name"],
  );

  Map<String, dynamic> toJson() => {
    "hay_No": hayNo,
    "hay_Name": hayName,
  };
}
