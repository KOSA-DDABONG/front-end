import 'package:flutter/material.dart';

class DrawerSubListTile extends StatelessWidget {
  const DrawerSubListTile({
    Key? key,
    required this.title,
    required this.selected,
    required this.press,
  }) : super(key: key);

  final String title;
  final bool selected;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 32.0), // add indent
      child: ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14, // make text smaller
            color: selected ? Colors.blue : Colors.grey,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
