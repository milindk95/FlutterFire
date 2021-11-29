import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_super11/blocs/contest/create_contest/create_contest_bloc.dart';
import 'package:the_super11/core/extensions.dart';
import 'package:the_super11/core/providers/match_info_provider.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/screens/contest/contest_app_header.dart';
import 'package:the_super11/ui/screens/contest/join_contest_dialog.dart';
import 'package:the_super11/ui/screens/teams/select_team_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class CreateContestScreenData {
  final double commission;

  CreateContestScreenData({required this.commission});
}

class CreateContestScreen extends StatefulWidget {
  static const route = '/create-contest';

  final CreateContestScreenData data;

  const CreateContestScreen({Key? key, required this.data}) : super(key: key);

  @override
  _CreateContestScreenState createState() => _CreateContestScreenState();
}

class _CreateContestScreenState extends State<CreateContestScreen> {
  late final CreateContestBloc _contestBloc;
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _winningAmountFocus = FocusNode();
  final _contestNameCtrl = TextEditingController(),
      _contestSizeCtrl = TextEditingController(),
      _winningAmountCtrl = TextEditingController(),
      _numberOfWinnersCtrl = TextEditingController(),
      _maxTeamCtrl = TextEditingController();

  List<WinningPrize> _winningPrices = [];
  List<TextEditingController> _priceCTRLs = [];
  List<FocusNode> _priceFocusNodes = [];
  int _remainAmount = 0;

  @override
  void initState() {
    super.initState();
    _contestBloc = context.read<CreateContestBloc>()
      ..setMatchId(context.read<MatchInfo>().match.id);
  }

