import 'package:flutter/material.dart';

class CustomItemWidget extends StatelessWidget {
  final String startText;
  final String endText;
  const CustomItemWidget({Key? key, required this.startText, required this.endText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$startText',
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 15 / 13.4,
                ),
              ),
              Text(
                '$endText',
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 14 / 12,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Divider(
            height: 1,
            color: Color.fromRGBO(171, 116, 64, 0.9),
          ),
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
