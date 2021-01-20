import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:novashop/main.dart';
import 'package:novashop/models/data_model.dart';
import 'package:novashop/models/user_model.dart';
import 'package:novashop/pages/product.dart';
import 'package:novashop/widgets/constants.dart';
import 'package:novashop/widgets/progress.dart';

import 'cart.dart';
import 'liked.dart';

class DisplayProducts extends StatefulWidget {
  final String majorCategory;
  final String category;
  final UserModel currentUser;

  const DisplayProducts(
      {Key key, this.majorCategory, this.category, this.currentUser})
      : super(key: key);

  @override
  _DisplayProductsState createState() => _DisplayProductsState();
}

class _DisplayProductsState extends State<DisplayProducts> {
  int productsCount;
  List<DataModel> products;
  Future<bool> isLiked;
  bool isLiking = false;
  bool isAddingCart = false;
  int likedIndex;
  int addCartIndex;

  Future<bool> getDoc(String productId) async {
    var doc = await likedRef
        .document(widget.currentUser.uid)
        .collection('likedProducts')
        .document(productId)
        .get();
    if (doc.exists) {
      // setState(() {
      //   isLiked = true;
      // });
      return true;
    }
    if (!doc.exists) {
      // setState(() {
      //   isLiked = false;
      // });
    }
    return false;
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
          appBar: AppBar(
            title: Text('NOVA',
                style:
                    TextStyle(color: Colors.black, fontFamily: 'GoogleSans')),
            actions: [
              IconButton(
                  icon: Icon(Icons.favorite_border_rounded),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Liked(
                                currentUser: widget.currentUser,
                                isContainDrawer: false)));
                  }),
              IconButton(
                  icon: Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Cart(
                                currentUser: widget.currentUser,
                                isContainDrawer: false)));
                  }),
            ],
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded),
                onPressed: () => Navigator.pop(context)),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 1.5),
                  FutureBuilder<QuerySnapshot>(
                    future: productsRef
                        .document(widget.majorCategory)
                        .collection('categories')
                        .document(widget.category)
                        .collection('products')
                        .getDocuments(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Column(children: [linearProgressIndicator()]);
                      }
                      productsCount = snapshot.data.documents.length;
                      products = snapshot.data.documents
                          .map((doc) => DataModel.fromDocument(doc))
                          .toList();
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: productsCount,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          isLiked = getDoc(products[index].productId);
                          return Container(
                            margin: index % 2 == 0
                                ? EdgeInsets.only(left: 20, bottom: 10)
                                : EdgeInsets.only(right: 20, bottom: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Colors.blueGrey[800].withOpacity(0.3)),
                                color: Colors.white,
                                // boxShadow: [
                                //   BoxShadow(
                                //       offset: Offset(0, 5),
                                //       color:
                                //           Colors.blueGrey[800].withOpacity(0.5),
                                //       blurRadius: 5)
                                // ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetails(
                                            productData: products[index],
                                            majorCategory: widget.majorCategory,
                                            category: widget.category,
                                            currentUser: currentUser)));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              width: double.infinity,
                                              height: 180,
                                              child: Image.network(
                                                  products[index].image1)),
                                          SizedBox(width: 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 6,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                          products[index]
                                                              .productName,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18)),
                                                    ),
                                                    RichText(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                            text: "₹ ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red)),
                                                        TextSpan(
                                                          text:
                                                              "${products[index].price}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .red[800],
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ]),
                                                    ),
                                                    SizedBox(height: 4),
                                                    RichText(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        text:
                                                            TextSpan(children: [
                                                          TextSpan(
                                                              text: 'MRP: ',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      13)),
                                                          TextSpan(
                                                              text:
                                                                  "₹${products[index].mrp}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough)),
                                                          TextSpan(
                                                            text:
                                                                "\nSave ${(((int.parse(products[index].mrp) - int.parse(products[index].price)) / int.parse(products[index].mrp)) * 100).round()}%",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          )
                                                        ]))
                                                  ],
                                                ),
                                              ),
                                              Expanded(child: Container())
                                            ],
                                          ),
                                        ]),
                                  ),
                                  Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                          height: 90,
                                          width: 37,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.purple[900],
                                                    Colors.indigo[900],
                                                  ]),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20))),
                                          child: FutureBuilder(
                                              future: isLiked,
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                    child: SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  yellowColor),
                                                        )),
                                                  );
                                                }
                                                return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: !snapshot.data
                                                            ? () async {
                                                                setState(() {
                                                                  // isLiking = true;
                                                                  likedIndex =
                                                                      index;
                                                                });
                                                                await likedRef
                                                                    .document(widget
                                                                        .currentUser
                                                                        .uid)
                                                                    .collection(
                                                                        'likedProducts')
                                                                    .document(products[
                                                                            index]
                                                                        .productId)
                                                                    .setData({
                                                                  'majorCategory':
                                                                      widget
                                                                          .majorCategory,
                                                                  'category': widget
                                                                      .category,
                                                                });
                                                                setState(() {
                                                                  likedIndex =
                                                                      null;
                                                                  // isLiking = false;
                                                                  // isLiked = !isLiked;
                                                                });
                                                              }
                                                            : () async {
                                                                setState(() {
                                                                  likedIndex =
                                                                      index;
                                                                  // isLiking = true;
                                                                });
                                                                await likedRef
                                                                    .document(widget
                                                                        .currentUser
                                                                        .uid)
                                                                    .collection(
                                                                        'likedProducts')
                                                                    .document(products[
                                                                            index]
                                                                        .productId)
                                                                    .get()
                                                                    .then(
                                                                        (doc) {
                                                                  if (doc
                                                                      .exists) {
                                                                    doc.reference
                                                                        .delete();
                                                                  }
                                                                });
                                                                setState(() {
                                                                  likedIndex =
                                                                      null;
                                                                  // isLiking = false;
                                                                  // isLiked = !isLiked;
                                                                });
                                                              },
                                                        child: likedIndex ==
                                                                index
                                                            ? Center(
                                                                child: SizedBox(
                                                                    height: 15,
                                                                    width: 15,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation<Color>(
                                                                              yellowColor),
                                                                    )),
                                                              )
                                                            : Icon(
                                                                snapshot.data
                                                                    ? Icons
                                                                        .favorite_rounded
                                                                    : Icons
                                                                        .favorite_border_rounded,
                                                                color:
                                                                    yellowColor),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          await cartRef
                                                              .document(widget
                                                                  .currentUser
                                                                  .uid)
                                                              .collection(
                                                                  'cart')
                                                              .document(products[
                                                                      index]
                                                                  .productId)
                                                              .setData({
                                                            'majorCategory': widget
                                                                .majorCategory,
                                                            'category':
                                                                widget.category,
                                                            'price':
                                                                products[index]
                                                                    .price,
                                                            'mrp':
                                                                products[index]
                                                                    .mrp,
                                                            'deliveryCharge':
                                                                products[index]
                                                                    .deliveryCharge,
                                                          });
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Added to cart',
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER);
                                                        },
                                                        child: addCartIndex ==
                                                                index
                                                            ? Center(
                                                                child: SizedBox(
                                                                    height: 15,
                                                                    width: 15,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation<Color>(
                                                                              yellowColor),
                                                                    )),
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .shopping_cart_outlined,
                                                                color:
                                                                    yellowColor),
                                                      ),
                                                    ]);
                                              })))
                                ],
                              ),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.66,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                      );
                    },
                  ),
                  SizedBox(height: 1.5),
                ],
              ),
            ),
          )),
    );
  }
}
