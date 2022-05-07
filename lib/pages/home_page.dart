import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage  extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIdx = 0;
  final _pages = [
    Container(color: Colors.grey,),
    Container(color: Colors.blue,),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        // 탑의 safeArea 설정은 false
        top: false,
        child: Scaffold(
          appBar: AppBar(),
          body: _pages[_currentIdx],
          floatingActionButton: FloatingActionButton(
            onPressed: (){},
            child: const Icon(CupertinoIcons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            // 그림자 없애기
            elevation: 0,
            child: Container(
              // meterial에서 권장하는 높이로 설정
              height: kBottomNavigationBarHeight,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CupertinoButton(
                      child: const Icon(CupertinoIcons.check_mark),
                      onPressed: (){
                        setState(() {
                          _currentIdx = 0;
                        });
                      }),
                  CupertinoButton(
                      child: const Icon(CupertinoIcons.check_mark_circled_solid),
                      onPressed: (){
                        setState(() {
                          _currentIdx = 1;
                        });
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
