import 'package:bloc/bloc.dart';
import 'package:http/http.dart';

import '../../repository/TanzeemServive.dart';
import 'TanzeemIndex_state.dart';
import 'TanzeemIndex_event.dart';


class TanzeemIndexBloc extends Bloc<TanzeemIndexEvent, TanzeemIndexState> {
  late Response data;
  final Tanzeemepository TanzeemIndexRepo;

  TanzeemIndexBloc(this.TanzeemIndexRepo) : super(TanzeemIndexInitial()) {
    on<TanzeemIndexEvent>((event, emit) async {
      if (event is SendData) {
        emit(TanzeemIndexLoading());
        await Future.delayed(const Duration(seconds: 3), () async {
          data = await TanzeemIndexRepo.getList(event.file_Manual_No,event.hay_No,event.hawd_No,
              event.land_No,event.citizen_Name,event.order_No);
          emit(TanzeemIndexLoaded(data));
        });
      }
    });
  }
}