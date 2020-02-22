import 'package:flutter/material.dart';

class Date {
  final month, day;
  final String feeling;
  final String message;
  final String icon;

  Date({this.month, this.day, this.feeling, this.message, this.icon});

  @override
  String toString() {
    return 'Date{month: $month, date: $day, feeling: $feeling, message: $message}';
  }

  factory Date.fromJson(Map<String, dynamic> json) =>
      Date(
        month: json['month'],
        day: json['day'],
        feeling: json['feeling'],
        message: json['message'],
        icon: json['icon']
      );


  Map<String, dynamic> toJson() => {
    'id': '2020-$month-$day',
    'month': month,
    'day': day,
    'feeling': feeling.toString(),
    'message': message,
    'icon': icon,
  };
}

enum Feeling { veryGood, good, regular, bad, veryBad }
const List<String> feeling = ['very good', 'good', 'regular', 'bad', 'very bad'];
const Map<String, ColorSwatch<int>> feelColors = {
  'very good': Colors.purpleAccent,
  'good': Colors.lightBlueAccent,
  'regular': Colors.greenAccent,
  'bad': Colors.yellowAccent,
  'very bad': Colors.redAccent
};

const monthDay2020 = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
const noneDay = ['230', '231', '431', '631', '931', '1131'];

const iconList = [
  Icons.favorite,
  Icons.cake,
  Icons.directions_run,
  Icons.play_circle_outline,
  Icons.directions_subway,
  Icons.shopping_cart,
  Icons.local_taxi,
  Icons.pets,
  Icons.mail_outline,
  Icons.local_hospital,
];

const Map<String, IconData> stringIcon = {
  'IconData(U+0E87D)' : Icons.favorite,
  'IconData(U+0E7E9)': Icons.cake,
  'IconData(U+0E566)': Icons.directions_run,
  'IconData(U+0E039)': Icons.play_circle_outline,
  'IconData(U+0E533)': Icons.directions_subway,
  'IconData(U+0E8CC)': Icons.shopping_cart,
  'IconData(U+0E559)': Icons.local_taxi,
  'IconData(U+0E91D)': Icons.pets,
  'IconData(U+0E0E1)': Icons.mail_outline,
  'IconData(U+0E548)': Icons.local_hospital,
};

//List<Date> dateList = List<Date>(372);

int getDaysFromYear(int month, int date) {
  int days = 0;
  for (int i = 1; i < month; i++) {
    days += monthDay2020[i - 1];
  }
  days += date;

  return days - 1;
}