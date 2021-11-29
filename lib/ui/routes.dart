import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/blocs/auth/forgot_password/forgot_password_bloc.dart';
import 'package:flutter_fire/blocs/auth/login/login_bloc.dart';
import 'package:flutter_fire/blocs/auth/set_new_password/set_new_password_bloc.dart';
import 'package:flutter_fire/blocs/auth/sign_up/sign_up_bloc.dart';
import 'package:flutter_fire/blocs/auth/sign_up_verification/sign_up_verification_bloc.dart';
import 'package:flutter_fire/blocs/contest/contest_details/contest_details_bloc.dart';
import 'package:flutter_fire/blocs/contest/join_private_contest/join_private_contest_bloc.dart';
import 'package:flutter_fire/blocs/contest/leaderboard/leaderboard_bloc.dart';
import 'package:flutter_fire/blocs/contest/match_credit/match_credit_bloc.dart';
import 'package:flutter_fire/blocs/matches/match_point/match_point_bloc.dart';
import 'package:flutter_fire/blocs/profile/accounts/add_account/add_account_bloc.dart';
import 'package:flutter_fire/blocs/profile/accounts/user_accounts/user_accounts_bloc.dart';
import 'package:flutter_fire/blocs/profile/edit_profile/edit_profile_bloc.dart';
import 'package:flutter_fire/blocs/profile/upload_photo/upload_photo_bloc.dart';
import 'package:flutter_fire/blocs/profile/user_profile/user_profile_bloc.dart';
import 'package:flutter_fire/blocs/profile/verification/email_verification/email_verification_bloc.dart';
import 'package:flutter_fire/blocs/profile/verification/send_email_otp/send_email_otp_bloc.dart';
import 'package:flutter_fire/blocs/profile/verification/upload_pan_card/upload_pan_card_bloc.dart';
import 'package:flutter_fire/blocs/team/compare_team/compare_team_bloc.dart';
import 'package:flutter_fire/blocs/team/manage_team/create_update_team_bloc.dart';
import 'package:flutter_fire/blocs/team/team_details/team_details_bloc.dart';
import 'package:flutter_fire/blocs/wallet/approved_accounts/approved_accounts_bloc.dart';
import 'package:flutter_fire/blocs/wallet/coupon_code/coupon_code_bloc.dart';
import 'package:flutter_fire/blocs/wallet/my_referral/my_referral_bloc.dart';
import 'package:flutter_fire/blocs/wallet/offers/offers_bloc.dart';
import 'package:flutter_fire/blocs/wallet/razorpay_params/razorpay_params_bloc.dart';
import 'package:flutter_fire/blocs/wallet/request_withdraw/request_withdraw_bloc.dart';
import 'package:flutter_fire/blocs/wallet/transaction_history/transaction_history_bloc.dart';
import 'package:flutter_fire/core/providers/match_info_provider.dart';

import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/login_sign_up_screen.dart';
import 'screens/auth/new_password_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/sign_up_verification_screen.dart';
import 'screens/commons/coming_soon_screen.dart';
import 'screens/commons/refer_and_earn_screen.dart';
import 'screens/contest/contest_details_screen.dart';
import 'screens/contest/contest_list_screen.dart';
import 'screens/contest/create_contest_screen.dart';
import 'screens/contest/join_contest_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/match/all_players_stats_screen.dart';
import 'screens/match/joined_contest_details_screen.dart';
import 'screens/match/match_details_screen.dart';
import 'screens/match/team_preview_screen.dart';
import 'screens/onboard/android_app_update_screen.dart';
import 'screens/onboard/ios_app_update_screen.dart';
import 'screens/onboard/splash_screen.dart';
import 'screens/profile/accounts/add_account_screen.dart';
import 'screens/profile/accounts/all_accounts_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/email_verification_screen.dart';
import 'screens/profile/pan_card_screen.dart';
import 'screens/profile/user_profile_screen.dart';
import 'screens/teams/compare_team_screen.dart';
import 'screens/teams/create_team_screen.dart';
import 'screens/teams/select_captain_vice_captain_screen.dart';
import 'screens/teams/select_team_screen.dart';
import 'screens/wallet/add_money_screen.dart';
import 'screens/wallet/my_referral_screen.dart';
import 'screens/wallet/offer_details_screen.dart';
import 'screens/wallet/offer_screen.dart';
import 'screens/wallet/transaction_history_screen.dart';
import 'screens/wallet/withdraw_money_screen.dart';

