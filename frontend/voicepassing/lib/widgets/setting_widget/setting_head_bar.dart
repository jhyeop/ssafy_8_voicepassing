import 'package:flutter/material.dart';

class SettingHeadBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  final AppBar appBar;
  final Widget? navPage;

  const SettingHeadBar(
      {super.key, required this.title, required this.appBar, this.navPage});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'headBar',
      child: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white.withOpacity(1),
        foregroundColor: Colors.black,
        title: title,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
