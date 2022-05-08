import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_constants.dart';
import 'package:flutter_app/components/custom_page_route.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/medicine.dart';
import 'package:flutter_app/pages/add_medicine/add_alarm_page.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/custom_widget.dart';
import '../bottomsheet/pick_image_bottomsheet.dart';
import 'components/add_page_widget.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key, this.updateMedicineId = -1}) : super(key: key);

  final int updateMedicineId;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  late TextEditingController _nameController;
  File? _medicineImage;
  
  get _isUpdate => widget.updateMedicineId != -1;
  
  Medicine get _updateMedicine => medicineRepository.medicineBox.values
      .singleWhere((element) => element.id == widget.updateMedicineId);

  @override
  void initState(){
    super.initState();

    if(_isUpdate){
      _nameController = TextEditingController(text: _updateMedicine.name);
      if(_updateMedicine.imagePath != null){
        _medicineImage = File(_updateMedicine.imagePath!);
      }
    }else{
      _nameController = TextEditingController();
    }

  }

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
                    child: _MedicineImageButton(
                      updateImage: _medicineImage,
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
              updatedMedicineId: widget.updateMedicineId,
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



class _MedicineImageButton extends StatefulWidget {
  const _MedicineImageButton({Key? key,
    required this.changeImageFile,
    this.updateImage}) : super(key: key);

  // valueChange로 emitt 기능 구현하기
  final ValueChanged<File?> changeImageFile;
  final File? updateImage;


  @override
  State<_MedicineImageButton> createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<_MedicineImageButton> {
  File? _pickedImage;

  @override
  void initState(){
    super.initState();
    _pickedImage = widget.updateImage;
  }

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
    })
    .onError((error, stackTrace){
      Navigator.pop(context);
      // 설정 off 일 경우 error 처리
      showPermissionDenied(context, permission: '카메라 및 갤러리 접근');
    });
  }
}


