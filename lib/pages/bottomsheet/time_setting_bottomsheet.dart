import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_colors.dart';
import 'package:intl/intl.dart';

import '../../components/custom_constants.dart';
import '../../components/custom_widget.dart';

class TimeSettingBottomSheet extends StatelessWidget {
  const TimeSettingBottomSheet({
    Key? key,
    required this.initialDateTime,
  }) : super(key: key);

  final String initialDateTime;


  @override
  Widget build(BuildContext context) {
    final initDateTime = DateFormat('HH:mm').parse(initialDateTime);
    // state를 다룰 필요가 없으므로 지역변수화 함, 따라서 접근제한자 풀음
    DateTime setDateTime = initDateTime;

    return BottomSheetBody(children: [
      SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            onDateTimeChanged: (dateTime){
              setDateTime = dateTime;
            },
            mode: CupertinoDatePickerMode.time,
            initialDateTime: initDateTime,)
      ),
      const SizedBox(width: regularSpace),
      Row(
        children: [
          Expanded(
            child: SizedBox(
              height: submitButtonHeight,
              child: ElevatedButton(
                onPressed: ()=> Navigator.pop(context),
                child: const Text('취소'),
                style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.subtitle1,
                    primary: Colors.white,
                    onPrimary: CustomColors.primaryColor),
              ),
            ),
          ),
          // 간격 벌리기
          const SizedBox(width: smallSpace),
          Expanded(
            child: SizedBox(
              height: submitButtonHeight,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pop(context, setDateTime);
                },
                child: const Text('선택'),
                style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.subtitle1),
              ),
            ),
          ),

        ],
      )
    ]);
  }
}