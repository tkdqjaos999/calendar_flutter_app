import 'package:calendar_flutter_app/src/data/data.dart';
import 'package:calendar_flutter_app/src/data/sqflite_provider.dart';
import 'package:calendar_flutter_app/src/widget/detail_feeling_column.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  Date date;

  DetailPage({Key key, this.date}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with WidgetsBindingObserver{
  SharedPreferences prefs;
  SqlfliteProvider sp;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textEditingController;
  var isWriting = false;
  var message;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
    openShared();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if(state == AppLifecycleState.paused) {
      prefs.setString('msg', _textEditingController.text??'');
    } else if(state == AppLifecycleState.resumed) {
      _textEditingController.text = prefs.getString('msg')??'';
    }
    super.didChangeAppLifecycleState(state);
  }

  Future openShared() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    sp = Provider.of<SqlfliteProvider>(context);

    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
          //physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 100,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        InkWell(
                          onTap: () async {
                            var result = await showDialog(
                                context: context,
                              barrierDismissible: true,
                              child: AlertDialog(
                                content: Text('저장하시겠습니까?'),
                                actions: <Widget>[
                                  FlatButton(onPressed: (){Navigator.pop(context);}, child: Text('취소')),
                                  FlatButton(onPressed: (){Navigator.pop(context, '저장');}, child: Text('저장')),
                                ],
                              ),
                            );
                            if(result == '저장') {
                              widget.date = Date(
                                  month: widget.date.month,
                                  day: widget.date.day,
                                  feeling: sp.getFeeling(),
                                  message: _textEditingController.text,);
                              sp.insertDate(widget.date);
                              sp.setDate(getDaysFromYear(widget.date.month, widget.date.day), widget.date);
                              setState(() {
                                isWriting = false;
                              });
                            }
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 3,
                                            blurRadius: 3),
                                      ],
                                      image: DecorationImage(
                                          image: AssetImage('assets/save1.png'),
                                          fit: BoxFit.none),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, left: 30),
              child: Text(
                '${widget.date.month}월 ${widget.date.day}일',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            FeelingColumn(),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
            Padding(padding: EdgeInsets.all(30),
              child: _buildTextBox(_screenHeight - 310),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextBox(double height) {
    if(!isWriting){
      return InkWell(
        onTap: (){
          setState(() {
            isWriting = true;
            _textEditingController.text = widget.date.message??'';
          });
        },
        onLongPress: (){/*복사 삭제 기능 추가*/},
        child: Container(
          height: height,
          child: ListView(
              padding: EdgeInsets.all(15),
              children: [
                Text(widget.date.message??'',
                  style: TextStyle(fontSize: 18),
                ),
              ]
          ),
        ),
      );
    } else {
      return Container(
        height: height,
        child: ListView(
            padding: EdgeInsets.all(15),
            children: [
              TextField(

                scrollPhysics: NeverScrollableScrollPhysics(),
                controller: _textEditingController,
                maxLines: null,
                autofocus: true,
                textInputAction: TextInputAction.newline,
                cursorColor: Colors.grey,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ]
        ),
      );
    }
  }
}