  @override
  void dispose() {
    _contestBloc.add(ResetCreateContest());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ContestAppHeader(
        showAddMoney: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidateMode,
                child: _contestForm(),
              ),
            ),
          ),
          if (!context.isKeyboardVisible)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SubmitButton(
                  onPressed: _createContest,
                  label: 'Create Contest',
                ),
              ),
            ),
          if (context.isKeyboardVisible) NumberKeyboardAction()
        ],
      ),
    );
  }

  Widget _contestForm() => Column(
        children: [
          Text(
            'Create your own contest by filling below information and invite others.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          AppTextField(
            controller: _contestNameCtrl,
            hintText: 'Contest Name',
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            formatters: Formatters.acceptCharactersAndSpace,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_winningAmountFocus),
            validator: (value) => value!.length < 4
                ? 'Contest name should contains 4 characters'
                : null,
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () => context.showValuePicker<int>(
              title: 'Select Number of Participants',
              items: List.generate(49, (index) => index + 2),
              initialItem: _contestSizeCtrl.text.isEmpty
                  ? 0
                  : int.parse(_contestSizeCtrl.text) - 2,
              onValueChanged: (value) {
                if (value.toString() != _contestSizeCtrl.text) {
                  _contestSizeCtrl.text = value.toString();
                  _numberOfWinnersCtrl.text = '1';
                  _maxTeamCtrl.text = '1';
                  setState(() {});
                }
              },
            ),
            behavior: HitTestBehavior.opaque,
            child: AbsorbPointer(
              child: AppTextField(
                controller: _contestSizeCtrl,
                hintText: 'Number of Participants',
                dropDown: true,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          AppTextField(
            controller: _winningAmountCtrl,
            focusNode: _winningAmountFocus,
            hintText: 'Total Winning Amount',
            maxLength: 4,
            keyboardType: TextInputType.numberWithOptions(signed: false),
            formatters: Formatters.acceptNumbers,
            onChanged: (value) => setState(() {
              _remainAmount = value.isEmpty ? 0 : int.parse(value);
              _winningPrices.clear();
              _priceCTRLs.clear();
            }),
            validator: (value) {
              if (value!.isEmpty || int.parse(value) < 20)
                return 'Amount should be minimum ₹20';
              else if (int.parse(value) > 1000)
                return 'Amount should be maximum ₹1000';
              return null;
            },
          ),
          SizedBox(
            height: 12,
          ),
          AbsorbPointer(
            absorbing: _contestSizeCtrl.text.isEmpty,
            child: GestureDetector(
              onTap: () => context.showValuePicker<int>(
                title: 'Select Number of Winners',
                items: List.generate(
                    int.parse(_contestSizeCtrl.text), (index) => index + 1),
                initialItem: int.parse(_numberOfWinnersCtrl.text) - 1,
                onValueChanged: (value) {
                  _numberOfWinnersCtrl.text = value.toString();
                },
              ),
              behavior: HitTestBehavior.opaque,
              child: AbsorbPointer(
                child: AppTextField(
                  controller: _numberOfWinnersCtrl,
                  hintText: 'Number of Winners',
                  enabled: _contestSizeCtrl.text.isNotEmpty,
                  dropDown: true,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          AbsorbPointer(
            absorbing: _contestSizeCtrl.text.isEmpty,
            child: GestureDetector(
              onTap: () => context.showValuePicker<int>(
                title: 'Maximum Number of Team',
                items: _maxTeamAllowToJoinList,
                initialItem: _maxTeamCtrl.text.isEmpty
                    ? 0
                    : int.parse(_maxTeamCtrl.text) - 1,
                onValueChanged: (value) {
                  _maxTeamCtrl.text = value.toString();
                },
              ),
              behavior: HitTestBehavior.opaque,
              child: AbsorbPointer(
                child: AppTextField(
                  controller: _maxTeamCtrl,
                  hintText: 'Maximum Number of Team to allow to join',
                  enabled: _contestSizeCtrl.text.isNotEmpty,
                  dropDown: true,
                ),
              ),
            ),
          ),
          if (_contestSizeCtrl.text.isNotEmpty &&
              _winningAmountCtrl.text.isNotEmpty &&
              int.parse(_winningAmountCtrl.text) >= 20)
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 0.5)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Entry Fee per Team:',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            '₹$_entreeFeePerTeam',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'Entry fee is calculated based on total winning amount and number of participants',
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Distribute Price',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Available Amount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '₹$_availableAmount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                _distributePrice(),
              ],
            ),
        ],
      );

  int get _entreeFeePerTeam {
    final winningAmount = int.parse(_winningAmountCtrl.text);
    return ((winningAmount + (winningAmount * widget.data.commission / 100)) /
            int.parse(_contestSizeCtrl.text))
        .round();
  }

  List<int> get _maxTeamAllowToJoinList {
    final list = List.generate(5, (index) => index + 1);
    final contestSize = int.parse(_contestSizeCtrl.text);
    if (contestSize <= 4)
      return List.of(list.getRange(0, 1));
    else if (contestSize < 7) return List.of(list.getRange(0, 2));
    return List.generate(5, (index) => index + 1);
  }

  Widget _distributePrice() => Card(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Container(
                padding: const EdgeInsets.all(4),
                color: Theme.of(context).colorScheme.secondary,
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Rank / Rank Range'),
                    ),
                    Text('Winning Price')
                  ],
                ),
              ),
            ),
            _rankPriceList(),
            if (_winningPrices.isEmpty ||
                _winningPrices.last.endRank !=
                    int.parse(_numberOfWinnersCtrl.text))
              IconButton(
                onPressed: () {
                  context.showRankPicker<int>(
                    title: 'Select Rank / Rank Range',
                    items: List.generate(
                        _rankPickerLength, (index) => index + _startRank),
                    startRank: _startRank,
                    initialIndex: 0,
                    onValueChanged: (value) {
                      _winningPrices.add(WinningPrize(
                        startRank: _startRank,
                        endRank: value,
                      ));
                      _priceCTRLs.add(TextEditingController());
                      _priceFocusNodes.add(FocusNode());
                      if (_winningPrices.length > 1) {
                        final price = _winningPrices[_winningPrices.length - 2];
                        _remainAmount -=
                            ((price.endRank + 1 - price.startRank) *
                                    price.winningAmount)
                                .toInt();
                      }
                      setState(() {});
                      Future.delayed(
                          const Duration(milliseconds: 100),
                          () => FocusScope.of(context)
                              .requestFocus(_priceFocusNodes.last));
                    },
                  );
                },
                icon: Icon(
                  Icons.add_circle,
                  size: 30,
                  color: Theme.of(context).primaryColor,
                ),
                splashRadius: 24,
              )
          ],
        ),
      );

  Widget _rankPriceList() => ListView.separated(
        itemCount: _winningPrices.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(4),
        itemBuilder: (context, i) => Row(
          children: [
            Expanded(
              child: Text(
                _rankText(i),
              ),
            ),
            SizedBox(
              width: 80,
              child: AbsorbPointer(
                absorbing: i != _winningPrices.length - 1,
                child: _priceText(i),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            IconButton(
              onPressed: () {
                if (i != _winningPrices.length - 1)
                  context.showAlert(
                    title: 'Price Distribution',
                    message:
                        '${_rankText(i)} will get ₹${_winningPrices[i].winningAmount.round()}',
                  );
                else
                  context.showConfirmation(
                    title: 'Confirmation',
                    message:
                        '${_rankText(i)} will removed. Do you want to remove?',
                    positiveText: 'Remove',
                    positiveAction: () => setState(() {
                      _winningPrices.removeAt(i);
                      _priceCTRLs.removeAt(i);
                      _priceFocusNodes.removeAt(i);
                      if (_winningPrices.isNotEmpty) {
                        final winningPrice = _winningPrices.last;
                        _remainAmount += ((winningPrice.endRank +
                                    1 -
                                    winningPrice.startRank) *
                                winningPrice.winningAmount)
                            .toInt();
                      }
                    }),
                  );
              },
              icon: Icon(i != _winningPrices.length - 1
                  ? Icons.check
                  : Icons.remove_circle_outline),
              splashRadius: 20,
              color: i != _winningPrices.length - 1
                  ? Colors.green
                  : Colors.redAccent,
            ),
          ],
        ),
        separatorBuilder: (context, i) => Divider(),
      );

  Widget _priceText(int i) => TextFormField(
        controller: _priceCTRLs[i],
        focusNode: _priceFocusNodes[i],
        textAlign: TextAlign.center,
        maxLength: _winningAmountCtrl.text.length,
        onChanged: (value) => setState(() {
          final amount = value.isEmpty ? 0 : int.parse(value);
          final requiredAmount = amount *
              (_winningPrices.last.endRank + 1 - _winningPrices.last.startRank);
          if (_remainAmount - requiredAmount < 0) {
            _priceCTRLs[i].text = _priceCTRLs[i]
                .text
                .substring(0, _priceCTRLs[i].text.length - 1);
            _priceCTRLs[i].selection = TextSelection.fromPosition(
                TextPosition(offset: _priceCTRLs[i].text.length));
            return;
          }
          _winningPrices[i] = _winningPrices[i].copyWith(
            winningAmount: amount.toDouble(),
          );
        }),
        keyboardType: TextInputType.numberWithOptions(signed: false),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
        decoration: InputDecoration(
          prefixText: '₹',
          counterText: '',
          contentPadding: EdgeInsets.all(8),
          isDense: true,
        ),
      );

  int get _rankPickerLength {
    final maxWinner = int.parse(_numberOfWinnersCtrl.text);
    if (_winningPrices.isEmpty) return maxWinner;
    return maxWinner - _winningPrices.last.endRank;
  }

  int get _startRank {
    if (_winningPrices.isEmpty) return 1;
    return _winningPrices.last.endRank + 1;
  }

  String _rankText(int i) {
    final startRank = _winningPrices[i].startRank;
    final endRank = _winningPrices[i].endRank;
    final toRank = endRank > startRank ? ' to $endRank' : '';
    return '# Rank $startRank$toRank';
  }

  int get _availableAmount {
    int winningAmount = int.parse(_winningAmountCtrl.text);
    for (int i = 0; i < _winningPrices.length; i++) {
      final distributedAmount =
          _priceCTRLs[i].text.isEmpty ? '0' : _priceCTRLs[i].text;
      winningAmount -=
          (_winningPrices[i].endRank + 1 - _winningPrices[i].startRank) *
              int.parse(distributedAmount);
    }
    return winningAmount;
  }

  void _createContest() async {
    if (_formKey.currentState!.validate()) {
      if (_winningPrices.last.endRank == int.parse(_numberOfWinnersCtrl.text)) {
        if (_availableAmount == 0) {
          final joinContest = JoinContestDialog(
            context: context,
            contest: Contest(
              feePerEntry: _entreeFeePerTeam.toDouble(),
            ),
            createContest: true,
          );
          if (!joinContest.ableToJoin) {
            joinContest.showAddMoneyConfirmation();
            return;
          }
          final selectedTeamId = await Navigator.of(context).pushNamed(
            SelectTeamScreen.route,
          );
          if (selectedTeamId is String)
            joinContest.showJoinContestDialog(
              selectedTeamId: selectedTeamId,
              createContestBody: {
                'name': _contestNameCtrl.text.trim(),
                'team': selectedTeamId,
                'noOfEntry': int.parse(_contestSizeCtrl.text),
                'winningAmount': int.parse(_winningAmountCtrl.text),
                'maxNoOfWinner': int.parse(_numberOfWinnersCtrl.text),
                'maxEntryPerUser': int.parse(_maxTeamCtrl.text),
                'contestType': 'private contest',
                "bonusPerEntry": 0,
                "winningPrizes": List.generate(
                  _winningPrices.length,
                  (index) => _winningPrices[index].toJson(),
                )
              },
            );
        } else
          showTopSnackBar(
            context,
            CustomSnackBar.error(
                message: 'Utilize all winning amount between winners'),
          );
      } else
        showTopSnackBar(
          context,
          CustomSnackBar.error(
              message: 'Distribute winning amount to all winners'),
        );
    } else
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
  }
}
