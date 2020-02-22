import 'package:calendar_flutter_app/src/data/data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeEditingDialog extends StatefulWidget {
  final Date date;

  const HomeEditingDialog({Key key, this.date}) : super(key: key);

  @override
  _HomeEditingDialogState createState() => _HomeEditingDialogState();
}

class _HomeEditingDialogState extends State<HomeEditingDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Align(
        alignment: Alignment.center,
        child: Text('${widget.date.month}월 ${widget.date.day}일'),
      ),
      titlePadding: EdgeInsets.only(top: 10, bottom: 10),
      content: Container(
        width: 300,
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                widget.date.icon == null
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(stringIcon[widget.date.icon]),
                      ),
                Container(
                  width: 15,
                  height: 15,
                  decoration:
                      BoxDecoration(color: feelColors[widget.date.feeling]),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  widget.date.feeling.toString(),
                  style: GoogleFonts.montserrat(),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
            SizedBox(
              height: 15,
            ),
            Text(widget.date.message),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              var result = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  child: AlertDialog(
                    content: Text('작성한 내용이 사라집니다\n정말로 삭제 하시겠습니까?'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context, '취소');
                          },
                          child: Text('취소')),
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context, '삭제');
                          },
                          child: Text('삭제')),
                    ],
                  ));
              if (result == '삭제') {
                Navigator.pop(context, 'delete');
              }
            },
            child: Text('삭제')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context, 'edit');
            },
            child: Text('수정')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('취소')),
      ],
    );
  }
}
