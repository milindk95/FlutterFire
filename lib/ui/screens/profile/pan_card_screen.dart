import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:the_super11/blocs/profile/verification/upload_pan_card/upload_pan_card_bloc.dart';
import 'package:the_super11/core/extensions.dart';
import 'package:the_super11/core/providers/user_info_provider.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class PanCardScreen extends StatefulWidget {
  static const route = '/pan-card-details';

  const PanCardScreen({Key? key}) : super(key: key);

  @override
  _PanCardScreenState createState() => _PanCardScreenState();
}

class _PanCardScreenState extends State<PanCardScreen> {
  late final User _user;
  late final bool _panCardStatusPending;
  final double _panCardHeight = 220;
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _panCardNameCtrl = TextEditingController(),
      _panCardNumberCtrl = TextEditingController();
  late final ImageUtils _imageUtils;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _user = context.read<UserInfo>().user;
    _panCardStatusPending = _user.panCardStatus.contains(panCardPending);
    _imageUtils = ImageUtils(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'PAN Card Details',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _panCardStatus(),
            if (_user.panCardStatus.isEmpty &&
                _user.panCard != null &&
                _user.panCard!.id.isNotEmpty)
              Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        icVerified,
                        width: 20,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          'Your PAN card is verified by TheSuper11',
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: _panCardHeight,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 12),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AppNetworkImage(
                            url: _user.panCard!.panCardImage,
                            errorIcon: imgPanCard,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _user.panCard!.panCardUsername,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _user.panCard!.panCardNumber,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            if (_user.panCardStatus.isEmpty &&
                (_user.panCard == null ||
                    (_user.panCard != null && _user.panCard!.id.isEmpty)))
              _panCardForm(),
          ],
        ),
      ),
    );
  }

  Widget _panCardStatus() {
    if (_user.panCardStatus.isNotEmpty) {
      return Row(
        children: [
          Image.asset(
            _panCardStatusPending ? icPending : icRejected,
            width: 40,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              _panCardStatusPending
                  ? 'Your PAN card is under review. We will verify it soon and you will get notified'
                  : 'Your PAN card get rejected due to verification failed',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }
    return SizedBox.shrink();
  }

  Widget _panCardImage() => InkWell(
        onTap: () async {
          final file = await _imageUtils.selectAndCropImage();
          if (file != null) setState(() => _imageFile = file);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _imageFile != null
                ? Image.file(
                    _imageFile!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 80,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text('Select your PAN card image here')
                    ],
                  ),
          ),
        ),
      );

  Widget _panCardForm() => Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              panCardAndBankVerificationNotes,
              style: TextStyle(fontSize: 15),
            ),
            Text(
              'You will get notified when your PAN card will approved.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              height: _panCardHeight,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Card(
                child: _panCardImage(),
              ),
            ),
            AppTextField(
              controller: _panCardNameCtrl,
              hintText: 'Name on PAN Card',
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              formatters: Formatters.acceptCharactersAndSpace,
              validator: (value) =>
                  value!.length < 3 ? 'Enter name as per PAN Card' : null,
            ),
            SizedBox(
              height: 12,
            ),
            AppTextField(
              controller: _panCardNumberCtrl,
              hintText: 'PAN Card Number',
              maxLength: 10,
              textCapitalization: TextCapitalization.characters,
              validator: (value) => !value!.isValidPANCardNumber
                  ? 'Enter valid PAN Card number'
                  : null,
            ),
            SizedBox(
              height: 20,
            ),
            BlocConsumer<UploadPanCardBloc, UploadPanCardState>(
              listener: (context, state) {
                if (state is UploadPanCardSuccess) {
                  showTopSnackBar(
                      context, CustomSnackBar.success(message: state.message));
                  Navigator.of(context).pop(true);
                } else if (state is UploadPanCardFailure)
                  showTopSnackBar(
                      context, CustomSnackBar.error(message: state.error));
              },
              builder: (context, state) {
                return SubmitButton(
                  label: 'Submit for Verification',
                  onPressed: _uploadPanCard,
                  progress: state is UploadPanCardInProgress,
                );
              },
            )
          ],
        ),
      );

  void _uploadPanCard() {
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        context.read<UploadPanCardBloc>().add(UploadPanCard(
            panCardImagePath: _imageFile!.path,
            panCardName: _panCardNameCtrl.text.trim(),
            panCardNumber: _panCardNumberCtrl.text));
      } else
        showTopSnackBar(
          context,
          CustomSnackBar.error(message: 'Select your PAN Card image'),
        );
    } else
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
  }

  @override
  void dispose() {
    _panCardNameCtrl.dispose();
    _panCardNumberCtrl.dispose();
    super.dispose();
  }
}
