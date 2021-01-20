import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:novashop/main.dart';
import 'package:novashop/models/data_model.dart';
import 'package:novashop/models/user_model.dart';
import 'package:novashop/pages/product.dart';
import 'package:novashop/widgets/constants.dart';
import 'package:novashop/widgets/progress.dart';

import 'home.dart';

class Liked extends StatefulWidget {
  final UserModel currentUser;
  final bool isContainDrawer;

  const Liked({Key key, this.currentUser, this.isContainDrawer})
      : super(key: key);

  @override
  _LikedState createState() => _LikedState();
}

class _LikedState extends State<Liked> {
  Future<bool> isLiked;

  Future<bool> getDoc() async {
    var doc = await likedRef
        .document(widget.currentUser.uid)
        .collection('likedProducts')
        .getDocuments();
    if (doc.size > 0) {
      // setState(() {
      //   isLiked = true;
      // });
      return true;
    }
    if (doc.size == 0) {
      // setState(() {
      //   isLiked = false;
      // });
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isLiked = getDoc();
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, primaryColor])),
      child: Scaffold(
          drawer: widget.isContainDrawer
              ? drawer('Liked items', context, widget.currentUser)
              : null,
          backgroundColor: Colors.white,
          appBar: widget.isContainDrawer ? _drawerAppBar() : _appBar(),
          body: FutureBuilder(
              future: isLiked,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LinearProgressIndicator();
                }
                return snapshot.data
                    ? FutureBuilder<QuerySnapshot>(
                        future: likedRef
                            .document(widget.currentUser.uid)
                            .collection('likedProducts')
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Column(
                              children: [
                                linearProgressIndicator(),
                              ],
                            );
                          }
                          List<String> majorCategory = [];
                          List<String> category = [];
                          List<String> likedProductIds = [];
                          snapshot.data.documents.forEach((doc) {
                            majorCategory.add(doc['majorCategory'].toString());
                            category.add(doc['category'].toString());
                            likedProductIds.add(doc.id.toString());
                          });
                          return SingleChildScrollView(
                              child: Column(
                            children: [
                              Divider(height: 0, color: Colors.grey),
                              Container(
                                color: Colors.grey,
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
                                            .document(likedProductIds[index])
                                            .get(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Column(
                                              children: [
                                                LinearProgressIndicator(),
                                              ],
                                            );
                                          }
                                          DataModel productData =
                                              DataModel.fromDocument(
                                                  snapshot.data);
                                          return GestureDetector(
                                            onTap: () async {
                                              bool toSetState =
                                                  await Navigator.push(
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
                                                                    category[
                                                                        index],
                                                                productData:
                                                                    productData,
                                                              )));
                                              if (toSetState) {
                                                setState(() {});
                                              }
                                            },
                                            child: Container(
                                                color: Colors.white,
                                                padding: EdgeInsets.all(16),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                          child: Image.network(
                                                              productData
                                                                  .image1)),
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
                                                                              color: Colors.black,
                                                                              fontSize: 14)),
                                                                      TextSpan(
                                                                          text:
                                                                              "₹${productData.mrp}",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              decoration: TextDecoration.lineThrough)),
                                                                      TextSpan(
                                                                        text:
                                                                            " Save ${(((int.parse(productData.mrp) - int.parse(productData.price)) / int.parse(productData.mrp)) * 100).round()}%",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontStyle: FontStyle.italic),
                                                                      )
                                                                    ]))
                                                          ],
                                                        ),
                                                      )
                                                    ])),
                                          );
                                        });
                                  },
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          childAspectRatio: 2.8,
                                          mainAxisSpacing: 1.5),
                                ),
                              ),
                              Divider(height: 0, color: Colors.grey),
                            ],
                          ));
                        },
                      )
                    : Center(
                        child: Text('There are no items in this.',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)));
              })),
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
      title: Text('Liked products', style: TextStyle(color: Colors.black)),
    );
  }

  AppBar _drawerAppBar() {
    return AppBar(
      elevation: 0,
      title: Text('Liked products', style: TextStyle(color: Colors.black)),
    );
  }
}
