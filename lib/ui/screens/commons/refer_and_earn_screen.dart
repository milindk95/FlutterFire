import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:social_share/social_share.dart';
import 'package:flutter_fire/blocs/profile/user_profile/user_profile_bloc.dart';
import 'package:flutter_fire/core/providers/user_info_provider.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class ReferAndEarnScreen extends StatefulWidget {
  static const route = '/refer-and-earn';

  const ReferAndEarnScreen({Key? key}) : super(key: key);

  @override
  _ReferAndEarnScreenState createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Refer and Earn',
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileFetchingSuccess) {
              context.read<UserInfo>().setLoggedUserInfo(state.user);
            }
          },
          builder: (context, state) {
            if (state is UserProfileFetchingSuccess)
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Image.asset(
                      imgReferAndEarn,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: Text(
                        'Referral Code',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _copyReferralCode(state.user),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Invite a friend and get up to ₹100 when your friend joins a game and deposit minimum ₹50',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Divider(
                        height: 0,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () => Share.share(
                          getShareMessage(state.user.userReferralCode)),
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Share',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      minWidth: double.infinity,
                      height: 50,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MaterialButton(
                      onPressed: () =>
                          SocialShare.shareWhatsapp(getShareMessage(
                        state.user.userReferralCode,
                        whatsapp: true,
                      )),
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            icWhatsApp,
                            width: 24,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Share to Whatsapp',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      minWidth: double.infinity,
                      height: 50,
                    )
                  ],
                ),
              );
            else if (state is UserProfileFetching)
              return LoadingIndicator();
            else
              return Container();
          },
        ),
      ),
    );
  }

  Widget _copyReferralCode(User user) => InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: user.userReferralCode));
          showTopSnackBar(
              context, CustomSnackBar.info(message: 'Copied to Clipboard'));
        },
        borderRadius: BorderRadius.circular(8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 24,
            ),
            child: Column(
              children: [
                Text(
                  user.userReferralCode,
                  style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text('Tap to copy code')
              ],
            ),
          ),
        ),
      );
}
