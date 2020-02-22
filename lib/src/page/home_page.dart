import 'package:calendar_flutter_app/src/bloc/back_up_bloc.dart';
import 'package:calendar_flutter_app/src/bloc/back_up_event.dart';
import 'package:calendar_flutter_app/src/bloc/back_up_state.dart';
import 'package:calendar_flutter_app/src/data/data.dart';
import 'package:calendar_flutter_app/src/data/firebase_provider.dart';
import 'package:calendar_flutter_app/src/data/sqflite_provider.dart';
import 'package:calendar_flutter_app/src/page/detail_page.dart';
import 'package:calendar_flutter_app/src/page/login_page.dart';
import 'package:calendar_flutter_app/src/widget/home_backup_dialog.dart';
import 'package:calendar_flutter_app/src/widget/home_date_column.dart';
import 'package:calendar_flutter_app/src/widget/home_dialog.dart';
import 'package:calendar_flutter_app/src/widget/home_editing_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseProvider fp;
  SqlfliteProvider sp;
  Database dateDB;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var today;
  var list = List<String>.generate(13, (i) {
    return i == 0 ? "" : i.toString();
  });

  @override
  void initState() {
    today = getDaysFromYear(DateTime.now().month, DateTime.now().day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sp = Provider.of<SqlfliteProvider>(context);
    fp = Provider.of<FirebaseProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<BackUpBloc, BackUpState>(
      listener: (context, state) {
        if (state is BackUpSaved) {
          _scaffoldKey.currentState
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('저장되었습니다.')));
        } else if (state is BackUpHeadLoaded) {
          showDialog(
            context: context,
            builder: (context) => HomeBackUpDialog(heads: state.backUpHeads),
            barrierDismissible: true,
          ).then((result) {
            if (result != null) {
              BlocProvider.of<BackUpBloc>(context)
                  .add(BackUpLoad(uId: fp.getUser().uid, head: result));
            }
          });
        } else if (state is BackUpLoaded) {
          print(state);
          sp.backUpDatabase(state.backUpDateList).then((_) {
            _scaffoldKey.currentState
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('백업되었습니다.')));
          });
        } else if (state is BackUpNetworkError) {
          _scaffoldKey.currentState
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('네트워크 에러')));
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 100,
                  child: Center(
                    child: Text(
                      'Calendar',
                      style: GoogleFonts.montserrat(
                          color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
                Positioned(
                    right: 15,
                    child: Container(
                      height: 100,
                      child: Center(
                        child: PopupMenuButton(
                            child: Icon(
                              Icons.menu,
                              color: Colors.black,
                            ),
                            onSelected: (value) {
                              if (value == '로그인') {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                              } else if (value == '로그아웃') {
                                fp.signOut();
                              } else if (value == '저장하기') {
                                if (fp.getUser() != null) {
                                  BlocProvider.of<BackUpBloc>(context).add(
                                      BackUpSave(
                                          uId: fp.getUser().uid,
                                          dateList: sp.getDateList()));
                                } else {
                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(content: Text('로그인이 필요합니다')));
                                }
                              } else {
                                if (fp.getUser() != null) {
                                  BlocProvider.of<BackUpBloc>(context).add(
                                      BackUpHeadLoad(uId: fp.getUser().uid));
                                } else {
                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(content: Text('로그인이 필요합니다')));
                                }
                              }
                            },
                            itemBuilder: (context) {
                              return [
                                fp.getUser() == null
                                    ? PopupMenuItem(
                                        value: '로그인', child: Text('로그인'))
                                    : PopupMenuItem(
                                        value: '로그아웃', child: Text('로그아웃')),
                                PopupMenuItem(
                                    value: '저장하기', child: Text('저장하기')),
                                PopupMenuItem(
                                    value: '불러오기', child: Text('불러오기')),
                              ];
                            }),
                      ),
                    ))
              ],
            ),
            Container(
              padding: EdgeInsets.only(right: 15),
              height: 30,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: list.map((i) {
                  return Flexible(
                      flex: 1,
                      child: Container(
                        child: Center(
                          child: Text(
                            i,
                            style: GoogleFonts.nanumGothic(
                                color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ));
                }).toList(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 15),
              width: screenWidth,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 13,
                  childAspectRatio: 1,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                ),
                itemBuilder: (context, index) {
                  return _buildGridViewItem(context, index);
                },
                itemCount: 403,
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridViewItem(BuildContext context, int index) {
    return Container(
      color: index % 13 == 0 ? Colors.white : Colors.lightGreenAccent,
      child: index % 13 == 0
          ? DateColumn(date: (index ~/ 13 + 1))
          : _buildDate(context, index % 13, index ~/ 13 + 1),
    );
  }

  Widget _buildDate(BuildContext context, int month, int day) {
    int index = getDaysFromYear(month, day);
    ColorSwatch color = Colors.grey;

    if (noneDay.contains('$month' + '$day')) {
      return Container(
        color: Colors.white,
      );
    }

    if (sp.getDate(index) != null) {
      color = feelColors[sp.getDate(index).feeling];
    }
    return InkWell(
      onTap: () {
        if (sp.getDate(index) == null) {
          showSettingDialog(context, Date(month: month, day: day));
        } else {
          showEditingDialog(context, sp.getDate(index));
        }
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) =>
//                    DetailPage(date: Date(month: month, day: day))));
      },
      child: Container(
        decoration: BoxDecoration(
            color: color,
            border: index == today
                ? Border.all(width: 2, color: Colors.black)
                : null),
      ),
    );
  }

  void showSettingDialog(BuildContext context, Date date) async {
    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => HomeDialog(date: date));

    if (result != null) {
      var saved = result;
      sp.insertDate(saved);
      sp.setDate(getDaysFromYear(saved.month, saved.day), saved);
      //print(saved.message);
      //setState(() {});
//      var list = await getDates();
//      print(list[list.length - 1]);
    }
  }

  void showEditingDialog(BuildContext context, Date date) async {
    var result = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => HomeEditingDialog(date: date),
    );

    if (result != null) {
      if (result == 'edit') {
        showSettingDialog(context, date);
      } else {
        int index = getDaysFromYear(date.month, date.day);
        sp.deleteDate(date);
        sp.setDate(index, null);
      }
    }
  }
}
