import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:opclo/core/constants/subcription_constants.dart';
import 'package:url_launcher/url_launcher.dart';


class StoreView extends StatefulWidget {
  @override
  _StoreViewState createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _isAvailable = false;
  String? _notice;
  List<ProductDetails> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    setState(() {
      _isAvailable = isAvailable;
    });

    if (!_isAvailable) {
      setState(() {
        _loading = false;
        _notice = "There are no upgrades at this time";
      });
      return;
    }

    // get IAP.
    ProductDetailsResponse productDetailsResponse = await _inAppPurchase.queryProductDetails(SubscriptionConstants.productIds.toSet());

    setState(() {
      _loading = false;
      _products = productDetailsResponse.productDetails;
    });

    if (productDetailsResponse.error != null) {
      setState(() {
        _notice = "There was a problem connecting to the store";
      });
    } else if (productDetailsResponse.productDetails.isEmpty) {
      setState(() {
        _notice = "There are no upgrades at this time";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Store"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_notice != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_notice!),
              ),
            if (_loading) Expanded(child: Center(child: CircularProgressIndicator())),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final ProductDetails productDetails = _products[index];

                  return Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _getIAPIcon(productDetails.id),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${productDetails.title}", style: Theme.of(context).textTheme.headlineMedium),
                              Text("${productDetails.description}"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: _buyText(productDetails),
                            onPressed: () {
                              late PurchaseParam purchaseParam;
                                purchaseParam = PurchaseParam(productDetails: productDetails);
                              if (SubscriptionConstants.consumableIds.contains(productDetails.id)) {
                                InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
                              } else {
                                InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildRestoreButton(),
            _buildTermsButton(),
          ],
        ),
      ),
    );
  }

  Widget _getIAPIcon(productId) {
  if (productId == "opclo_monthly") {
      return Icon(Icons.brightness_5, size: 50);
    } else if (productId == "opclo_yearly") {
      return Icon(Icons.brightness_7, size: 50);
    } else {
      return Icon(Icons.post_add_outlined, size: 50);
    }
  }

  Widget _buyText(productDetails) {
    if (productDetails.id == "opclo_monthly") {
      return Text("${productDetails.price} / month");
    } else if (productDetails.id == "opclo_yearly") {
      return Text("${productDetails.price} / year");
    } else {
      return Text("Buy for ${productDetails.price}");
    }
  }

  Widget _buildRestoreButton() {
    if (_loading) {
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        TextButton(
          child: Text('Restore Purchases'),
          style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
          onPressed: () => _inAppPurchase.restorePurchases(),
        )
      ],
    );
  }

  Widget _buildTermsButton() {
    if (_loading) {
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        TextButton(
          child: Text('Privacy Policy'),
          style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
          onPressed: () => _launchURL("https://www.iubenda.com/privacy-policy/22947780"),
        ),
        TextButton(
          child: Text('Terms & Conditions'),
          style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
          onPressed: () => _launchURL("https://www.iubenda.com/terms-and-conditions/22947780"),
        )
      ],
    );
  }

  void _launchURL(url) async {
    await canLaunch(url) ? await launch(url) : throw 'could not launch the url';
  }

}