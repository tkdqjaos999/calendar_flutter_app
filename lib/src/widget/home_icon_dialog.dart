import 'package:calendar_flutter_app/src/data/data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeIconDialog extends StatefulWidget {
  @override
  _HomeIconDialogState createState() => _HomeIconDialogState();
}

class _HomeIconDialogState extends State<HomeIconDialog> {
  var selected;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 5),
      title: Align(
        alignment: Alignment.center,
        child: Text('오늘을 아이콘으로 표현하세요'),
      ),
      content: Container(
        width: 350,
        height: 300,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 15,
            childAspectRatio: 1,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (context, index) {
            return _buildIconItem(index);
          },
          itemCount: iconList.length,
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
              if (selected != null) {
                Navigator.pop(context, selected);
              }
            },
            child: Text('선택')),
      ],
    );
  }

  Widget _buildIconItem(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selected = iconList[index];
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: iconList[index] == selected
              ? Colors.green
              : Colors.green.withOpacity(0.5),
        ),
        child: Center(
          child: Icon(
            iconList[index],
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
