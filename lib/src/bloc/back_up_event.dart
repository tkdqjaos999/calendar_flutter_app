import 'package:calendar_flutter_app/src/data/data.dart';
import 'package:equatable/equatable.dart';

abstract class BackUpEvent extends Equatable {
  const BackUpEvent();
}

class BackUpSave extends BackUpEvent {
  final String uId;
  final List<Date> dateList;

  BackUpSave({this.uId, this.dateList});

  @override
  List<Object> get props => null;
}

class BackUpHeadLoad extends BackUpEvent {
  final String uId;

  BackUpHeadLoad({this.uId});

  @override
  List<Object> get props => null;
}

class BackUpLoad extends BackUpEvent {
  final String head;
  final String uId;

  BackUpLoad({this.uId, this.head});

  @override
  List<Object> get props => null;
}

class BackUpDelete extends BackUpEvent {
  final String head;
  final String uId;

  BackUpDelete({this.uId, this.head});

  @override
  List<Object> get props => null;
}