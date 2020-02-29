import 'package:calendar_flutter_app/src/data/data.dart';
import 'package:calendar_flutter_app/src/data/sqflite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeelingColumn extends StatefulWidget {
  @override
  _FeelingColumnState createState() => _FeelingColumnState();
}

class _FeelingColumnState extends State<FeelingColumn> {
  SqlfliteProvider sp;
  bool isSelect = false;
  bool animating = true;
  var tabHeight = 50.0;
  List<String> unselectedFeeling;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sp = Provider.of<SqlfliteProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 15),
      child: Column(
        children: <Widget>[
          _buildFeelingDefaultTab(),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            switchOutCurve: Curves.easeIn,
            switchInCurve: Curves.easeOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SizeTransition(sizeFactor: animation, child: child,);
            },
            child: !isSelect ? Container() : _buildFeelingSelectTab(),)
        ],
      ),
    );
  }

  Widget _buildFeelingDefaultTab() {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 20,
                width: 20,
                color: feelColors[sp.getFeeling()],
              ),
              SizedBox(width: 20,),
              Text(
                sp.getFeeling(),
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          InkWell(
            onTap: () {
              animateSync();
            },
            child: Container(
              width: 30,
              height: 30,
              child: Center(
                child: isSelect ? Icon(Icons.keyboard_arrow_up) : Icon(
                    Icons.keyboard_arrow_down),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeelingSelectTab() {
    return Column(
      children: unselectedFeeling.map((feeling) {
        return InkWell(
          onTap: () async {
            sp.setFeeling(feeling);
            animateSync();
          },
          child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 20,
                  width: 20,
                  color: feelColors[feeling],
                ),
                SizedBox(width: 20,),
                Text(
                  feeling,
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void animateSync() {
    if(isSelect) {
      setState(() {
        isSelect = false;
      });
    } else {
      setState(() {
        unselectedFeeling = List.from(feeling);
        unselectedFeeling.remove(sp.getFeeling());
        isSelect = true;
      });
    }
  }
}
