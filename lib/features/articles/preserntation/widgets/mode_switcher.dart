import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';

class ModeSwitcher extends StatefulWidget {
  const ModeSwitcher({Key? key}) : super(key: key);

  @override
  State<ModeSwitcher> createState() => _ModeSwitcherState();
}

class _ModeSwitcherState extends State<ModeSwitcher> {
  bool? darkTheme;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      darkTheme = DynamicTheme.of(context)!.themeId == 0 ? false : true;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
        value: darkTheme ?? false,
        onChanged: (bool value) {
          darkTheme = value;

          if (darkTheme!) {
            DynamicTheme.of(context)!.setTheme(1);
          } else {
            DynamicTheme.of(context)!.setTheme(0);
          }

          setState(() {});
        });
  }
}
