import 'package:flutter/material.dart';
import 'package:lv2_codefactory/common/const/colors.dart';
import 'package:lv2_codefactory/common/layout/default_layout.dart';
import 'package:lv2_codefactory/restaurant/view/restaurant_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

/* controller을 이용하여 탭을 이동시 화면이 전환되어야 할 때 with singleTickerprovider를
활용한다. */
class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;
  //RootTab 을 stateful 위젯으로 변경하고, index = 0 지정해줘서 초기화면이 출력되게 한다.
  int index = 0;
  @override
  void initState() {
    super.initState();

    controller = TabController(length: 4, vsync: this);

    controller.addListener(tabListner);
  }

  @override
  void dispose() {
    controller.removeListener(tabListner);
    super.dispose();
  }

  /*addListener로 컨트롤러 추가를 해주고, 어떤 걸 추가할지는 void로 따로 빼준다.
   컨트롤러 4개의 리스트를 index를 해주고 이를 idex와 같다는 setstate를 만들어 준다.*/
  void tabListner() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코팩 딜리버리',
      bottomNavigationBar: BottomNavigationBar(
        //선택된 네비게이션바 색상
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.shifting,
        //bottomNavigationBar 안에 ontap을 지정해주고 눌르때마다 변경할 수 있게 setstate 그리고 그안에 index
        //불러와 변경할 수 있게 진행한다. -> setstate -> controller.animateTo(index)를 이용하여 controller,index를 결합함
        onTap: (int index) {
          controller.animateTo(index);
        },
        //위에서 지정해준 index를 초기화해줘서 초기화면이 home이 나오게 한다.
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_outlined), label: '음식'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: '주문'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_outlined), label: '프로필'),
        ],
      ),
      child: TabBarView(
        //scroll 되지 않게 physics 적용
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          RestaurnatScreen(),
          Center(child: Container(child: Text('음식'))),
          Center(child: Container(child: Text('주문'))),
          Center(child: Container(child: Text('프로필'))),
        ],
      ),
    );
  }
}
