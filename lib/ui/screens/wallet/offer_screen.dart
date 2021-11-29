import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_super11/blocs/wallet/offers/offers_bloc.dart';
import 'package:the_super11/core/utility.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/wallet/offer_details_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class OfferScreenData {
  final bool applyOffer;

  OfferScreenData({this.applyOffer = false});
}

class OfferScreen extends StatefulWidget {
  static const route = '/offers';
  final OfferScreenData? data;

  const OfferScreen({Key? key, this.data}) : super(key: key);

  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Offers',
      ),
      body: BlocConsumer<OffersBloc, OffersState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is OffersFetchingSuccess) {
            final offers = state.offers;
            if (offers.isNotEmpty)
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, i) => Card(
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(
                      OfferDetailsScreen.route,
                      arguments: OfferDetailsScreenData(offers[i]),
                    ),
                    borderRadius: BorderRadius.circular(8),
                    child: _offerItem(offers[i]),
                  ),
                ),
                separatorBuilder: (context, i) => Divider(),
                itemCount: offers.length,
              );
            return EmptyView(
              message: 'No offers available',
              image: imgNoOffer,
            );
          } else if (state is OffersFetchingFailure)
            return ErrorView(error: state.error);
          return LoadingIndicator();
        },
      ),
    );
  }

  Widget _offerItem(Offer offer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(8),
            ),
            child: AppNetworkImage(
              url: offer.offerImage,
              height: 220,
              width: double.infinity,
              errorIcon: imgOfferPlaceholder,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Valid till: ',
                          children: [
                            TextSpan(
                              text: Utility.formatDate(
                                  dateTime: offer.endDateTime,
                                  dateFormat: 'dd MMM, yyyy'),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                MaterialButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: offer.offerCode));
                    showTopSnackBar(
                      context,
                      CustomSnackBar.info(message: 'Copied to Clipboard'),
                    );
                    if (widget.data != null && widget.data!.applyOffer)
                      Navigator.of(context).pop(offer);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Theme.of(context).colorScheme.secondary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 10,
                  child: Row(
                    children: [
                      Text(offer.offerCode),
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
              ],
            ),
          ),
        ],
      );
}
