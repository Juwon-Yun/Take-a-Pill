import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_constants.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // default가 center임
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('오늘 복용할 약은?', style: Theme.of(context).textTheme.headline4,),
        const SizedBox(height:  regularSpace),
        Expanded(child: ListView(
          children: [
            MedicineListTile(name: "ds",),
            // ListTile은 커스텀이 복잡해 직접 그린다.
            // ListTile(),

          ],
        )),
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

    return Container(
      color: Colors.yellow,
      child: Row(children: [
        CupertinoButton(padding: EdgeInsets.zero ,onPressed: (){},child: CircleAvatar(radius: 40,)),
        const SizedBox(width: smallSpace),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🕑08:30', style: textStyle),
              Row(children: [
                Text('$name,', style: textStyle,),
                TileActionButton(title: '지금', onTap: () {  },),
                Text('|',style: textStyle,),
                TileActionButton(title: '아까', onTap: () {  },),
                Text('먹었어요!', style: textStyle,),

              ],)
            ],
          )),
        CupertinoButton(onPressed: (){} ,child: const Icon(CupertinoIcons.ellipsis_vertical)),
      ],
      ),
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

