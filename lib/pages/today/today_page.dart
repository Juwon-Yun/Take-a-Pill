import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_constants.dart';

class TodayPage extends StatelessWidget {
  TodayPage({Key? key}) : super(key: key);

  final list = [
    '약 이름',
    '약 이름 테스트',
    '약 이름 테스트 약 이름 테스트',
    '약 이름 테스트 약 이름 테스트 약 이름 테스트',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      // default가 center임
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('오늘 복용할 약은?', style: Theme.of(context).textTheme.headline4,),
        const SizedBox(height:  regularSpace),
        Expanded(
          // child: ListView(
          //   children: const [
          //     MedicineListTile(name: '약'),
          //     MedicineListTile(name: '약 이름'),
          //     MedicineListTile(name: '약 이름 테스트'),
          //     MedicineListTile(name: '약 이름 테스트 약 이름 테스트'),
          //     MedicineListTile(name: '약 이름 테스트 약 이름 테스트 약 이름 테스트'),
          //     // ListTile은 커스텀이 복잡해 직접 그린다.
          //     // ListTile(),
          // ],
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: smallSpace),
            // scroll overflow 방지
            itemCount: list.length,
            itemBuilder: (context, idx){
              return MedicineListTile(name: list[idx]);
            },
            // 구분할 위젯을 반복할수 있다.
            separatorBuilder: (BuildContext context, int index) {
              // return const SizedBox(height: regularSpace);
              // 높이를 알아서 먹는다. 근데 20만큼 더 높여줌
              return const Divider(height: regularSpace);
            },
          ),
        ),
      ],
    );
  }
  
}

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(children: [
      CupertinoButton(padding: EdgeInsets.zero ,onPressed: (){},child: CircleAvatar(radius: 40,)),
      const SizedBox(width: smallSpace),
      // 스크롤 디테일
      const Divider(height: 1, thickness: 2.0),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🕑08:30', style: textStyle),
            const SizedBox(height: 6),
            Wrap(
              // wrap 전용 배치
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('$name,', style: textStyle,),
                TileActionButton(title: '지금', onTap: () {  },),
                Text('|',style: textStyle,),
                TileActionButton(title: '아까', onTap: () {  },),
                Text('먹었어요!', style: textStyle,),
              ]
            )
          ],
        )),
      CupertinoButton(onPressed: (){} ,child: const Icon(CupertinoIcons.ellipsis_vertical)),
    ],
    );
  }
}

class TileActionButton extends StatelessWidget {
  const TileActionButton({
    Key? key, required this.onTap, required this.title
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
  final textStyle = Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w500);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title, style: textStyle),
      ),
    );
  }
}

