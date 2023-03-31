/* 로그인 페이지에 textfild를 이용할려고 한다. id,password 작성하는 공간은 textfild를 이용하는데 app개발 하면서 자주 이용할 수 있기 때문에
 common 폴더 - component - custom_text_form_field 에 따로 작성한다.*/

import 'package:flutter/material.dart';
import 'package:lv2_codefactory/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  //textfild 별로 따로 받아야 하기 때문에 파라미터화 해줍니다. 혹시나 아무것도 안 넣을 수 있기때문에 String? , requrired도 취소합니다.
  // errorText , obscureText, outofocus 의 경우 외부에서 추가적으로 받아오는 경우에는 파라미터로(final)로 정의한다.
  final errorText;
  final bool obscureText;
  final bool outofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    required this.onChanged,
    this.outofocus = false,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //UnderlineInputBorder - textfield 의 decoration 의 기본으로 들어가 있는 것 (파란색 밑줄)
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      //비밀번호 입력할 때 obscureText
      obscureText: obscureText,
      //화면에 오는 순간 자동으로 포커스를 맞춰주는 위젯
      autofocus: outofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),
        //fillColor : decoration input 위치에 있는 박스를 채우는 함수
        fillColor: INPUT_BG_COLOR,
        filled: true,
        //border는 모든 input상태의 스타일 세팅
        border: baseBorder,
        //InputDecorator 가 활성화되고 오류를 표시하지 않을 때 표시할 테두리입니다 .
        enabledBorder: baseBorder,

        /*focuseBorder의 경우에는 decoration을 눌렀을때 해당하는 위젯이다. copyWith을 이용하여 borderside를 가져와서 필요한 부분만 수정할 수 있다.
          수정 : baseBorder 를 가져오고 하위 부분인 borderSide 색상만 바꿔야 하기 때문에 baseBorder.borderSide를 한번 더 넣어줬다.*/
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }
}
