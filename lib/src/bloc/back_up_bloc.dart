import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:calendar_flutter_app/src/data/date_repository.dart';
import './bloc.dart';

class BackUpBloc extends Bloc<BackUpEvent, BackUpState> {
  final DataRepository dateRepository;

  BackUpBloc(this.dateRepository);

  @override
  BackUpState get initialState => InitialBackUpState();

  @override
  Stream<BackUpState> mapEventToState(
    BackUpEvent event,
  ) async* {
    print(event);
    if(event is BackUpSave){
      yield BackUpLoading();
      try {
        await dateRepository.saveBackUpData(event.uId, event.dateList);
        yield BackUpSaved();
      } on Exception catch(e) {
        yield BackUpNetworkError();
      }
    } else if (event is BackUpHeadLoad){
      yield BackUpLoading();
      try {
        var heads = await dateRepository.loadBackUpHeadData(event.uId);
        yield BackUpHeadLoaded(backUpHeads: heads);
      } on Exception catch(e) {
        yield BackUpNetworkError();
      }
    } else if (event is BackUpLoad) {
      yield BackUpLoading();
      try {
        var dateList = await dateRepository.loadBackUpData(event.uId, event.head);
        yield BackUpLoaded(backUpDateList: dateList);
      } on Exception catch(e) {
        yield BackUpNetworkError();
      }
    } else if (event is BackUpDelete) {
      yield BackUpLoading();
      try {
        var deletedHead = await dateRepository.deleteBackUpDate(event.uId, event.head);
        yield BackUpHeadDeleted(head: deletedHead);
      } on Exception catch(e) {
        yield BackUpNetworkError();
      }
    }
  }
}
