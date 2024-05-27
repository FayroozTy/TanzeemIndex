// To parse this JSON data, do
//
//     final attachment = attachmentFromJson(jsonString);

import 'dart:convert';

List<Attachment> attachmentFromJson(String str) => List<Attachment>.from(json.decode(str).map((x) => Attachment.fromJson(x)));

String attachmentToJson(List<Attachment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Attachment {
  int libIndex;
  String fileUrl;
  int documentId;
  int documentTypeId;
  String documentTypeDesc;
  int sortSequence;

  Attachment({
    required this.libIndex,
    required this.fileUrl,
    required this.documentId,
    required this.documentTypeId,
    required this.documentTypeDesc,
    required this.sortSequence,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    libIndex: json["libIndex"],
    fileUrl: json["fileUrl"],
    documentId: json["documentId"],
    documentTypeId: json["documentTypeId"],
    documentTypeDesc: json["documentTypeDesc"],
    sortSequence: json["sortSequence"],
  );

  Map<String, dynamic> toJson() => {
    "libIndex": libIndex,
    "fileUrl": fileUrl,
    "documentId": documentId,
    "documentTypeId": documentTypeId,
    "documentTypeDesc": documentTypeDesc,
    "sortSequence": sortSequence,
  };
}
