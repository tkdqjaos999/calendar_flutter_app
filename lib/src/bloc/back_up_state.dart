import 'package:calendar_flutter_app/src/data/data.dart';
import 'package:equatable/equatable.dart';

abstract class BackUpState extends Equatable {
  const BackUpState();
}

class InitialBackUpState extends BackUpState {
  @override
  List<Object> get props => [];
}

class BackUpLoading extends BackUpState {


  @override
  List<Object> get props => [];
}

class BackUpSaved extends BackUpState {


  @override
  List<Object> get props => [];
}

class BackUpHeadLoaded extends BackUpState {
  final List<String> backUpHeads;

  BackUpHeadLoaded({this.backUpHeads});

  @override
  List<Object> get props => [];
}

class BackUpLoaded extends BackUpState {
  final List<Date> backUpDateList;

  BackUpLoaded({this.backUpDateList});

  @override
  List<Object> get props => [];

}

class BackUpHeadDeleted extends BackUpState {
  final String head;

  BackUpHeadDeleted({this.head});

  @override
  List<Object> get props => null;

}

class BackUpNetworkError extends BackUpState {

  @override
  List<Object> get props => null;
}