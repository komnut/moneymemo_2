import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  double _calculateTotal(List<Asset> assets) {
    return assets.fold(0, (sum, item) => sum + item.assetAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("Click add asset");
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
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Text(
            'My Assets',
            style: GoogleFonts.readexPro(
              textStyle: const TextStyle(
                fontSize: 40,
                color: Colors.black,
                letterSpacing: 0.0,
              ),
            ),
          ),
        ),
        centerTitle: false,
        elevation: 0,
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
              double totalAmount = _calculateTotal(assets);

              return Expanded(
                child: Column(
                  children: [
                    // ส่วนของ Total
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.92,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Total",
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    letterSpacing: 0.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                "\$${totalAmount.toStringAsFixed(2)}",
                                style: GoogleFonts.readexPro(
                                  textStyle: const TextStyle(
                                    fontSize: 30,
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
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
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
                                        title:
                                            "\$${asset.assetAmount.toStringAsFixed(2)}",
                                        textSize: 15,
                                        hexcolor: "#000000",
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
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
                                            Row(
                                              children: [
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 4),
                                                  child: TextInter(
                                                    title: "Total",
                                                    textSize: 10,
                                                    hexcolor: "#000000",
                                                  ),
                                                ),
                                                TextReadexpro(
                                                  title:
                                                      "\$${asset.assetAmount.toStringAsFixed(2)}",
                                                  textSize: 15,
                                                  hexcolor: "#000000",
                                                ),
                                              ],
                                            ),
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
              );
            },
          ),
        ],
      ),
    );
  }
}
