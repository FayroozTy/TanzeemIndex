
abstract class TanzeemIndexEvent {}

class SendData extends TanzeemIndexEvent {
  String file_Manual_No;
  int hay_No;
  int hawd_No;
  String land_No;
  String citizen_Name;
  int order_No;


  SendData(this.file_Manual_No,this.hay_No,this.hawd_No,this.land_No,this.citizen_Name,this.order_No);
}