import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:the_super11/blocs/profile/upload_photo/upload_photo_bloc.dart';
import 'package:the_super11/blocs/profile/user_profile/user_profile_bloc.dart';
import 'package:the_super11/core/extensions.dart';
import 'package:the_super11/core/preferences.dart';
import 'package:the_super11/core/providers/user_info_provider.dart';
import 'package:the_super11/core/utility.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/profile/accounts/all_accounts_screen.dart';
import 'package:the_super11/ui/screens/profile/edit_profile_screen.dart';
import 'package:the_super11/ui/screens/profile/email_verification_screen.dart';
import 'package:the_super11/ui/screens/profile/pan_card_screen.dart';
import 'package:the_super11/ui/widgets/app_header.dart';
import 'package:the_super11/ui/widgets/snackbar/top_snack_bar.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class UserProfileScreen extends StatefulWidget {
  static const route = '/user-profile';

  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _verificationIcons = [
    Icons.phone_iphone,
    Icons.mail,
    Icons.credit_card,
    Icons.account_balance,
  ];

  final _verificationLabels = [
    'Mobile',
    'Email',
    'Pan Card',
    'Bank',
  ];

  final _playingExperienceIcons = [
    icContestsWin,
    icTotalContests,
    icMatches,
    icSeries,
  ];

  final _playingExperienceLabels = [
    'Contests Win',
    'Total Contests',
    'Matches',
    'Series',
  ];

  final _personalInfoIcons = [
    Icons.person,
    Icons.sports_cricket,
    Icons.email,
    Icons.call,
    Icons.male,
    Icons.date_range,
    Icons.place,
  ];

  final _personalInfoLabels = [
    'Username',
    'Team Name',
    'Email Id',
    'Mobile Number',
    'Gender',
    'Date Of Birth',
    'Address',
  ];
  late final ImageUtils _imageUtils;

  @override
  void initState() {
    _imageUtils = ImageUtils(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UIBlocker(
      block: BlocProvider.of<UploadPhotoBloc>(context, listen: true).state
          is UploadPhotoProcessing,
      child: Scaffold(
        appBar: AppHeader(
          title: 'My Profile',
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(EditProfileScreen.route),
                icon: Icon(Icons.edit),
                splashRadius: 22,
              ),
            )
          ],
        ),
        body: BlocConsumer<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileFetchingSuccess) {
              context.read<UserInfo>().setLoggedUserInfo(state.user);
            }
          },
          builder: (context, state) {
            if (state is UserProfileFetchingSuccess)
              return Consumer<UserInfo>(
                builder: (context, state, child) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        _userProfileImage(state.user),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 4),
                          child: Text(
                            state.user.teamName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          state.user.email,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        _verifiedData(state.user),
                        Divider(),
                        SizedBox(
                          height: 12,
                        ),
                        _header('Playing Experience'),
                        _playingExperience(state.user),
                        Divider(),
                        _header('Personal info'),
                        _personalInfo(state.user),
                        SizedBox(
                          height: 24,
                        )
                      ],
                    ),
                  );
                },
              );
            else if (state is UserProfileFetching)
              return LoadingIndicator();
            else if (state is UserProfileFetchingFailure)
              return ErrorView(error: state.error);
            return Container();
          },
        ),
      ),
    );
  }

  Widget _header(String label) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget _userProfileImage(User user) => Center(
        child: BlocListener<UploadPhotoBloc, UploadPhotoState>(
          listener: (context, state) {
            if (state is UploadPhotoFailure)
              showTopSnackBar(
                  context, CustomSnackBar.error(message: state.error));
            else if (state is UploadPhotoSuccess) {
              showTopSnackBar(
                  context, CustomSnackBar.success(message: state.message));
              context
                  .read<UserInfo>()
                  .updateLoggedUserInfo(User(avatar: state.avatar));
              Preference.setUserAvatar(state.avatar);
            }
          },
          child: Container(
            height: 94,
            width: 94,
            child:
                context.read<UploadPhotoBloc>().state is UploadPhotoProcessing
                    ? LoadingIndicator()
                    : Stack(
                        children: [
                          GestureDetector(
                            onTap: _uploadImage,
                            child: ClipOval(
                              child: AppNetworkImage(
                                url: user.avatar,
                                width: 84,
                                height: 84,
                                errorIcon: imgProfilePlaceholder,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: MaterialButton(
                              onPressed: _uploadImage,
                              minWidth: 0,
                              padding: const EdgeInsets.all(6),
                              color: Theme.of(context).primaryColor,
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.white,
                              ),
                              shape: CircleBorder(),
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      );

  void _uploadImage() async {
    final file = await _imageUtils.selectAndCropImage();
    if (file != null)
      context.read<UploadPhotoBloc>().add(UploadProfilePhoto(file.path));
  }

  Widget _verifiedData(User user) {
    final List<bool> verifiedFlags = [
      user.validMobile,
      user.validEmail,
      user.panCard != null,
      user.payFundAccounts.isNotEmpty,
    ];
    final List<bool> pendingFlags = [
      false,
      !user.validEmail,
      user.panCardStatus.isNotEmpty,
      false,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          _verificationIcons.length,
          (i) => Column(
            children: [
              Stack(
                children: [
                  MaterialButton(
                    onPressed: () => _verifiedDataOnTaps(i, user),
                    color: Theme.of(context).primaryColor,
                    shape: CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    minWidth: 0,
                    child: Icon(
                      _verificationIcons[i],
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  if (verifiedFlags[i])
                    Positioned(
                      right: 0,
                      child: Image.asset(
                        icVerified,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  if (pendingFlags[i])
                    Positioned(
                      right: 0,
                      child: Image.asset(
                        icPending,
                        width: 20,
                        height: 20,
                      ),
                    )
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Text(_verificationLabels[i])
            ],
          ),
        ),
      ),
    );
  }

  void _verifiedDataOnTaps(int i, User user) async {
    switch (i) {
      case 0:
        if (user.validMobile)
          context.showAlert(
            title: 'Mobile Verified',
            message:
                'Your mobile number "${user.mobile}" is verified by TheSuper11',
          );
        break;
      case 1:
        if (user.validEmail)
          context.showAlert(
            title: 'Email Verified',
            message: 'Your email "${user.email}" is verified by TheSuper11',
          );
        else
          context.showConfirmation(
            title: 'Email Verification',
            message: getConfirmation('email', user.email),
            positiveText: 'Verify',
            positiveAction: () =>
                Navigator.of(context).pushNamed(EmailVerificationScreen.route),
          );
        break;
      case 2:
        final update =
            await Navigator.of(context).pushNamed(PanCardScreen.route);
        if (update == true)
          context.read<UserProfileBloc>().add(GetUserProfile());
        break;
      case 3:
        Navigator.of(context).pushNamed(AllAccountsScreen.route);
        break;
    }
  }

  Widget _playingExperience(User user) {
    final List<int?> counts = [
      user.totalContestWin,
      user.totalContestParticipant,
      user.totalMatches,
      user.totalSeries,
    ];
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2 / 0.8,
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: List.generate(
        _playingExperienceLabels.length,
        (i) => Card(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  _playingExperienceIcons[i],
                  width: 36,
                  height: 36,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _playingExperienceLabels[i],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      counts[i] != null ? counts[i].toString() : '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _personalInfo(User user) {
    final personalInfoValues = [
      user.name,
      user.teamName,
      user.email,
      user.mobile,
      user.gender,
      Utility.formatDate(dateTime: user.birthDate),
      user.address,
    ];
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 8,
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _personalInfoLabels.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, i) => Row(
            children: [
              Icon(_personalInfoIcons[i]),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _personalInfoLabels[i],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      personalInfoValues[i].isNotEmpty
                          ? personalInfoValues[i]
                          : '--',
                    ),
                  ],
                ),
              ),
            ],
          ),
          separatorBuilder: (context, i) => SizedBox(
            height: 12,
          ),
        ),
      ),
    );
  }
}
