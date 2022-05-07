import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_colors.dart';
import 'package:flutter_app/pages/add_medicine/add_medicine_page.dart';
import 'package:flutter_app/pages/history/history_page.dart';
import 'package:flutter_app/pages/today/today_page.dart';

class HomePage  extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIdx = 0;
  final _pages = [
    const TodayPage(),
    const HistoryPage(),
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
            onPressed: _onAddMedicine,
            child: const Icon(CupertinoIcons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _buildBottomAppBar(),
        ),
      ),
    );
  }

  BottomAppBar _buildBottomAppBar(){
    return BottomAppBar(
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
              child: Icon(
                CupertinoIcons.check_mark,
                color : _currentIdx == 0 ? CustomColors.primaryColor : Colors.grey[350],
              ),
              onPressed: ()=> _onCurrentPage(0),
            ),
            CupertinoButton(
              child: Icon(
                CupertinoIcons.check_mark_circled_solid,
                color : _currentIdx == 1 ? CustomColors.primaryColor : Colors.grey[350],
              ),
              onPressed: ()=> _onCurrentPage(1),
            ),
          ],
        ),
      ),
    );
  }

void _onCurrentPage(int pageIdx){
    setState(() {
      _currentIdx = pageIdx;
    });
}

void _onAddMedicine(){
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context)=> const AddPage())
  );
}

}
