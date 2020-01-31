import 'package:flutter/material.dart';
import 'package:fresto_apps/components/merchant_card.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models_data/admin_data/admin_modify_merchant_data.dart';
import 'package:fresto_apps/models_data/merchants_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:provider/provider.dart';

class AdminShowMerchantsScreen extends StatefulWidget {
  @override
  _AdminShowMerchantsScreenState createState() =>
      _AdminShowMerchantsScreenState();
}

class _AdminShowMerchantsScreenState extends State<AdminShowMerchantsScreen> {
  Widget _appBar(MerchantsData merchantsData) {
    return SliverAppBar(
      title: Text("Merchants"),
      floating: true,
      actions: <Widget>[
        merchantsData.isLoading
            ? SizedBox()
            : IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  merchantsData.fetchMerchantsFromDatabase();
                },
              ),
      ],
    );
  }

  Widget _contentSection(MerchantsData merchantsData) {
    if (merchantsData.isLoading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 200.0,
          width: double.infinity,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          Merchant merchant = merchantsData.getMerchants()[index];
          return MerchantCard(
            merchant: merchant,
            onTap: () {
              Provider.of<AdminModifyMerchantData>(context).setMerchant(
                merchant: merchant,
              );
              Navigator.pushNamed(context, kAdminModifyMerchantScreenRoute);
            },
          );
        },
        childCount: merchantsData.getMerchants().length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MerchantsData>(
      builder: (context, merchantsData, child) {
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              _appBar(merchantsData),
              _contentSection(merchantsData),
            ],
          ),
        );
      },
    );
  }
}
