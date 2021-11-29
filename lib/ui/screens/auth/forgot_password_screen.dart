import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_super11/blocs/auth/forgot_password/forgot_password_bloc.dart';
import 'package:the_super11/core/extensions.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

import 'otp_screen.dart';

class ForgotPasswordScreenData {
  final String mobileNoOrEmail;

  ForgotPasswordScreenData(this.mobileNoOrEmail);
}

class ForgotPasswordScreen extends StatefulWidget {
  static const route = '/forgot-password';
  final ForgotPasswordScreenData data;

  const ForgotPasswordScreen({Key? key, required this.data}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _mobileNoOrEmailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mobileNoOrEmailCtrl.text = widget.data.mobileNoOrEmail;
  }

  @override
  Widget build(BuildContext context) {
    return UIBlocker(
      block: false,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                splashRadius: 22,
                icon: Icon(
                  Icons.arrow_back,
                  size: 24,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Enter the mobile number / email associated with your account and we'll send an 6 digits OTP to reset your password.",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: _formKey,
                      autovalidateMode: _autoValidateMode,
                      child: AppTextField(
                        controller: _mobileNoOrEmailCtrl,
                        hintText: 'Mobile / Email',
                        formatters: Formatters.acceptEmailFormat,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value!.isValidEmail || value.isValidMobileNo
                                ? null
                                : 'Enter valid mobile number / email id',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _sendOTPButton()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sendOTPButton() =>
      BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordFailure)
            showTopSnackBar(
              context,
              CustomSnackBar.error(message: state.error),
            );
          else if (state is ForgotPasswordSuccess)
            Navigator.of(context).pushNamed(
              OTPScreen.route,
              arguments: OTPScreenData(
                mobileNoOrEmail: _mobileNoOrEmailCtrl.text,
                userId: state.userId,
                forgotPasswordId: state.forgotPasswordId,
              ),
            );
        },
        builder: (context, state) {
          return SubmitButton(
            label: 'Send OTP',
            onPressed: _verify,
            progress: state is ForgotPasswordInProgress,
          );
        },
      );

  void _verify() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordBloc>().add(
            _mobileNoOrEmailCtrl.text.isValidEmail
                ? ForgotPasswordByEmail(_mobileNoOrEmailCtrl.text)
                : ForgotPasswordByMobileNo(_mobileNoOrEmailCtrl.text),
          );
    } else
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
  }

  @override
  void dispose() {
    _mobileNoOrEmailCtrl.dispose();
    super.dispose();
  }
}
