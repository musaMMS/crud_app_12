
import 'package:crud_app_12/views/homeCreen/product_list_layer.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../controllers/data-controller.dart';
import '../../controllers/data_repository.dart';
import '../../moedl/product_model.dart';
import '../../srvice/api_sevice.dart';
import '../../utils/colors.dart';
import '../../utils/routes.dart';
import '../../utils/text_constants.dart';
import '../widgets/app_alert_dialog.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/app_toast.dart';
import 'no_product_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final DataRepository dataController;
  ValueNotifier<List<ProductModel>> productListNotifier =
  ValueNotifier<List<ProductModel>>([]);
  String cardSorting = "";

  @override
  void initState() {
    dataController = DataController(ApiService(baseUrl: baseUrl));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(homeScreenAppbarTitle),
        actions: [
          // IconButton(
          //     onPressed: () {}, icon: const Icon(Icons.more_vert, size: 30)),
          PopupMenuButton(
              color: whiteColor,
              tooltip: filterListText,
              onSelected: (sortValue) {
                cardSorting = sortValue;
                sortCards(sortValue);
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: "low",
                    child: Text(popupLowToHighText),
                  ),
                  const PopupMenuItem(
                    value: "high",
                    child: Text(popupHighToLowText),
                  ),
                ];
              })
        ],
      ),
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: dataController.getProductData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        productListNotifier.value = snapshot.data!;
                        if(cardSorting.isNotEmpty){
                          sortCards(cardSorting);
                        }
                        return Visibility(
                          visible: snapshot.data!.isNotEmpty,
                          replacement: NoProductData(onRefresh: () async {
                            List<ProductModel> productList =
                            await dataController.getProductData();
                            if (productList.isNotEmpty) {
                              setState(() {});
                            }
                          }),
                          child: ValueListenableBuilder<List<ProductModel>>(
                            valueListenable: productListNotifier,
                            builder: (
                                BuildContext context,
                                List<ProductModel> productList,
                                Widget? child,
                                ) {
                              if (productList.isEmpty) {
                                return NoProductData(onRefresh: () async {
                                  List<ProductModel> productList =
                                  await dataController.getProductData();
                                  if (productList.isNotEmpty) {
                                    setState(() {});
                                  }
                                });
                              }
                              return LiquidPullToRefresh(
                                showChildOpacityTransition: false,
                                animSpeedFactor: 2,
                                backgroundColor: whiteColor,
                                color: appPrimaryColor,
                                height: 150,
                                springAnimationDurationInMilliseconds: 1300,
                                onRefresh: () async {
                                  productListNotifier.value =
                                  await dataController.getProductData();
                                  if(cardSorting.isNotEmpty){
                                    sortCards(cardSorting);
                                  }
                                },
                                child: GridView.builder(
                                  itemCount: productList.length,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                    (orientation == Orientation.portrait)
                                        ? 2
                                        : 3,
                                    crossAxisSpacing: 1,
                                    mainAxisSpacing: 1,
                                    childAspectRatio:
                                    (orientation == Orientation.portrait)
                                        ? 0.65
                                        : 0.8,
                                  ),
                                  itemBuilder: (context, index) {
                                    return ProductListLayout(
                                      orientation: orientation,
                                      product: productList[index],
                                      removeFromList: () {
                                        showAlertDialog(index, productList);
                                      },
                                      editScreenNavigation: () {
                                        Navigator.pushNamed(
                                            context, Routes.updateProductScreen,
                                            arguments: {
                                              "dataRepository": dataController,
                                              "product": productList[index],
                                            }).then((message) {
                                          if (message != null) {
                                            postUpdateMessage(
                                                message.toString());
                                          }
                                          setState(() {});
                                        });
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: appPrimaryColor,
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.addProductScreen,
              arguments: dataController)
              .then((message) {
            if (message != null) {
              postUpdateMessage(message.toString());
              setState(() {});
            }
          });
        },
        backgroundColor: appPrimaryColor,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.00)),
        child: const Icon(
          Icons.add,
          color: whiteColor,
          size: 30,
        ),
      ),
    );
  }

  void postUpdateMessage(String message) {
    Future.delayed(const Duration(milliseconds: 900), () {
      showToast(content: message, context: context);
    });
  }

  void sortCards(String sortValue){
    productListNotifier.value = productListNotifier.value.isNotEmpty
        ? sortValue == "high"
        ? dataController
        .sortProductHighToLow(productListNotifier.value)
        : dataController
        .sortProductLowToHigh(productListNotifier.value)
        : productListNotifier.value;
  }

  Future<void> showAlertDialog(
      int index, List<ProductModel> productList) async {
    return showDialog(
      context: context,
      builder: (context) => AppAlertDialog(
        title: alertDialogWarningHeader,
        content: alertDialogDeleteContent,
        onAction: () {
          productListNotifier.value =
              dataController.removeProductData(productList, index);
          if (context.mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
                appSnackbar(deleteProductSuccessful, appPrimaryColor));
          }
        },
      ),
    );
  }
}
