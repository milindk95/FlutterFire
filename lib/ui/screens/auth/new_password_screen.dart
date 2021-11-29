import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_super11/blocs/auth/set_new_password/set_new_password_bloc.dart';
import 'package:the_super11/core/extensions.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/auth/login_sign_up_screen.dart';
import 'package:the_super11/ui/widgets/app_text_field.dart';
import 'package:the_super11/ui/widgets/submit_button.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

import 'otp_screen.dart';

class NewPasswordScreenData {
  final OTPScreenData otpScreenData;
  final int otp;

  NewPasswordScreenData(this.otpScreenData, this.otp);
}

class NewPasswordScreen extends StatefulWidget {
  static const route = '/new-password';
  final NewPasswordScreenData data;

  const NewPasswordScreen({Key? key, required this.data}) : super(key: key);

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _passwordCtrl = TextEditingController(),
      _confirmPasswordCtrl = TextEditingController();

  void _backConfirmation() => context.showConfirmation(
        title: 'Confirmation',
        message: 'Are you sure to go to back?',
        positiveAction: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      );

  @override
  Widget build(BuildContext context) {
    return UIBlocker(
      block: BlocProvider.of<SetNewPasswordBloc>(context).state
          is SetNewPasswordInProgress,
      onBack: _backConfirmation,
      child: Scaffold(
        body: SingleChildScrollView(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: _backConfirmation,
                splashRadius: 22,
                icon: Icon(
                  Icons.arrow_back,
                  size: 24,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set new password',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: Image.asset(
                            icLock,
                            width: 100,
                          ),
                        ),
                      ),
                      AppTextField(
                        controller: _passwordCtrl,
                        hintText: 'New Password',
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        formatters: Formatters.acceptWithoutEmojis,
                        validator: (value) =>
                            value!.isValidPassword ? null : passwordError,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      AppTextField(
                        controller: _confirmPasswordCtrl,
                        hintText: 'Confirm Password',
                        obscureText: true,
                        formatters: Formatters.acceptWithoutEmojis,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Enter confirm password';
                          else if (value != _passwordCtrl.text)
                            return 'Password does not match';
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _submitButton()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton() =>
      BlocConsumer<SetNewPasswordBloc, SetNewPasswordState>(
        listener: (context, state) {
          if (state is SetNewPasswordFailure)
            showTopSnackBar(
                context, CustomSnackBar.error(message: state.error));
          else if (state is SetNewPasswordSuccess) {
            showTopSnackBar(
                context, CustomSnackBar.success(message: state.message));
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginSignUpScreen.route, (route) => false);
          }
        },
        builder: (context, state) {
          return SubmitButton(
            label: 'Submit',
            onPressed: _setNewPassword,
            progress: state is SetNewPasswordInProgress,
          );
        },
      );

  void _setNewPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<SetNewPasswordBloc>().add(SetNewPassword({
            'forgotReqId': widget.data.otpScreenData.forgotPasswordId,
            'user': widget.data.otpScreenData.userId,
            'otp': widget.data.otp,
            'password': _passwordCtrl.text
          }));
    } else
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
  }

  @override
  void dispose() {
    super.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
  }
}
