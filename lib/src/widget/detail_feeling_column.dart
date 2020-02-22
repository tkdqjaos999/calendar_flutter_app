import 'package:calendar_flutter_app/src/data/data.dart';
import 'package:flutter/material.dart';

class FeelingColumn extends StatefulWidget {
  String feeling;

  FeelingColumn({Key key, this.feeling}) : super(key: key);

  @override
  _FeelingColumnState createState() => _FeelingColumnState();
}

class _FeelingColumnState extends State<FeelingColumn> {
  bool isSelect = false;
  bool animating = true;
  var selectedFeeling;
  var tabHeight = 50.0;
  List<String> unselectedFeeling;

  @override
  void initState() {
    selectedFeeling = widget.feeling??'very good';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 15),
      child: AnimatedContainer(
        onEnd: () {
          setState(() {
            animating = true;
          });
        },
        height: tabHeight,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 205),
        child: Column(
          children: <Widget>[
            _buildFeelingTab(),
            isSelect?_buildFeelingSelectTab():Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeelingTab() {
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
                color: widget.feeling == null
                    ? Colors.redAccent
                    : feelColors[selectedFeeling],
              ),
              SizedBox(width: 20,),
              Text(
                selectedFeeling,
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          InkWell(
            onTap: () async {
              if(animating){
                animating = false;
                await animateSync();
              }
            },
            child: Container(
              width: 30,
              height: 30,
              child: Center(
                  child: isSelect ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
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
            if(animating){
              setState(() {
                selectedFeeling = feeling;
              });
              await animateSync();
            }
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

  Future<void> animateSync() async {
    if(isSelect) {
      setState(() {
        isSelect = false;
      });
      await Future.delayed(Duration(milliseconds: 120));
      setState(() {
        tabHeight = 50.0;
      });
    } else {
      setState(() {
        tabHeight = 200.0;
      });
      await Future.delayed(Duration(milliseconds: 220));
      setState(() {
        unselectedFeeling = List.from(feeling);
        unselectedFeeling.remove(selectedFeeling);
        isSelect = true;
      });
    }
  }
}
