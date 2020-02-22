import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'data.dart';

abstract class DataRepository {
  List<Date> dateList;

  Future saveBackUpData(String uId, List<Date> dateList);

  Future<List<String>> loadBackUpHeadData(String uId);

  Future<List<Date>> loadBackUpData(String uId, String head);

  Future<String> deleteBackUpDate(String uId, String head);
}

class DateRepository implements DataRepository {
  @override
  List<Date> dateList;

  @override
  Future saveBackUpData(String uId, List<Date> dateList) async {
    List<Date> saveList = List<Date>();
    for(var date in dateList) {
      if(date != null) {
        saveList.add(date);
      }
    }

    var now = DateTime.now();
    var doc = Firestore.instance
        .collection('users')
        .document(uId)
        .collection('backUpData')
        .document();
    await doc.setData({
      'date': DateFormat('yyyy:MM:dd:hh:mm:ss').format(now),
      'data': jsonEncode(saveList)
    });
  }

  @override
  Future<List<String>> loadBackUpHeadData(String uId) async {
    var backUpDatas = await Firestore.instance
        .collection('users')
        .document(uId)
        .collection('backUpData')
        .orderBy('date', descending: true)
        .getDocuments();

    var backUpHeads = List<String>();
    for (var data in backUpDatas.documents) {
      backUpHeads.add(data.data['date']);
    }

    return backUpHeads;
  }

  @override
  Future<List<Date>> loadBackUpData(String uId, String head) async {
    var backUpData = await Firestore.instance
        .collection('users')
        .document(uId)
        .collection('backUpData')
        .where('date', isEqualTo: head).getDocuments();

    List<Date> loadList = List<Date>();
    for(var date in jsonDecode(backUpData.documents[0]['data'])) {
      loadList.add(Date.fromJson(date));
    }
    return loadList;
  }

  @override
  Future<String> deleteBackUpDate(String uId, String head) async {
    var backUpData = await Firestore.instance.collection('users')
        .document(uId)
        .collection('backUpData')
        .where('date', isEqualTo: head).getDocuments();
    await Firestore.instance.collection('users')
        .document(uId)
        .collection('backUpData')
        .document(backUpData.documents[0].documentID)
        .delete();

    return head;
  }
}
