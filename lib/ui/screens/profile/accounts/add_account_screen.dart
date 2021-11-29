import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_super11/blocs/profile/accounts/add_account/add_account_bloc.dart';
import 'package:the_super11/core/extensions.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class AddAccountScreen extends StatefulWidget {
  static const route = '/add-account';

  const AddAccountScreen({Key? key}) : super(key: key);

  @override
  _AddAccountScreenState createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  int _selectedIndex = 0;
  final _bankFormKey = GlobalKey<FormState>(),
      _upiFormKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _bankNameCtrl = TextEditingController(),
      _accountNumberCtrl = TextEditingController(),
      _confirmAccountNumberCtrl = TextEditingController(),
      _ifscCtrl = TextEditingController(),
      _holderNameCtrl = TextEditingController(),
      _mobileCtrl = TextEditingController(),
      _upiCtrl = TextEditingController(),
      _confirmUpiCtrl = TextEditingController();
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return UIBlocker(
      block: BlocProvider.of<AddAccountBloc>(context, listen: true).state
          is AddAccountInProgress,
      child: Scaffold(
        appBar: AppHeader(
          title: 'Add Bank/UPI Account',
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: _notes(),
              ),
              SlidingControl(
                labels: ['Bank Account', 'UPI Address'],
                onIndexChanged: (i) => setState(() => _selectedIndex = i),
              ),
              Text(
                'Add your ${_selectedIndex == 0 ? 'bank account' : 'UPI address'} details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 20,
                ),
                child: _selectedIndex == 0 ? _bankForm() : _upiForm(),
              ),
              BlocConsumer<AddAccountBloc, AddAccountState>(
                listener: (context, state) {
                  if (state is AddAccountFailure)
                    showTopSnackBar(
                        context, CustomSnackBar.error(message: state.error));
                  else if (state is AddAccountSuccess) {
                    showTopSnackBar(context,
                        CustomSnackBar.success(message: state.message));
                    Navigator.of(context).pop(true);
                  }
                },
                builder: (context, state) {
                  return SubmitButton(
                    label: 'Submit for Verification',
                    progress: state is AddAccountInProgress,
                    onPressed: _submitForVerification,
                  );
                },
              ),
              SizedBox(
                height: context.bottomPadding(8),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitForVerification() {
    if (_selectedIndex == 0) {
      if (_bankFormKey.currentState!.validate()) {
        if (_imageFile != null) {
          context.read<AddAccountBloc>().add(AddBankAccount(
                photoFilePath: _imageFile!.path,
                fields: {
                  'documentType': 'passbook',
                  'bankName': _bankNameCtrl.text.trim(),
                  'accountNumber': _accountNumberCtrl.text,
                  'ifscCode': _ifscCtrl.text,
                  'holderName': _holderNameCtrl.text.trim()
                },
              ));
        } else
          showTopSnackBar(
            context,
            CustomSnackBar.error(message: 'Select your Bank Passbook image'),
          );
      } else
        setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
    } else {
      if (_upiFormKey.currentState!.validate()) {
        context.read<AddAccountBloc>().add(AddUPIAccount({
              'documentType': 'upi',
              'upiMobileNumber': _mobileCtrl.text,
              'upiId': _upiCtrl.text
            }));
      } else
        setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
    }
  }

  Widget _notes() {
    Widget note(String note) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '*',
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                note,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryVariant,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            note('Please fill the required information correctly.'),
            note("You can't update the details after submit for verification."),
            note('We are not responsible if you give wrong information.'),
          ],
        ),
      ),
    );
  }

  Widget _bankForm() => Form(
        key: _bankFormKey,
        autovalidateMode: _autoValidateMode,
        child: Column(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 4),
              child: Card(
                child: _passbookImage(),
              ),
            ),
            AppTextField(
              controller: _bankNameCtrl,
              hintText: 'Bank Name',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              formatters: Formatters.acceptCharactersAndSpace,
              validator: (value) => value!.length < 3
                  ? 'Bank name should contains at least 3 characters'
                  : null,
            ),
            SizedBox(
              height: 12,
            ),
            AppTextField(
              controller: _accountNumberCtrl,
              hintText: 'Bank Account Number',
              maxLength: 18,
              formatters: Formatters.acceptNumbers,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.numberWithOptions(signed: false),
              validator: (value) => !value!.isValidBankAccountNumber
                  ? 'Enter valid bank account number'
                  : null,
            ),
            SizedBox(
              height: 12,
            ),
            AppTextField(
              controller: _confirmAccountNumberCtrl,
              hintText: 'Confirm Bank Account Number',
              textInputAction: TextInputAction.next,
              maxLength: 18,
              formatters: Formatters.acceptNumbers,
              keyboardType: TextInputType.numberWithOptions(signed: false),
              validator: (value) {
                if (value!.isEmpty)
                  return 'Enter confirm bank account number';
                else if (value != _accountNumberCtrl.text)
                  return "Account number and confirm account number doesn't match";
                return null;
              },
            ),
            SizedBox(
              height: 12,
            ),
            AppTextField(
              controller: _ifscCtrl,
              hintText: 'IFSC Code',
              maxLength: 11,
              textInputAction: TextInputAction.next,
              validator: (value) =>
                  !value!.isValidIFSC ? 'Enter valid IFSC Code' : null,
            ),
            SizedBox(
              height: 12,
            ),
            AppTextField(
              controller: _holderNameCtrl,
              hintText: 'Account Holder Name',
              keyboardType: TextInputType.name,
              formatters: Formatters.acceptCharactersAndSpace,
              validator: (value) => value!.length < 3
                  ? 'Name should contains at least 3 characters'
                  : null,
            )
          ],
        ),
      );

  Widget _passbookImage() => InkWell(
        onTap: () async {
          final file = await ImageUtils(context).selectAndCropImage();
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
                      Text('Select your Bank Passbook image here')
                    ],
                  ),
          ),
        ),
      );

  Widget _upiForm() => Form(
        key: _upiFormKey,
        autovalidateMode: _autoValidateMode,
        child: Column(
          children: [
            AppTextField(
              controller: _mobileCtrl,
              hintText: 'Mobile Number',
              textInputAction: TextInputAction.next,
              maxLength: 10,
              keyboardType: TextInputType.numberWithOptions(signed: false),
              formatters: Formatters.acceptNumbers,
              validator: (value) =>
                  value!.length < 10 ? 'Enter valid mobile number' : null,
            ),
            SizedBox(
              height: 12,
            ),
            AppTextField(
              controller: _upiCtrl,
              hintText: 'UPI Address',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              formatters: Formatters.acceptUPIFormat,
              validator: (value) =>
                  !value!.isValidUPIAddress ? 'Enter valid UPI Address' : null,
            ),
            SizedBox(
              height: 12,
            ),
            AppTextField(
              controller: _confirmUpiCtrl,
              hintText: 'Confirm UPI Address',
              keyboardType: TextInputType.emailAddress,
              formatters: Formatters.acceptUPIFormat,
              validator: (value) {
                if (value!.isEmpty)
                  return 'Enter confirm UPI Address';
                else if (value != _upiCtrl.text)
                  return "UPI and confirm UPI doesn't match";
                return null;
              },
            ),
          ],
        ),
      );
}
