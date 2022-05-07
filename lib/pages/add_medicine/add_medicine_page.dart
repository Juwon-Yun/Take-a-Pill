import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_constants.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  final _nameController = TextEditingController();

  // 화면이 끝날때 꺼준다.
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: largeSpace,),
              Text(
                '어떤 약이에요?',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: largeSpace,),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  child: CupertinoButton(
                    onPressed: (){},
                    child: const Icon(
                      CupertinoIcons.photo_camera,
                      size: 30,
                      color: Colors.white,),
                  ),
                ),
              ),
              const SizedBox(
                height: largeSpace + regularSpace,
              ),
              Text(
                '약 이름',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextFormField(
                controller: _nameController,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: ElevatedButton(
          child: Text('다음'),
          style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.subtitle1),
          onPressed: (){},
        ),
      ),
    );
  }
}
