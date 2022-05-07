import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_constants.dart';
import 'package:flutter_app/components/custom_page_route.dart';
import 'package:flutter_app/pages/add_medicine/add_alarm_page.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/custom_widget.dart';
import 'components/add_page_widget.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  final _nameController = TextEditingController();
  File? _medicineImage;

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
      body: SingleChildScrollView(
        child: AddPageBody(children: [
                  // const SizedBox(height: largeSpace,),
                  Text(
                    '어떤 약이에요?',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(height: largeSpace,),
                   Center(
                    child: MedicineImageButton(
                      changeImageFile: (File? value){
                        _medicineImage = value;
                      },
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
                    maxLength: 20,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                      hintText: '복용될 약 이름을 기입해주세요.',
                      hintStyle: Theme.of(context).textTheme.bodyText2,
                      contentPadding: textFieldContentPadding,
                    ),
                    // 입력창 변할 때
                    onChanged: (_){
                      setState(() {
                          // onChanged, setState 빈칸 만으로 _nameController.text값이 렌더링된다.
                      });
                    },
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomSubmitButton(onPressed: _nameController.text.isEmpty ? null : _onAddAlarmPage, text: '다음',)
    );
  }
  void _onAddAlarmPage(){
    Navigator.push(
        context,
        // fade animation 적용하기
        FadePageRoute(
            page: AddAlarmPage(
              medicineImage: _medicineImage,
              medicineName: _nameController.text,
            )
        )

      // MaterialPageRoute(
      // builder: (context) => AddAlarmPage(
      //   medicineImage: _medicineImage,
      //   medicineName: _nameController.text),
      // )
    );
  }
}



class MedicineImageButton extends StatefulWidget {
  const MedicineImageButton({Key? key, required this.changeImageFile}) : super(key: key);

  // valueChange로 emitt 기능 구현하기
  final ValueChanged<File?> changeImageFile;

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
          widget.changeImageFile(_pickedImage);
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
    return BottomSheetBody(
            children: [
              TextButton(
                  onPressed: onPressedCamera,
                  child: const Text('카메라로 촬영')),
              TextButton(
                  onPressed: onPressedGallery,
                  child: const Text('앨범에서 가져오기')),
            ],
    );
  }
}

