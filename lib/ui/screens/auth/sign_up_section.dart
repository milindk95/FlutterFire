part of 'login_sign_up_screen.dart';

class SignUpSection extends StatefulWidget {
  final BuildContext screenContext;

  const SignUpSection({Key? key, required this.screenContext})
      : super(key: key);

  @override
  _SignUpSectionState createState() => _SignUpSectionState();
}

class _SignUpSectionState extends State<SignUpSection> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _emailCtrl = TextEditingController(),
      _mobileCtrl = TextEditingController(),
      _teamNameCtrl = TextEditingController(),
      _passwordCtrl = TextEditingController(),
      _confirmPasswordCtrl = TextEditingController(),
      _referralCodeCtrl = TextEditingController();
  final _mobileFocus = FocusNode();
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return UIBlocker(
      block: BlocProvider.of<SignUpBloc>(context, listen: true).state
          is SignUpInProgress,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign up your account',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text('Enter your information below'),
                  SizedBox(
                    height: 30,
                  ),
                  _signupForm(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: _termsAndPrivacy(),
                  )
                ],
              ),
            ),
          ),
          if (!widget.screenContext.isKeyboardVisible)
            BlocConsumer<SignUpBloc, SignUpState>(
              listener: (context, state) {
                if (state is SignUpFailure)
                  showTopSnackBar(
                      context, CustomSnackBar.error(message: state.error));
                else if (state is SignUpSuccess)
                  Navigator.of(context).pushNamed(
                    SignUpVerificationScreen.route,
                    arguments: SignUpVerificationData(
                      userId: state.user.id,
                      mobileNoOrEmail: _mobileCtrl.text,
                    ),
                  );
              },
              builder: (context, state) {
                return AuthButton(
                  progress:
                      context.read<SignUpBloc>().state is SignUpInProgress,
                  onPressed: _signup,
                );
              },
            ),
          if (widget.screenContext.isKeyboardVisible && _mobileFocus.hasFocus)
            NumberKeyboardAction(
              action: () => FocusScope.of(context).nextFocus(),
            ),
        ],
      ),
    );
  }

  Widget _signupForm() => Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: Column(
          children: [
            AppTextField(
              controller: _emailCtrl,
              hintText: 'Email Id',
              textInputAction: TextInputAction.next,
              formatters: Formatters.acceptEmailFormat,
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  value!.isValidEmail ? null : 'Enter valid email address',
            ),
            SizedBox(
              height: 20,
            ),
            AppTextField(
              controller: _mobileCtrl,
              focusNode: _mobileFocus,
              hintText: 'Mobile Number',
              textInputAction: TextInputAction.next,
              maxLength: 10,
              keyboardType: TextInputType.numberWithOptions(signed: false),
              formatters: Formatters.acceptNumbers,
              validator: (value) =>
                  value!.length < 10 ? 'Enter valid mobile number' : null,
            ),
            SizedBox(
              height: 20,
            ),
            AppTextField(
              controller: _teamNameCtrl,
              hintText: 'Team Name',
              textInputAction: TextInputAction.next,
              maxLength: 30,
              validator: (value) => value!.length < 4
                  ? 'Team name required at least 4 characters'
                  : null,
            ),
            SizedBox(
              height: 20,
            ),
            AppTextField(
              controller: _passwordCtrl,
              hintText: 'Password',
              obscureText: true,
              textInputAction: TextInputAction.next,
              formatters: Formatters.acceptWithoutEmojis,
              validator: (value) =>
                  value!.isValidPassword ? null : passwordError,
            ),
            SizedBox(
              height: 20,
            ),
            AppTextField(
              controller: _confirmPasswordCtrl,
              hintText: 'Confirm Password',
              obscureText: true,
              textInputAction: TextInputAction.next,
              formatters: Formatters.acceptWithoutEmojis,
              validator: (value) {
                if (value!.isEmpty)
                  return 'Enter confirm password';
                else if (value != _passwordCtrl.text)
                  return 'Password does not match';
              },
            ),
            SizedBox(
              height: 20,
            ),
            AppTextField(
              controller: _referralCodeCtrl,
              hintText: 'Referral code (Optional)',
            ),
          ],
        ),
      );

  Widget _termsAndPrivacy() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _agreed = !_agreed),
            child: Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _agreed
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                border: Border.all(
                  color: _agreed ? Theme.of(context).primaryColor : Colors.grey,
                  width: 2,
                ),
              ),
              child: _agreed
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 0,
              runSpacing: 0,
              children: [
                Text('I agree to the'),
                LinkButton(
                  onPressed: () => Utility.launchUrl(termsAndConditionsUrl),
                  label: 'Terms of service',
                ),
                Text('and'),
                LinkButton(
                  onPressed: () => Utility.launchUrl(privacyPolicyUrl),
                  label: 'Privacy policy',
                ),
              ],
            ),
          )
        ],
      );

  void _signup() {
    if (_formKey.currentState!.validate()) {
      if (_agreed) {
        context.read<SignUpBloc>().add(SignUp({
              'email': _emailCtrl.text,
              'mobile': _mobileCtrl.text,
              'teamName': _teamNameCtrl.text,
              'password': _passwordCtrl.text,
              "referralUserCode": _referralCodeCtrl.text,
            }));
      } else
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: 'You are not agreed to Terms of service & Privacy policy',
          ),
        );
    } else
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
  }
}

class LinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const LinkButton({Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
