import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_super11/core/utility.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class OfferDetailsScreenData {
  final Offer offer;

  OfferDetailsScreenData(this.offer);
}

class OfferDetailsScreen extends StatefulWidget {
  static const route = '/offer-details';
  final OfferDetailsScreenData data;

  const OfferDetailsScreen({Key? key, required this.data}) : super(key: key);

  @override
  _OfferDetailsScreenState createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  late Offer _offer;

  @override
  void initState() {
    super.initState();
    _offer = widget.data.offer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: _offer.title,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AppNetworkImage(
                url: _offer.offerImage,
                errorIcon: imgOfferPlaceholder,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              _offer.description,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: MaterialButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _offer.offerCode));
                  showTopSnackBar(
                    context,
                    CustomSnackBar.info(message: 'Copied to Clipboard'),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                color: Theme.of(context).colorScheme.secondary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: 10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_offer.offerCode),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.copy,
                      size: 18,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Terms & Conditions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Divider(),
            _termsAndConditionText(
                'You have to deposit minimum ₹${_offer.minimumDeposit}'),
            _termsAndConditionText(
                'This offer is valid till ${Utility.formatDate(dateTime: _offer.endDateTime, dateFormat: 'dd MMM, yyyy')}.'),
          ],
        ),
      ),
    );
  }

  Widget _termsAndConditionText(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Row(
          children: [
            Text(
              '*',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(text),
            )
          ],
        ),
      );
}
