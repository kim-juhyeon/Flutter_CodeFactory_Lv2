import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroudColor;
  final Widget child;
  final String? title;
  final Widget? bottmNavigationBar;

  const DefaultLayout({required this.child,this.backgroudColor,this.title,this.bottmNavigationBar, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroudColor ?? Colors.white,
      appBar: renderAppbar(),
      body: child,
      bottomNavigationBar: bottmNavigationBar,
    );
  }
  AppBar? renderAppbar(){
    if(title == null){
      return null;
    }else{
      return AppBar(
        backgroundColor:Colors.white,
        elevation: 0,
        title: Text(
          title!,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        foregroundColor: Colors.black,
      );
    }

  }
}
