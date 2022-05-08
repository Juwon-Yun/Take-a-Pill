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
    this.submitTitle = '선택',
    this.bottomWidget,
  }) : super(key: key);

  final String initialDateTime;
  final String submitTitle;
  final Widget? bottomWidget;


  @override
  Widget build(BuildContext context) {
    final initDateTimeData = DateFormat('HH:mm').parse(initialDateTime);
    final now = DateTime.now();
    final updateDate = DateTime(now.year, now.month, now.day, initDateTimeData.hour, initDateTimeData.minute);

    // state를 다룰 필요가 없으므로 지역변수화 함, 따라서 접근제한자 풀음
    DateTime setDateTime = updateDate;

    return BottomSheetBody(children: [
      SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            onDateTimeChanged: (dateTime){
              setDateTime = dateTime;
            },
            mode: CupertinoDatePickerMode.time,
            initialDateTime: updateDate,)
      ),
      const SizedBox(width: smallSpace),
      if(bottomWidget != null) bottomWidget!,
      if(bottomWidget != null)const SizedBox(width: smallSpace),
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
                child: Text(submitTitle),
                style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.subtitle1),
              ),
            ),
          ),

        ],
      )
    ]);
  }
}