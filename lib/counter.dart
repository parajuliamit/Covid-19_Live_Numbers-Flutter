import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final String number;
  final String title;
  final Color color;

  Counter({this.number, this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(6),
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(.26),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            number,
            style: TextStyle(
              fontSize: 30,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
