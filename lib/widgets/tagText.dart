import 'package:flutter/material.dart';

class TagText extends StatelessWidget {
  final String tag;

  const TagText({Key key, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 6,
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            4,
          ),
        ),
        color: Colors.grey,
      ),
      child: Text(
        tag ?? '',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
