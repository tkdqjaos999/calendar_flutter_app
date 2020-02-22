import 'package:calendar_flutter_app/src/data/data.dart';
import 'package:calendar_flutter_app/src/widget/home_icon_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDialog extends StatefulWidget {
  final Date date;

  const HomeDialog({Key key, this.date}) : super(key: key);

  @override
  _HomeDialogState createState() => _HomeDialogState();
}

class _HomeDialogState extends State<HomeDialog> {
  TextEditingController _textEditingController;
  var selectedFeeling;
  var selectedIcon;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _textEditingController.text = widget.date.message??'';
    selectedFeeling = widget.date.feeling??'very good';
    selectedIcon = widget.date.icon;
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 5, right: 15),
      title: Align(
          alignment: Alignment.topRight,
          child: Text(
            '${widget.date.month}월 ${widget.date.day}일',
            style: GoogleFonts.nanumGothic(fontSize: 14),
          )),
      content: Container(
        width: 350,
        height: 300,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 5),
              child: Text('색상을 선택하세요'),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: feeling.map((feeling) {
                return _buildColorTap(feeling);
              }).toList(),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 0.5, color: Colors.black)),
              child: TextField(
                maxLines: null,
                textInputAction: TextInputAction.newline,
                controller: _textEditingController,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.speaker_notes,
                      color: Colors.black,
                    ),
                    hintText: 'Add a note',
                    border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            //_buildIconBar(),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('취소'),
          onPressed: () async {
            var result = await showDialog(
                context: context,
                barrierDismissible: false,
                child: AlertDialog(
                  content: Text(
                    '정말로 취소 하시겠습니까?',
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context, '취소');
                        },
                        child: Text('취소')),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context, '뒤로가기');
                        },
                        child: Text('뒤로')),
                  ],
                ));
            if (result == '취소') {
              Navigator.pop(context);
            }
          },
        ),
        FlatButton(
          child: Text('저장'),
          onPressed: () {
            Navigator.pop(
                context,
                Date(
                    month: widget.date.month,
                    day: widget.date.day,
                    feeling: selectedFeeling,
                    message: _textEditingController.text,
                    icon: selectedIcon));
          },
        ),
      ],
    );
  }

  Widget _buildColorTap(String feeling) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedFeeling = feeling;
        });
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            color: feeling == selectedFeeling
                ? Colors.grey.withOpacity(0.5)
                : Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: feelColors[feeling]),
                ),
                Text(
                  '$feeling',
                  style: GoogleFonts.montserrat(),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          )
        ],
      ),
    );
  }

  Widget _buildIconBar() {
    return selectedIcon == null ? IconChoiceButton() : IconSeletedButtons();
  }

  Widget IconChoiceButton() {
    return InkWell(
      onTap: () {
        showIconDialog(context);
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          textBaseline: TextBaseline.ideographic,
          children: <Widget>[
            Icon(
              Icons.tag_faces,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '오늘을 아이콘으로 표현하세요',
              style: GoogleFonts.nanumGothic(fontSize: 13, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget IconSeletedButtons() {
    return Container(
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Row(
              children: <Widget>[
                Icon(
                  selectedIcon,
                  color: Colors.white,
                ),
                Text(
                  '선택된 아이콘',
                  style: GoogleFonts.nanumGothic(color: Colors.white),
                )
              ],
            ),
            color: Colors.green,
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                selectedIcon = null;
              });
            },
            child: Text(
              '아이콘 선택 취소',
              style: GoogleFonts.nanumGothic(color: Colors.white),
            ),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  void showIconDialog(BuildContext context) async {
    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => HomeIconDialog());

    if (result != null) {
      setState(() {
        selectedIcon = result;
        print(selectedIcon);
      });
    }
  }
}
