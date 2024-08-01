import 'package:flutter/material.dart';

import '../../constants.dart';

class CommonAppBar extends AppBar {
  CommonAppBar({Key? key, required bool automaticallyImplyLeading, BuildContext? context})
      : super(
      key: key,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: 0,
      centerTitle: false,
      title: const Text(
        "TripFlow",
        style: TextStyle(color: pointColor, fontWeight: FontWeight.bold),
      ),
      iconTheme: const IconThemeData(
        color: pointColor,
      ),
      leading: automaticallyImplyLeading == true
          ? IconButton(
        onPressed: () => Navigator.of(context!).pop(true),
        icon: const Icon(Icons.arrow_back_ios),
      ) : null
  );
}
