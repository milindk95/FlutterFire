import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/blocs/auth/sign_up_verification/sign_up_verification_bloc.dart';
import 'package:flutter_fire/core/extensions.dart';
import 'package:flutter_fire/core/providers/user_info_provider.dart';
import 'package:flutter_fire/ui/screens/home/home_screen.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class SignUpVerificationData {
  final String userId;
  final String mobileNoOrEmail;

  SignUpVerificationData({required this.userId, required this.mobileNoOrEmail});
}

class SignUpVerificationScreen extends StatefulWidget {
  static const route = '/sign-up-verification';
  final SignUpVerificationData data;

  const SignUpVerificationScreen({Key? key, required this.data})
      : super(key: key);

  @override
  _SignUpVerificationScreenState createState() =>
      _SignUpVerificationScreenState();
}

class _SignUpVerificationScreenState extends State<SignUpVerificationScreen> {
  final _otpCtrl = TextEditingController();

  void _backConfirmation() => context.showConfirmation(
        title: 'Confirmation',
        message: 'Are you sure to go to back?',
        positiveAction: () => Navigator.of(context).pop(),
      );

  @override
  Widget build(BuildContext context) {
    return UIBlocker(
      block: BlocProvider.of<SignUpVerificationBloc>(context).state
          is SignUpVerificationInProgress,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verify your account',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Enter the 6 digits OTP that you received on',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '"${widget.data.mobileNoOrEmail}"',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AppOTPTextField(
                        controller: _otpCtrl,
                        validValueCallback: () => setState(() {}),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (_otpCtrl.text.length == 6) _verifyButton()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _verifyButton() =>
      BlocConsumer<SignUpVerificationBloc, SignUpVerificationState>(
        listener: (context, state) {
          if (state is SignUpVerificationSuccess) {
            context.read<UserInfo>().setLoggedUserInfo(state.user);
            showTopSnackBar(
                context, CustomSnackBar.success(message: state.successMessage));
            Navigator.of(context)
                .pushNamedAndRemoveUntil(HomeScreen.route, (route) => false);
          } else if (state is SignUpVerificationFailure)
            showTopSnackBar(
                context, CustomSnackBar.error(message: state.error));
        },
        builder: (context, state) {
          return SubmitButton(
            label: 'Verify',
            onPressed: () => context
                .read<SignUpVerificationBloc>()
                .add(VerifyAccountByOTP(int.parse(_otpCtrl.text))),
            progress: state is SignUpVerificationInProgress,
          );
        },
      );
}
