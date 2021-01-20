import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:novashop/main.dart';
import 'package:novashop/models/data_model.dart';
import 'package:novashop/models/user_model.dart';
import 'package:novashop/pages/product.dart';
import 'package:novashop/widgets/constants.dart';

import 'home.dart';

class Cart extends StatefulWidget {
  final UserModel currentUser;
  final bool isContainDrawer;

  const Cart({Key key, this.currentUser, this.isContainDrawer})
      : super(key: key);
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  // bool isCartHasItems = false;
  Future<bool> isCartHasItemsF;
  String subtotal = 'calculating...';
  String savings = 'calculating...';
  String isFreeDelivery = 'calculating...';

  Future<bool> getDoc() async {
    var doc = await cartRef
        .document(widget.currentUser.uid)
        .collection('cart')
        .getDocuments();
    if (doc.size > 0) {
      // setState(() {
      //   isCartHasItems = true;
      // });
      return true;
    }
    if (doc.size == 0) {
      // setState(() {
      //   isCartHasItems = false;
      // });
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    isCartHasItemsF = getDoc();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, primaryColor])),
      child: Scaffold(
        drawer: widget.isContainDrawer
            ? drawer('Cart', context, widget.currentUser)
            : null,
        appBar: widget.isContainDrawer ? _drawerAppBar() : _appBar(),
        body: FutureBuilder(
            future: isCartHasItemsF,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LinearProgressIndicator();
              }
              return snapshot.data
                  ? StreamBuilder<QuerySnapshot>(
                      stream: cartRef
                          .document(widget.currentUser.uid)
                          .collection('cart')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Column(
                            children: [
                              LinearProgressIndicator(),
                            ],
                          );
                        }
                        List<String> majorCategory = [];
                        List<String> category = [];
                        List<String> cartProductIds = [];
                        int subtotalInt = 0;
                        int savingsInt = 0;
                        int deliveryChargeInt = 0;
                        snapshot.data.documents.forEach((doc) {
                          majorCategory.add(doc['majorCategory'].toString());
                          category.add(doc['category'].toString());
                          cartProductIds.add(doc.id.toString());
                          subtotalInt += int.parse(doc['price'].toString());
                          savingsInt += int.parse(doc['mrp'].toString()) -
                              int.parse(doc['price'].toString());
                          deliveryChargeInt +=
                              doc['deliveryCharge'].toString() == 'FREE'
                                  ? 0
                                  : int.parse(doc['deliveryCharge'].toString());
                        });
                        return SingleChildScrollView(
                            child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                            children: [
                                          TextSpan(text: 'Subtotal (1 item): '),
                                          TextSpan(
                                              text: '₹ $subtotalInt',
                                              style: TextStyle(
                                                  color: Colors.red[800],
                                                  fontSize: 20))
                                        ])),
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                            children: [
                                          TextSpan(
                                              text:
                                                  'You savings on shopping: '),
                                          TextSpan(
                                              text: '₹ $savingsInt',
                                              style: TextStyle(
                                                  color: Colors.red[300],
                                                  fontSize: 18))
                                        ])),
                                    SizedBox(height: 4),
                                    Text(
                                        deliveryChargeInt == 0
                                            ? 'Your order is eligible for FREE delivery'
                                            : '$deliveryChargeInt',
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 18)),
                                    SizedBox(height: 10),
                                    Container(
                                        height: 55,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.orange[400],
                                                  Colors.orange[700]
                                                ])
                                            // color: Colors.orangeAccent,
                                            ),
                                        child: Center(
                                            child: Text('Proceed to pay',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold))))
                                  ]),
                            ),
                            Container(
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  return FutureBuilder(
                                      future: productsRef
                                          .document(majorCategory[index])
                                          .collection('categories')
                                          .document(category[index])
                                          .collection('products')
                                          .document(cartProductIds[index])
                                          .get(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        }
                                        DataModel productData =
                                            DataModel.fromDocument(
                                                snapshot.data);

                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetails(
                                                          majorCategory:
                                                              majorCategory[
                                                                  index],
                                                          currentUser: widget
                                                              .currentUser,
                                                          category:
                                                              category[index],
                                                          productData:
                                                              productData,
                                                        )));
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                      child: Image.network(
                                                          productData.image1),
                                                    )),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                                productData
                                                                    .productName,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18)),
                                                          ),
                                                          RichText(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                            text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                      text:
                                                                          "₹ ",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red)),
                                                                  TextSpan(
                                                                    text:
                                                                        "${productData.price}",
                                                                    style: TextStyle(
                                                                        color: Colors.red[
                                                                            800],
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                ]),
                                                          ),
                                                          RichText(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 2,
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                            'MRP: ',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 14)),
                                                                    TextSpan(
                                                                        text:
                                                                            "₹${productData.mrp}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            decoration: TextDecoration.lineThrough)),
                                                                    TextSpan(
                                                                      text:
                                                                          " Save ${(((int.parse(productData.mrp) - int.parse(productData.price)) / int.parse(productData.mrp)) * 100).round()}%",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontStyle:
                                                                              FontStyle.italic),
                                                                    )
                                                                  ]))
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(child: Row(

                                                    ))
                                                  ])),
                                        );
                                      });
                                },
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        childAspectRatio: 3.3,
                                        mainAxisSpacing: 1),
                              ),
                            ),
                            Divider(
                                height: 0, thickness: 1.5, color: Colors.grey),
                          ],
                        ));
                      },
                    )
                  : Center(
                      child: Text('There are no items in the basket.',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)));
            }),
      ),
    );
  }

  AppBar _drawerAppBar() {
    return AppBar(
      elevation: 0,
      title: Text('Cart', style: TextStyle(color: Colors.black)),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios_rounded),
      ),
      title: Text('Cart', style: TextStyle(color: Colors.black)),
    );
  }
}
