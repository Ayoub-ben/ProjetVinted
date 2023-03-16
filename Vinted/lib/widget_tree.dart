import 'package:vinted/AchatPage.dart';
import 'package:vinted/auth.dart';
import 'package:vinted/login_register_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return AchatPage();
          }
          else{
            return const LoginPage();
          }
        },
    );
  }
}
