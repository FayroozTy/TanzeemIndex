
import 'package:http/http.dart';


abstract class TanzeemIndexState {}

class TanzeemIndexInitial extends TanzeemIndexState {}

class TanzeemIndexLoading extends TanzeemIndexState {}

class TanzeemIndexLoaded extends TanzeemIndexState {

  final Response data;

  TanzeemIndexLoaded(this.data);
}

class TanzeemIndexError extends TanzeemIndexState {}