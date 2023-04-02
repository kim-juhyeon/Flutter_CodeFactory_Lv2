import 'package:flutter/material.dart';

/* login_screen이 있음에도 common/layout 폴더를 만들어서 page를 만드는 이유는 스크린의 해당하는 위젯은
필요할 때 또 이용하기 위함에 있으며, 예방함에 있습니다.*/
class DefaultLayout extends StatelessWidget {
  // ? <- 넣은 이유 : 입력을 받지 않으면은 기본색깔 흰색이 적용하기 위해
  final Color? backgroudColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;

  const DefaultLayout({
    this.backgroudColor,
    required this.child,
    this.title,
    this.bottomNavigationBar,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroudColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

//appbar를 커스텀하기위해서 renderAppbar 클래스를 만들어줌, title이 null이면 아무것도 안 넣어 주기 때문에 AppBar?
//물음표를 넣어줌
  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          //text에는 null이 들어가면 안되니까 밑줄이 생기는데, ! = 널이 될 수 없다고 확인을 해줌
          title!,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
