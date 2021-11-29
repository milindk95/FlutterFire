import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:the_super11/blocs/wallet/coupon_code/coupon_code_bloc.dart';
import 'package:the_super11/blocs/wallet/razorpay_params/razorpay_params_bloc.dart';
import 'package:the_super11/core/providers/user_info_provider.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/wallet/offer_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class AddMoneyScreenData {
  final int amount;

  AddMoneyScreenData({required this.amount});
}

class AddMoneyScreen extends StatefulWidget {
  static const route = '/add-money';
  final AddMoneyScreenData? data;

  const AddMoneyScreen({Key? key, this.data}) : super(key: key);

  @override
  _AddMoneyScreenState createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final _amountCtrl = TextEditingController(text: '100'),
      _couponCodeCtrl = TextEditingController();
  final _moneys = [100, 200, 500, 1000];
  int _selected = 0;
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _amountCtrl.text = widget.data!.amount.toString();
      _selected = _moneys.indexOf(widget.data!.amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return UIBlocker(
      block: BlocProvider.of<RazorpayParamsBloc>(context, listen: true).state
          is RazorpayParamsFetching,
      child: Scaffold(
        appBar: AppHeader(
          title: 'Add Money',
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Wallet Balance',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '₹${context.read<UserInfo>().user.totalAmount}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          'Enter amount to add',
                          style: TextStyle(fontSize: 18),
                        ),
                        _addMoneyTextField(),
                        Container(
                          height: 100,
                          child: _defaultMoneys(),
                        ),
                        BlocBuilder<CouponCodeBloc, CouponCodeState>(
                          builder: (context, state) => _couponCode(state),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        _getCouponCodeButton(),
                      ],
                    ),
                  ),
                ),
              ),
              _addMoneyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addMoneyTextField() => SizedBox(
        width: 190,
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: TextFormField(
            controller: _amountCtrl,
            textAlign: TextAlign.center,
            maxLength: 6,
            keyboardType: TextInputType.numberWithOptions(signed: false),
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (value) {
              int num = value.isNotEmpty ? int.parse(value) : 0;
              setState(() => _selected = _moneys.indexOf(num));
              context.read<CouponCodeBloc>().add(ResetCouponCode());
            },
            validator: (value) =>
                value!.isEmpty || int.parse(value) < addMoneyMinimumAmount
                    ? 'Amount should be minimum ₹$addMoneyMinimumAmount'
                    : null,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9]"))
            ],
            decoration: InputDecoration(
              hintText: 'Amount',
              prefixText: '₹',
              counterText: '',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 16),
            ),
          ),
        ),
      );

  Widget _defaultMoneys() => ListView.separated(
        itemCount: _moneys.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) => ActionChip(
          label: Text('₹${_moneys[i]}'),
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: i == _selected ? Colors.blueAccent : null,
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 10,
          ),
          onPressed: () {
            setState(() => _selected = i);
            _amountCtrl.text = _moneys[i].toString();
            _amountCtrl.selection = TextSelection.fromPosition(
                TextPosition(offset: _amountCtrl.text.length));
            final state = context.read<CouponCodeBloc>().state;
            if (state is CouponCodeApplyingSuccess ||
                state is CouponCodeApplyingFailure) _applyCouponCode();
          },
        ),
        separatorBuilder: (context, i) => SizedBox(
          width: 6,
        ),
      );

  Widget _couponCode(CouponCodeState state) {
    Widget _couponTextField() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: _couponCodeCtrl,
            enabled: state is CouponCodeInitial,
            decoration: InputDecoration.collapsed(
              hintText: 'Enter Coupon Code',
            ),
            textCapitalization: TextCapitalization.characters,
            onChanged: (value) {
              _couponCodeCtrl.value =
                  _couponCodeCtrl.value.copyWith(text: value.toUpperCase());
              if (value.length < 4) setState(() {});
            },
          ),
        );

    Widget _applyButton() => MaterialButton(
          onPressed: _applyCouponCode,
          child: Icon(
            Icons.arrow_right_alt,
            color: Colors.white,
          ),
          color: Colors.green,
          shape: CircleBorder(),
          minWidth: 0,
          padding: const EdgeInsets.all(6),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 54,
          child: DottedBorder(
            color: Colors.green.shade700,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            dashPattern: [4, 2],
            child: Center(
              child: Row(
                children: [
                  SvgPicture.asset(
                    icCoupon,
                    width: 30,
                    color: Colors.green,
                  ),
                  Expanded(
                    child: _couponTextField(),
                  ),
                  if (_couponCodeCtrl.text.length > 2 &&
                      state is CouponCodeInitial)
                    _applyButton(),
                  if (state is CouponCodeApplying) CupertinoActivityIndicator(),
                  if (state is CouponCodeApplyingSuccess ||
                      state is CouponCodeApplyingFailure)
                    IconButton(
                      onPressed: () {
                        _couponCodeCtrl.text = '';
                        context.read<CouponCodeBloc>().add(ResetCouponCode());
                      },
                      splashRadius: 20,
                      padding: EdgeInsets.zero,
                      iconSize: 24,
                      constraints: BoxConstraints(maxWidth: 24),
                      icon: Icon(Icons.close),
                    )
                ],
              ),
            ),
          ),
        ),
        if (state is CouponCodeApplyingFailure)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              state.error,
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (state is CouponCodeApplyingSuccess)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              state.message,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _getCouponCodeButton() => MaterialButton(
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed(
              OfferScreen.route,
              arguments: OfferScreenData(applyOffer: true));
          if (result is Offer) {
            _couponCodeCtrl.text = result.offerCode;
            _applyCouponCode();
          }
        },
        child: Text(
          'GET COUPON CODE',
          style: TextStyle(
            letterSpacing: 2.2,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );

  Widget _addMoneyButton() =>
      BlocConsumer<RazorpayParamsBloc, RazorpayParamsState>(
        listener: (context, state) {
          if (state is RazorpayParamsFetchingSuccess) {
            _manageRazorpayEvents(state.options);
          } else if (state is RazorpayParamsFetchingFailure)
            showTopSnackBar(
              context,
              CustomSnackBar.error(message: state.error),
            );
        },
        builder: (context, state) {
          return SubmitButton(
            onPressed: _addMoney,
            label: '+ Add Money',
            progress: context.read<RazorpayParamsBloc>().state
                is RazorpayParamsFetching,
          );
        },
      );

  void _applyCouponCode() => context.read<CouponCodeBloc>().add(ApplyCouponCode(
        amount: _amountCtrl.text,
        offerCode: _couponCodeCtrl.text,
      ));

  void _addMoney() {
    if (_formKey.currentState!.validate()) {
      final couponCode = context.read<CouponCodeBloc>().state;
      final offerId = couponCode is CouponCodeApplyingSuccess
          ? couponCode.coupon.offerId
          : null;
      context.read<RazorpayParamsBloc>().add(GetRazorpayParams(
            amount: _amountCtrl.text,
            offerId: offerId,
          ));
    } else
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
  }

  void _manageRazorpayEvents(Map<String, dynamic> options) {
    void paymentSuccess(PaymentSuccessResponse response) async {
      _razorpay.clear();
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message: '₹${_amountCtrl.text} added successfully to wallet',
        ),
      );
      final info = context.read<UserInfo>();
      final state = context.read<CouponCodeBloc>().state;
      final depositBonus =
          state is CouponCodeApplyingSuccess ? state.coupon.depositBonus : 0;
      final cashBonus =
          state is CouponCodeApplyingSuccess ? state.coupon.cashBonus : 0;
      await info.updateAmounts(
        depositAmount: info.user.realAmount +
            double.parse(_amountCtrl.text) +
            depositBonus,
        bonusAmount: info.user.redeemAmount + cashBonus,
      );
      Navigator.of(context).pop();
    }

    void paymentError(PaymentFailureResponse response) {
      _razorpay.clear();
      showTopSnackBar(
        context,
        CustomSnackBar.error(message: 'Transaction failed'),
      );
    }

    void payByExternalWallet(ExternalWalletResponse response) {
      _razorpay.clear();
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message: '₹${_amountCtrl.text} added successfully by external wallet',
        ),
      );
    }

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, payByExternalWallet);
    _razorpay.open(options);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _razorpay.clear();
    super.dispose();
  }
}