Route onGenerateRoute(RouteSettings routeSettings) {
  final arguments = routeSettings.arguments;
  switch (routeSettings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (_) => SplashScreen(),
      );

    case AndroidAppUpdateScreen.route:
      return MaterialPageRoute(
        builder: (_) => AndroidAppUpdateScreen(),
      );

    case IosAppUpdateScreen.route:
      return MaterialPageRoute(
        builder: (_) => IosAppUpdateScreen(),
      );

    case LoginSignUpScreen.route:
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>(create: (_) => LoginBloc()),
            BlocProvider<SignUpBloc>(create: (_) => SignUpBloc()),
          ],
          child: LoginSignUpScreen(),
        ),
      );

    case SignUpVerificationScreen.route:
      final data = arguments as SignUpVerificationData;
      return MaterialPageRoute(
        builder: (_) => BlocProvider<SignUpVerificationBloc>(
          create: (context) =>
              SignUpVerificationBloc(data.userId, data.mobileNoOrEmail),
          child: SignUpVerificationScreen(data: data),
        ),
      );

    case ForgotPasswordScreen.route:
      final data = arguments as ForgotPasswordScreenData;
      return MaterialPageRoute(
        builder: (_) => BlocProvider<ForgotPasswordBloc>(
          create: (context) => ForgotPasswordBloc(),
          child: ForgotPasswordScreen(data: data),
        ),
      );

    case OTPScreen.route:
      final data = arguments as OTPScreenData;
      return MaterialPageRoute(
        builder: (_) => OTPScreen(data: data),
      );

    case NewPasswordScreen.route:
      final data = arguments as NewPasswordScreenData;
      return MaterialPageRoute(
        builder: (_) => BlocProvider<SetNewPasswordBloc>(
          create: (context) => SetNewPasswordBloc(),
          child: NewPasswordScreen(data: data),
        ),
      );

    case HomeScreen.route:
      return MaterialPageRoute(
        builder: (context) => CupertinoTheme(
          data: CupertinoThemeData(
            brightness: Theme.of(context).brightness == Brightness.dark
                ? Brightness.dark
                : Brightness.light,
          ),
          child: HomeScreen(),
        ),
      );

    case UserProfileScreen.route:
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<UserProfileBloc>(
              create: (context) => UserProfileBloc()..add(GetUserProfile()),
            ),
            BlocProvider<UploadPhotoBloc>(
              create: (context) => UploadPhotoBloc(),
            )
          ],
          child: UserProfileScreen(),
        ),
      );

    case EmailVerificationScreen.route:
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<SendEmailOtpBloc>(
              create: (context) => SendEmailOtpBloc()..add(SendEmailOTP()),
            ),
            BlocProvider<EmailVerificationBloc>(
              create: (context) => EmailVerificationBloc(),
            ),
          ],
          child: EmailVerificationScreen(),
        ),
      );

    case PanCardScreen.route:
      return MaterialPageRoute(
        builder: (_) => BlocProvider<UploadPanCardBloc>(
          create: (context) => UploadPanCardBloc(),
          child: PanCardScreen(),
        ),
      );

    case AllAccountsScreen.route:
      return MaterialPageRoute(
        builder: (_) => BlocProvider<UserAccountsBloc>(
          create: (context) => UserAccountsBloc()..add(GetAllAccounts()),
          child: AllAccountsScreen(),
        ),
      );

    case AddAccountScreen.route:
      return MaterialPageRoute(
        builder: (_) => BlocProvider<AddAccountBloc>(
          create: (context) => AddAccountBloc(),
          child: AddAccountScreen(),
        ),
      );

    case EditProfileScreen.route:
      return MaterialPageRoute(
        builder: (_) => BlocProvider<EditProfileBloc>(
          create: (context) => EditProfileBloc(),
          child: EditProfileScreen(),
        ),
      );

    case ComingSoonScreen.route:
      return MaterialPageRoute(
        builder: (_) => ComingSoonScreen(
          title: arguments as String,
        ),
      );

    case ReferAndEarnScreen.route:
      return MaterialPageRoute(
        builder: (_) => BlocProvider<UserProfileBloc>(
          create: (context) => UserProfileBloc()..add(GetUserProfile()),
          child: ReferAndEarnScreen(),
        ),
      );

    case OfferScreen.route:
      final data = arguments != null ? arguments as OfferScreenData : null;
      return MaterialPageRoute(
        builder: (_) => BlocProvider<OffersBloc>(
          create: (context) => OffersBloc()..add(GetOffers()),
          child: OfferScreen(data: data),
        ),
      );

    case OfferDetailsScreen.route:
      final data = arguments as OfferDetailsScreenData;
      return MaterialPageRoute(
        builder: (_) => OfferDetailsScreen(data: data),
      );

    case TransactionHistoryScreen.route:
      return MaterialPageRoute(
        builder: (_) => BlocProvider<TransactionHistoryBloc>(
          create: (context) =>
              TransactionHistoryBloc()..add(GetTransactionHistory('All')),
          child: TransactionHistoryScreen(),
        ),
      );

    case MyReferralScreen.route:
      return MaterialPageRoute(
        builder: (_) => BlocProvider<MyReferralBloc>(
          create: (context) => MyReferralBloc()..add(GetMyReferral()),
          child: MyReferralScreen(),
        ),
      );

    case WithdrawMoneyScreen.route:
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<ApprovedAccountsBloc>(
              create: (context) =>
                  ApprovedAccountsBloc()..add(GetApprovedAccounts()),
            ),
            BlocProvider<RequestWithdrawBloc>(
              create: (context) => RequestWithdrawBloc(),
            ),
          ],
          child: WithdrawMoneyScreen(),
        ),
      );

    case AddMoneyScreen.route:
      final data = arguments != null ? arguments as AddMoneyScreenData : null;
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<RazorpayParamsBloc>(
              create: (context) => RazorpayParamsBloc(),
            ),
            BlocProvider<CouponCodeBloc>(
              create: (context) => CouponCodeBloc(),
            ),
          ],
          child: AddMoneyScreen(data: data),
        ),
      );

    case MatchDetailsScreen.route:
      return MaterialPageRoute(
        builder: (_) => MatchDetailsScreen(),
      );

    case JoinedContestDetailsScreen.route:
      final data = arguments as JoinedContestDetailsScreenData;
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<ContestDetailsBloc>(
              create: (context) =>
                  ContestDetailsBloc(data.contest.id)..add(GetContestDetails()),
            ),
            BlocProvider<LeaderboardBloc>(
              create: (context) =>
                  LeaderboardBloc(data.contest.id)..add(GetLeaderboard()),
            ),
            BlocProvider<MatchPointBloc>(
              create: (context) =>
                  MatchPointBloc(context.read<MatchInfo>().match.id),
            ),
            BlocProvider<TeamDetailsBloc>(
              create: (context) => TeamDetailsBloc(),
            ),
          ],
          child: JoinedContestDetailsScreen(data: data),
        ),
      );

    case AllPlayersStatsScreen.route:
      final data = arguments as AllPlayersStatsScreenData;
      return MaterialPageRoute(
        builder: (_) => BlocProvider<MatchCreditBloc>(
          create: (context) =>
              MatchCreditBloc(context.read<MatchInfo>().match.id)
                ..add(GetMatchCredit()),
          child: AllPlayersStatsScreen(data: data),
        ),
      );

    case TeamPreviewScreen.route:
      final data = arguments as TeamPreviewScreenData;
      return MaterialPageRoute(
        builder: (_) => TeamPreviewScreen(data: data),
        fullscreenDialog: true,
      );

    case ContestListScreen.route:
      return MaterialPageRoute(
        settings: RouteSettings(name: ContestListScreen.route),
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<MatchPointBloc>(
              create: (context) =>
                  MatchPointBloc(context.read<MatchInfo>().match.id)
                    ..add(GetMatchPoint()),
            ),
          ],
          child: ContestListScreen(),
        ),
      );

    case ContestDetailsScreen.route:
      final data = arguments as ContestDetailsScreenData;
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<LeaderboardBloc>(
              create: (context) =>
                  LeaderboardBloc(data.contest.id)..add(GetLeaderboard()),
            ),
            BlocProvider<MatchCreditBloc>(
              create: (context) =>
                  MatchCreditBloc(context.read<MatchInfo>().match.id),
            ),
            BlocProvider<TeamDetailsBloc>(
              create: (context) => TeamDetailsBloc(),
            ),
          ],
          child: ContestDetailsScreen(data: data),
        ),
      );

    case CreateContestScreen.route:
      final data = arguments as CreateContestScreenData;
      return MaterialPageRoute(
        builder: (_) => CreateContestScreen(data: data),
      );

    case JoinContestScreen.route:
      return MaterialPageRoute(
        builder: (_) => BlocProvider<JoinPrivateContestBloc>(
          create: (context) => JoinPrivateContestBloc(),
          child: JoinContestScreen(),
        ),
      );

    case CreateTeamScreen.route:
      final data = arguments as CreateTeamScreenData;
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<MatchCreditBloc>(
              create: (context) =>
                  MatchCreditBloc(context.read<MatchInfo>().match.id)
                    ..add(GetMatchCredit()),
              child: CreateTeamScreen(data: data),
            ),
          ],
          child: CreateTeamScreen(data: data),
        ),
      );

    case SelectCaptainViceCaptainScreen.route:
      final data = arguments as SelectCaptainViceCaptainScreenData;
      return MaterialPageRoute(
        builder: (_) => BlocProvider<CreateUpdateTeamBloc>(
          create: (context) => CreateUpdateTeamBloc(),
          child: SelectCaptainViceCaptainScreen(data: data),
        ),
      );

    case SelectTeamScreen.route:
      final data = arguments as SelectTeamScreenData?;
      return MaterialPageRoute(
        builder: (_) => SelectTeamScreen(data: data),
      );

    case CompareTeamScreen.route:
      final data = arguments as CompareTeamScreenData;
      return MaterialPageRoute(
        builder: (_) => BlocProvider<CompareTeamBloc>(
          create: (context) => CompareTeamBloc(),
          child: CompareTeamScreen(data: data),
        ),
      );

    default:
      return MaterialPageRoute(builder: (_) => Container());
  }
}
