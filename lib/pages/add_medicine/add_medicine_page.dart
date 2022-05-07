import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_constants.dart';
import 'package:image_picker/image_picker.dart';

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
        // 키보드가 올라왔을 때 공간이 모자라면 overflow가 나타난다
        // 그래서 scroll 가능한 위젯으로 만든다.
        child: SingleChildScrollView(
          child: Padding(
            padding: pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: largeSpace,),
                Text(
                  '어떤 약이에요?',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: largeSpace,),
                const Center(
                  child: MedicineImageButton(),
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
                  maxLength: 20,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: '복용될 약 이름을 기입해주세요.',
                    hintStyle: Theme.of(context).textTheme.bodyText2,
                    contentPadding: textFieldContentPadding,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: submitButtonBoxPadding,
          child: SizedBox(
            height: submitButtonHeight,
            child: ElevatedButton(
              child: Text('다음'),
              style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.subtitle1),
              onPressed: (){},
            ),
          ),
        ),
      ),
    );
  }
}

class MedicineImageButton extends StatefulWidget {
  const MedicineImageButton({Key? key}) : super(key: key);

  @override
  State<MedicineImageButton> createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<MedicineImageButton> {
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 40,
        child: CupertinoButton(
        // 이미지가 없을떄 paading null, 있을 때 zero
        padding: _pickedImage == null ? null : EdgeInsets.zero,
        onPressed: _showBottomSheet,
          child: _pickedImage == null ? const Icon(
          CupertinoIcons.photo_camera,
          size: 30,
          color: Colors.white,)
              : CircleAvatar(
          foregroundImage: FileImage(_pickedImage!),
          radius: 40,
          ),
        ),
      );
  }

  void _showBottomSheet(){
    showModalBottomSheet(context: context, builder: (context){
      return PickImageBottomSheet(
        onPressedCamera: () => _onPressed(ImageSource.camera),
        onPressedGallery: () => _onPressed(ImageSource.gallery),
      );
    });
  }


  void _onPressed(ImageSource source){
    ImagePicker().pickImage(source: source).then((value){
      if(value != null){
        setState(() {
          _pickedImage = File(value.path);
        });
      }
      Navigator.maybePop(context);
    });
  }
}

class PickImageBottomSheet extends StatelessWidget {
  const PickImageBottomSheet({Key? key, required this.onPressedCamera, required this.onPressedGallery}) : super(key: key);

  final VoidCallback onPressedCamera;
  final VoidCallback onPressedGallery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagePadding,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: onPressedCamera,
                child: const Text('카메라로 촬영')),
            TextButton(
                onPressed: onPressedGallery,
                child: const Text('앨범에서 가져오기')),
          ],
        ),
      ),
    );
  }
}

