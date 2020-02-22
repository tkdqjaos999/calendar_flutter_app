import 'package:calendar_flutter_app/src/data/data.dart';
import 'package:calendar_flutter_app/src/widget/detail_feeling_column.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  Date date;

  DetailPage({Key key, this.date}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
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
                        onTap: () {},
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
          FeelingColumn(
            feeling: widget.date.feeling,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Container(
              height: 0.5,
              color: Colors.grey,
            ),
          ),
          Padding(padding: EdgeInsets.all(30),
            child: Container(
              height: _screenHeight - 285,
              child: ListView(
                padding: EdgeInsets.all(15),
                children: <Widget>[
                  Text('message'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
