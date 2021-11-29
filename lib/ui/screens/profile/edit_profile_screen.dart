import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_super11/blocs/profile/edit_profile/edit_profile_bloc.dart';
import 'package:the_super11/core/extensions.dart';
import 'package:the_super11/core/providers/user_info_provider.dart';
import 'package:the_super11/core/utility.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  static const route = '/edit-profile';

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _addressFocus = FocusNode(),
      _cityFocus = FocusNode(),
      _zipCodeFocus = FocusNode();
  final _teamNameCtrl = TextEditingController(),
      _emailCtrl = TextEditingController(),
      _mobileNoCtrl = TextEditingController(),
      _usernameCtrl = TextEditingController(),
      _dateOfBirthCtrl = TextEditingController(),
      _genderCtrl = TextEditingController(),
      _addressCtrl = TextEditingController(),
      _cityCtrl = TextEditingController(),
      _stateCtrl = TextEditingController(),
      _zipCodeCtrl = TextEditingController();
  final _maxDateTime = DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
  late DateTime _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    _selectedBirthDate = _maxDateTime;
    final user = context.read<UserInfo>().user;
    _teamNameCtrl.text = user.teamName;
    _emailCtrl.text = user.email;
    _mobileNoCtrl.text = user.mobile;
    _usernameCtrl.text = user.name;
    if (user.birthDate.isNotEmpty) {
      _selectedBirthDate = DateTime.parse(user.birthDate);
      _dateOfBirthCtrl.text = Utility.formatDate(dateTime: user.birthDate);
    }
    if (user.gender.isNotEmpty) {
      _genderCtrl.text = user.gender;
    }
    if (user.state.isNotEmpty) {
      _stateCtrl.text = user.state;
    }
    _addressCtrl.text = user.address;
    _cityCtrl.text = user.city;
    _stateCtrl.text = user.state;
    _zipCodeCtrl.text = user.zip;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileFailure)
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: state.error,
            ),
          );
        else if (state is EditProfileSuccess) {
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: state.message,
            ),
          );
          final user = User(
            name: _usernameCtrl.text,
            birthDate: _selectedBirthDate.toString(),
            gender: _genderCtrl.text,
            address: _addressCtrl.text.trim(),
            city: _cityCtrl.text.trim(),
            state: _stateCtrl.text,
            zip: _zipCodeCtrl.text,
          );
          context.read<UserInfo>().updateLoggedUserInfo(user);
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state is EditProfileInProgress,
          child: Scaffold(
            appBar: AppHeader(
              title: 'Edit your profile',
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _autoValidateMode,
                      child: Column(
                        children: [
                          _disabledFields(),
                          _updatableFields(),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!context.isKeyboardVisible)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        12, 12, 12, context.bottomPadding(12)),
                    child: SubmitButton(
                      label: 'Save',
                      progress: state is EditProfileInProgress,
                      onPressed: _editProfile,
                    ),
                  ),
                if (context.isKeyboardVisible && _zipCodeFocus.hasFocus)
                  NumberKeyboardAction(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _disabledFields() => Opacity(
        opacity: 0.58,
        child: Column(
          children: [
            AppTextField(
              controller: _teamNameCtrl,
              hintText: 'Team Name',
              enabled: false,
            ),
            SizedBox(
              height: 16,
            ),
            AppTextField(
              controller: _emailCtrl,
              hintText: 'Email Id',
              enabled: false,
            ),
            SizedBox(
              height: 16,
            ),
            AppTextField(
              controller: _mobileNoCtrl,
              hintText: 'Mobile Number',
              enabled: false,
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      );

  Widget _updatableFields() => Column(
        children: [
          AppTextField(
            controller: _usernameCtrl,
            hintText: 'Username',
            textInputAction: TextInputAction.next,
            maxLength: 10,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_addressFocus),
            validator: (value) => value!.length < 3
                ? 'Username required minimum 3 characters'
                : null,
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              context.showDatePicker(
                title: 'Date Of Birth',
                onDateTimeChanged: (dateTime) {
                  _selectedBirthDate = dateTime;
                  _dateOfBirthCtrl.text =
                      Utility.formatDate(dateTime: dateTime.toString());
                },
                initialDate: _selectedBirthDate,
                maximumDate: _maxDateTime,
              );
            },
            behavior: HitTestBehavior.opaque,
            child: AbsorbPointer(
              child: AppTextField(
                controller: _dateOfBirthCtrl,
                hintText: 'Date of Birth',
                textInputAction: TextInputAction.next,
                dropDown: true,
                validator: (value) =>
                    value!.isEmpty ? 'Select date of birth' : null,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () => context.showValuePicker<String>(
              title: 'Select Gender',
              items: genders,
              initialItem: genders.indexOf(_genderCtrl.text),
              onValueChanged: (value) {
                _genderCtrl.text = value;
              },
            ),
            behavior: HitTestBehavior.opaque,
            child: AbsorbPointer(
              child: AppTextField(
                controller: _genderCtrl,
                hintText: 'Gender',
                dropDown: true,
                textInputAction: TextInputAction.next,
                validator: (value) => value!.isEmpty ? 'Select gender' : null,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          AppTextField(
            controller: _addressCtrl,
            focusNode: _addressFocus,
            hintText: 'Address',
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            formatters: Formatters.acceptWithoutEmojis,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_cityFocus),
            validator: (value) => value!.isEmpty ? 'Enter your address' : null,
          ),
          SizedBox(
            height: 16,
          ),
          AppTextField(
            controller: _cityCtrl,
            focusNode: _cityFocus,
            hintText: 'City',
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            formatters: Formatters.acceptCharactersAndSpace,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_zipCodeFocus),
            validator: (value) => value!.length < 3
                ? 'City name required minimum 3 characters'
                : null,
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () => context.showValuePicker<String>(
              title: 'Select State',
              items: availableStates,
              initialItem: availableStates.indexOf(_stateCtrl.text),
              onValueChanged: (value) {
                _stateCtrl.text = value;
              },
            ),
            behavior: HitTestBehavior.opaque,
            child: AbsorbPointer(
              child: AppTextField(
                controller: _stateCtrl,
                hintText: 'State',
                dropDown: true,
                textInputAction: TextInputAction.next,
                validator: (value) => value!.isEmpty ? 'Select state' : null,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          AppTextField(
            controller: _zipCodeCtrl,
            focusNode: _zipCodeFocus,
            hintText: 'Zip Code',
            keyboardType: TextInputType.numberWithOptions(signed: false),
            maxLength: 6,
            formatters: Formatters.acceptNumbers,
            validator: (value) =>
                value!.length < 6 ? 'Zip code required minimum 6 digits' : null,
          ),
          SizedBox(
            height: 24,
          )
        ],
      );

  void _editProfile() {
    if (_formKey.currentState!.validate()) {
      final payLoad = {
        "name": _usernameCtrl.text.trim(),
        "gender": _genderCtrl.text,
        "address": _addressCtrl.text.trim(),
        "city": _cityCtrl.text.trim(),
        "state": _stateCtrl.text,
        "zip": _zipCodeCtrl.text,
        "birthDate": Utility.formatDate(
            dateTime: _selectedBirthDate.toString(), dateFormat: 'MM-dd-yyyy')
      };
      context.read<EditProfileBloc>().add(EditProfile(payLoad));
    } else
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
  }

  @override
  void dispose() {
    [_addressFocus, _cityFocus, _zipCodeFocus]
        .forEach((focus) => focus.dispose());
    [
      _teamNameCtrl,
      _emailCtrl,
      _mobileNoCtrl,
      _usernameCtrl,
      _dateOfBirthCtrl,
      _genderCtrl,
      _addressCtrl,
      _cityCtrl,
      _stateCtrl,
      _zipCodeCtrl
    ].forEach((ctrl) => ctrl.dispose());
    super.dispose();
  }
}
