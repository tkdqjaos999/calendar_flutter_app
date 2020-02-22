import 'package:calendar_flutter_app/src/bloc/back_up_bloc.dart';
import 'package:calendar_flutter_app/src/bloc/back_up_event.dart';
import 'package:calendar_flutter_app/src/bloc/back_up_state.dart';
import 'package:calendar_flutter_app/src/data/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeBackUpDialog extends StatefulWidget {
  final List<String> heads;

  const HomeBackUpDialog({Key key, this.heads}) : super(key: key);

  @override
  _HomeBackUpDialogState createState() => _HomeBackUpDialogState();
}

class _HomeBackUpDialogState extends State<HomeBackUpDialog> {
  FirebaseProvider fp;
  var selectedHead;

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    return BlocListener<BackUpBloc, BackUpState>(
      listener: (context, state) {
        if(state is BackUpHeadDeleted) {
          widget.heads.removeWhere((head)=> head==state.head);
          selectedHead = null;
          setState(() {});
        }
      },
      child: AlertDialog(
        title: Text('백업 데이터'),
        content: Container(
          width: 350,
          height: 300,
          child: ListView(
            children: widget.heads.map((head) {
              return _buildHeadItem(head);
            }).toList(),
          ),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소')),
          FlatButton(
            onPressed: () {
              if(selectedHead != null) {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      content: Text('정말로 삭제하시겠습니까?'),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('취소')),
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context, '삭제');
                            },
                            child: Text('삭제')),
                      ],
                    ),
                    barrierDismissible: false).then((result){
                      if(result == '삭제'){
                        BlocProvider.of<BackUpBloc>(context)
                            .add(BackUpDelete(uId: fp
                            .getUser()
                            .uid, head: selectedHead));
                      }
                });
              }
            },
            child: Text('삭제'),
          ),
          FlatButton(
              onPressed: () async {
                var result = await showDialog(
                    context: context,
                    child: AlertDialog(
                      content: Text('백업하시면 기존에 저장된 데이터가 사라집니다\n정말로 백업하시겠습니까?'),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('취소')),
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context, '백업');
                            },
                            child: Text('백업')),
                      ],
                    ),
                    barrierDismissible: false);
                if (result == '백업') {
                  Navigator.pop(context, selectedHead);
                }
              },
              child: Text('선택')),
        ],
      ),
    );
  }

  Widget _buildHeadItem(String head) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedHead = head;
        });
      },
      child: Container(
        height: 40,
        color:
            selectedHead == head ? Colors.grey.withOpacity(0.6) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(head),
          ),
        ),
      ),
    );
  }
}
