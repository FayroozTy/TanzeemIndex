// To parse this JSON data, do
//
//     final tanzeemIndex = tanzeemIndexFromJson(jsonString);

import 'dart:convert';

List<TanzeemIndex> tanzeemIndexFromJson(String str) => List<TanzeemIndex>.from(json.decode(str).map((x) => TanzeemIndex.fromJson(x)));

String tanzeemIndexToJson(List<TanzeemIndex> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TanzeemIndex {
  int generalIndexId;
  int fileNo;
  String fileManualNo;
  int fileCitizenOwnerId;
  String citizenName;
  String landNo;
  int hawdNo;
  String hawdName;
  int hayNo;
  String hayName;
  int landId;
  String citizenAddress;
  dynamic orderId;
  dynamic orderNo;
  String notes;
  String userName;
  DateTime timeStamp;
  dynamic libIndexId;
  bool isArchived;
  dynamic orderTypeOptionId;
  dynamic orderTypeOptionDesc;
  String? orderDate;
  dynamic orderTypeId;
  dynamic orderTypeNo;
  dynamic orderTypeDesc;
  dynamic orderOwnerId;
  String? orderOwnerName;
  dynamic orderStatusId;
  dynamic orderStatusDesc;
  dynamic filingRoomId;
  dynamic roomCode;
  dynamic roomName;
  dynamic fileCabinetId;
  dynamic cabinitCode;
  dynamic cabinetName;
  dynamic columnNo;
  dynamic shelfNo;
  int fileCatId;
  String fileCatDesc;
  String location;
  bool isActive;
  int isApproved;
  dynamic approvedTanzeemFileId;
  dynamic originalGeneralIndexId;
  bool isMain;

  TanzeemIndex({
    required this.generalIndexId,
    required this.fileNo,
    required this.fileManualNo,
    required this.fileCitizenOwnerId,
    required this.citizenName,
    required this.landNo,
    required this.hawdNo,
    required this.hawdName,
    required this.hayNo,
    required this.hayName,
    required this.landId,
    required this.citizenAddress,
    required this.orderId,
    required this.orderNo,
    required this.notes,
    required this.userName,
    required this.timeStamp,
     this.libIndexId,
    required this.isArchived,
     this.orderTypeOptionId,
     this.orderTypeOptionDesc,
     this.orderDate,
     this.orderTypeId,
     this.orderTypeNo,
     this.orderTypeDesc,
     this.orderOwnerId,
     this.orderOwnerName,
     this.orderStatusId,
     this.orderStatusDesc,
     this.filingRoomId,
     this.roomCode,
     this.roomName,
     this.fileCabinetId,
     this.cabinitCode,
     this.cabinetName,
     this.columnNo,
     this.shelfNo,
    required this.fileCatId,
    required this.fileCatDesc,
    required this.location,
    required this.isActive,
    required this.isApproved,
     this.approvedTanzeemFileId,
     this.originalGeneralIndexId,
    required this.isMain,
  });

  factory TanzeemIndex.fromJson(Map<String, dynamic> json) => TanzeemIndex(
    generalIndexId: json["general_Index_ID"],
    fileNo: json["file_No"],
    fileManualNo: json["file_Manual_No"],
    fileCitizenOwnerId: json["file_Citizen_Owner_ID"],
    citizenName: json["citizen_Name"],
    landNo: json["land_no"],
    hawdNo: json["hawd_no"],
    hawdName: json["hawd_Name"],
    hayNo: json["hay_no"],
    hayName: json["hay_Name"],
    landId: json["land_ID"],
    citizenAddress: json["citizen_Address"],
    orderId: json["order_ID"],
    orderNo: json["order_No"],
    notes: json["notes"],
    userName: json["user_Name"],
    timeStamp: DateTime.parse(json["time_Stamp"]),
    libIndexId: json["lib_Index_ID"],
    isArchived: json["isArchived"],
    orderTypeOptionId: json["order_Type_Option_ID"],
    orderTypeOptionDesc: json["order_Type_Option_Desc"],
    orderDate: json["order_Date"],
    orderTypeId: json["order_Type_ID"],
    orderTypeNo: json["order_Type_No"],
    orderTypeDesc: json["order_Type_Desc"],
    orderOwnerId: json["order_Owner_ID"],
    orderOwnerName: json["order_Owner_Name"],
    orderStatusId: json["order_Status_ID"],
    orderStatusDesc: json["order_Status_Desc"],
    filingRoomId: json["filing_Room_ID"],
    roomCode: json["room_Code"],
    roomName: json["room_Name"],
    fileCabinetId: json["file_Cabinet_ID"],
    cabinitCode: json["cabinit_Code"],
    cabinetName: json["cabinet_Name"],
    columnNo: json["column_No"],
    shelfNo: json["shelf_No"],
    fileCatId: json["file_Cat_ID"],
    fileCatDesc: json["file_Cat_Desc"],
    location: json["location"],
    isActive: json["isActive"],
    isApproved: json["isApproved"],
    approvedTanzeemFileId: json["approved_Tanzeem_File_ID"],
    originalGeneralIndexId: json["original_General_Index_ID"],
    isMain: json["isMain"],
  );

  Map<String, dynamic> toJson() => {
    "general_Index_ID": generalIndexId,
    "file_No": fileNo,
    "file_Manual_No": fileManualNo,
    "file_Citizen_Owner_ID": fileCitizenOwnerId,
    "citizen_Name": citizenName,
    "land_no": landNo,
    "hawd_no": hawdNo,
    "hawd_Name": hawdName,
    "hay_no": hayNo,
    "hay_Name": hayName,
    "land_ID": landId,
    "citizen_Address": citizenAddress,
    "order_ID": orderId,
    "order_No": orderNo,
    "notes": notes,
    "user_Name": userName,
    "time_Stamp": timeStamp.toIso8601String(),
    "lib_Index_ID": libIndexId,
    "isArchived": isArchived,
    "order_Type_Option_ID": orderTypeOptionId,
    "order_Type_Option_Desc": orderTypeOptionDesc,
    "order_Date": orderDate,
    "order_Type_ID": orderTypeId,
    "order_Type_No": orderTypeNo,
    "order_Type_Desc": orderTypeDesc,
    "order_Owner_ID": orderOwnerId,
    "order_Owner_Name": orderOwnerName,
    "order_Status_ID": orderStatusId,
    "order_Status_Desc": orderStatusDesc,
    "filing_Room_ID": filingRoomId,
    "room_Code": roomCode,
    "room_Name": roomName,
    "file_Cabinet_ID": fileCabinetId,
    "cabinit_Code": cabinitCode,
    "cabinet_Name": cabinetName,
    "column_No": columnNo,
    "shelf_No": shelfNo,
    "file_Cat_ID": fileCatId,
    "file_Cat_Desc": fileCatDesc,
    "location": location,
    "isActive": isActive,
    "isApproved": isApproved,
    "approved_Tanzeem_File_ID": approvedTanzeemFileId,
    "original_General_Index_ID": originalGeneralIndexId,
    "isMain": isMain,
  };
}
