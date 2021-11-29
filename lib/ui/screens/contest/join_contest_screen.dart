import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/blocs/contest/join_private_contest/join_private_contest_bloc.dart';
import 'package:flutter_fire/blocs/contest/user_contests/user_contests_bloc.dart';
import 'package:flutter_fire/blocs/matches/team_and_contest_count/team_and_contest_count_bloc.dart';
import 'package:flutter_fire/core/providers/match_info_provider.dart';
import 'package:flutter_fire/ui/screens/contest/contest_app_header.dart';
import 'package:flutter_fire/ui/screens/teams/select_team_screen.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class JoinContestScreen extends StatefulWidget {
  static const route = '/join-private-contest';

  const JoinContestScreen({Key? key}) : super(key: key);

  @override
  _JoinContestScreenState createState() => _JoinContestScreenState();
}

class _JoinContestScreenState extends State<JoinContestScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _contestCodeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return UIBlocker(
      block: context.watch<JoinPrivateContestBloc>().state
          is JoinPrivateContestInProgress,
      child: Scaffold(
        appBar: ContestAppHeader(
          showAddMoney: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                'Enter contest invitation code below and join private contest.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Form(
                key: _formKey,
                autovalidateMode: _autoValidateMode,
                child: AppTextField(
                  controller: _contestCodeCtrl,
                  hintText: 'Contest Invitation Code',
                  keyboardType: TextInputType.visiblePassword,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value) => _contestCodeCtrl.value =
                      _contestCodeCtrl.value
                          .copyWith(text: value.toUpperCase()),
                  validator: (value) => value!.length < 3
                      ? 'Enter valid contest invitation code'
                      : null,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              BlocConsumer<JoinPrivateContestBloc, JoinPrivateContestState>(
                listener: (context, state) {
                  if (state is JoinPrivateContestSuccess) {
                    showTopSnackBar(context,
                        CustomSnackBar.success(message: state.message));
                    final userContestBloc = context.read<UserContestsBloc>();
                    context
                        .read<TeamAndContestCountBloc>()
                        .add(GetTeamAndContestCount());
                    if (userContestBloc.state is UserContestsFetchingSuccess)
                      userContestBloc.add(GetUserContests());
                    Navigator.of(context).pop();
                  } else if (state is JoinPrivateContestFailure)
                    showTopSnackBar(
                        context, CustomSnackBar.error(message: state.error));
                },
                builder: (context, state) {
                  return SubmitButton(
                    onPressed: _joinContest,
                    label: 'Join Contest',
                    progress: state is JoinPrivateContestInProgress,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _joinContest() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final teamId = await Navigator.of(context).pushNamed(
        SelectTeamScreen.route,
      );
      if (teamId is String) {
        context.read<JoinPrivateContestBloc>().add(JoinPrivateContest(
              contestCode: _contestCodeCtrl.text,
              body: {
                'match': context.read<MatchInfo>().match.id,
                'team': teamId
              },
            ));
      }
    } else
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
  }
}
