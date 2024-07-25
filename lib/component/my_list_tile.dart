import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
    required this.selected,
    this.children = const [],
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final bool selected;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
        color: selected ? Colors.blue : Colors.transparent,
      ),
      child: Column(
        children: [
          ListTile(
            onTap: press,
            horizontalTitleGap: 0.0,
            leading: SvgPicture.asset(
              svgSrc,
              colorFilter: ColorFilter.mode(
                  selected ? Colors.white : Colors.blue, BlendMode.srcIn),
              height: 16,
            ),
            title: Text(
              title,
              style: TextStyle(
                  color: selected ? Colors.white : Colors.grey,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          // if (selected) ...children,
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Column(
              children: selected ? children : [],
            ),
          ),
        ],
      ),
    );
  }
}