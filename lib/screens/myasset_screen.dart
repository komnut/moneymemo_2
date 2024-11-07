import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneymemo_2/screens/form_add_screen.dart';
import 'package:moneymemo_2/screens/form_edit_screen.dart';
import 'package:moneymemo_2/services/asset_services.dart';
import 'package:moneymemo_2/widgets/text_inter.dart';
import 'package:moneymemo_2/widgets/text_readexpro.dart';

class MyAssetScreen extends StatefulWidget {
  final String username;

  const MyAssetScreen({super.key, required this.username});

  @override
  State<MyAssetScreen> createState() => _MyAssetScreenState();
}

class _MyAssetScreenState extends State<MyAssetScreen> {
  final FirestoreService firestoreService = FirestoreService();

  double _calculateAssetTotal(List<Asset> assets) {
    return assets
        .where((asset) => asset.assetType == 'asset')
        .fold(0.0, (sum, item) => sum + item.assetAmount);
  }

  double _calculateDebtTotal(List<Asset> assets) {
    return (assets
            .where((asset) => asset.assetType == 'debt')
            .fold(0.0, (sum, item) => sum + item.assetAmount)) *
        -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("Click add asset");
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TransactionADDScreen()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 8,
        child: Icon(
          Icons.post_add_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 32,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'My Assets',
          style: GoogleFonts.readexPro(
            textStyle: const TextStyle(
              fontSize: 30,
              color: Colors.black,
              letterSpacing: 0.0,
            ),
          ),
        ),
        // centerTitle: false,
        //elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamBuilder<List<Asset>>(
            stream: firestoreService.getUserAssets(widget.username),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    height: 400,
                  ),
                );
              }

              List<Asset> assets = snapshot.data!;
              double totalAssetAmount = _calculateAssetTotal(assets);
              double totalDebtAmount = _calculateDebtTotal(assets);

              final formattedTotalAssetAmount = NumberFormat.currency(
                locale: 'en_US',
                symbol: '',
                decimalDigits: 2,
              ).format(totalAssetAmount);

              final formattedTotalDebtAmount = NumberFormat.currency(
                locale: 'en_US',
                symbol: '',
                decimalDigits: 2,
              ).format(totalDebtAmount);

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    children: [
                      // กล่องสำหรับ Asset
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 0, 0, 5),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.44,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary, // ใช้สีเดิมสำหรับ Asset
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Color(0x3F14181B),
                                    offset: Offset(0, 3),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Asset",
                                      style: GoogleFonts.inter(
                                        textStyle: const TextStyle(
                                          fontSize: 30,
                                          letterSpacing: 0.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      formattedTotalAssetAmount, // แสดงผลรวม Asset
                                      style: GoogleFonts.readexPro(
                                        textStyle: const TextStyle(
                                          fontSize: 25,
                                          letterSpacing: 0.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // กล่องสำหรับ Debt
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 16, 5),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.44,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors
                                    .redAccent, // ใช้สี warning สำหรับ Debt
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Color(0x3F14181B),
                                    offset: Offset(0, 3),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Debt",
                                          style: GoogleFonts.inter(
                                            textStyle: const TextStyle(
                                              fontSize: 30,
                                              letterSpacing: 0.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      formattedTotalDebtAmount, // แสดงผลรวม Debt
                                      style: GoogleFonts.readexPro(
                                        textStyle: const TextStyle(
                                          fontSize: 25,
                                          letterSpacing: 0.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // แสดงรายการสินทรัพย์
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: assets.length,
                          itemBuilder: (context, index) {
                            Asset asset = assets[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  print("Click edit assets");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TransactionEditScreen(
                                              assetId: asset.id,
                                            )),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: asset.assetType == 'asset'
                                        ? Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .errorContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextInter(
                                              title: asset.assetName,
                                              textSize: 10,
                                              hexcolor: "#000000",
                                            ),
                                            const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: Colors.black,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                        TextReadexpro(
                                          title: NumberFormat("#,##0.00")
                                              .format(asset.assetAmount),
                                          textSize: 15,
                                          hexcolor: "#000000",
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextInter(
                                                title:
                                                    "Expires on ${asset.expiredDate ?? "N/A"}",
                                                textSize: 10,
                                                hexcolor: "#000000",
                                              ),
                                              // Row(
                                              //   children: [
                                              //     const Padding(
                                              //       padding:
                                              //           EdgeInsets.only(right: 4),
                                              //       child: TextInter(
                                              //         title: "Total",
                                              //         textSize: 10,
                                              //         hexcolor: "#000000",
                                              //       ),
                                              //     ),
                                              //     TextReadexpro(
                                              //       title:
                                              //           "\$${asset.assetAmount.toStringAsFixed(2)}",
                                              //       textSize: 15,
                                              //       hexcolor: "#000000",
                                              //     ),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
