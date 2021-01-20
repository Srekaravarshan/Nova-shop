import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:novashop/main.dart';
import 'package:novashop/models/data_model.dart';
import 'package:novashop/models/user_model.dart';
import 'package:novashop/widgets/constants.dart';
import 'package:novashop/widgets/progress.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cart.dart';
import 'liked.dart';

class ProductDetails extends StatefulWidget {
  final DataModel productData;
  final String majorCategory;
  final String category;
  final UserModel currentUser;

  const ProductDetails(
      {Key key,
      this.productData,
      this.majorCategory,
      this.category,
      this.currentUser})
      : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int currentPage = 0;
  List<Widget> pageItem = [];
  Future<bool> isLiked;
  bool isLiking = false;
  bool isAddedToCart = false;
  bool isAddingToCart = false;
  int quantity = 01;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> getDoc() async {
    var doc = await likedRef
        .document(widget.currentUser.uid)
        .collection('likedProducts')
        .document(widget.productData.productId)
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
    final margin = MediaQuery.of(context).size.width * 0.075;
    isLiked = getDoc();
    List aboutItemKeys = widget.productData.itemDetails.keys.toList();
    List aboutItemValues = widget.productData.itemDetails.values.toList();
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, primaryColor])),
      child: Scaffold(
        appBar: AppBar(
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
          title: Text(
            'NOVA',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                Navigator.pop(context, true);
              }),
        ),
        body: FutureBuilder(
            future: isLiked,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return linearProgressIndicator();
              }
              return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // Divider(color: Colors.grey[700], height: 0),
                    // SizedBox(height: 15),
                    // Container(
                    //   margin: EdgeInsets.only(left: 20),
                    //   child: Text(widget.productData.productName,
                    //       style: TextStyle(
                    //           fontSize: 24, fontWeight: FontWeight.bold)),
                    // ),
                    // SizedBox(height: 15),
                    // Divider(color: Colors.grey[700], height: 0),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width * 0.85,
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.05),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.blueGrey[800].withOpacity(0.3)),
                              color: Colors.white,
                              // boxShadow: [
                              //   BoxShadow(
                              //       color:
                              //           Colors.blueGrey[800].withOpacity(0.3),
                              //       offset: Offset(0, 5),
                              //       blurRadius: 20)
                              // ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: Column(
                            children: [
                              Center(
                                child: Stack(children: [
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.width * 0.8,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blueGrey[800]
                                                .withOpacity(0.1)),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: PageView.builder(
                                      onPageChanged: (value) {
                                        setState(() {
                                          currentPage = value;
                                        });
                                      },
                                      itemCount: countImage().length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Center(
                                                child: Image.network(
                                              countImage()[index],
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                            )));
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: !snapshot.data
                                          ? () async {
                                              setState(() {
                                                isLiking = true;
                                              });
                                              await likedRef
                                                  .document(
                                                      widget.currentUser.uid)
                                                  .collection('likedProducts')
                                                  .document(widget
                                                      .productData.productId)
                                                  .setData({
                                                'majorCategory':
                                                    widget.majorCategory,
                                                'category': widget.category,
                                              });
                                              setState(() {
                                                isLiking = false;
                                                // isLiked = !isLiked;
                                              });
                                            }
                                          : () async {
                                              setState(() {
                                                isLiking = true;
                                              });
                                              await likedRef
                                                  .document(
                                                      widget.currentUser.uid)
                                                  .collection('likedProducts')
                                                  .document(widget
                                                      .productData.productId)
                                                  .get()
                                                  .then((doc) {
                                                if (doc.exists) {
                                                  doc.reference.delete();
                                                }
                                              });
                                              setState(() {
                                                isLiking = false;
                                                // isLiked = !isLiked;
                                              });
                                            },
                                      child: Ink(
                                          height: 35,
                                          width: 35,
                                          decoration: ShapeDecoration(
                                              shape: CircleBorder(),
                                              color: Colors.transparent),
                                          child: isLiking
                                              ? Center(
                                                  child: SizedBox(
                                                      height: 15,
                                                      width: 15,
                                                      child:
                                                          CircularProgressIndicator()),
                                                )
                                              : Icon(
                                                  snapshot.data
                                                      ? Icons.favorite_rounded
                                                      : Icons
                                                          .favorite_border_rounded,
                                                  color: redColor)),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: AnimatedSmoothIndicator(
                                        activeIndex: currentPage,
                                        count: countImage().length,
                                        duration: Duration(milliseconds: 300),
                                        effect: ExpandingDotsEffect(
                                            activeDotColor: Colors.blue,
                                            dotWidth: 8,
                                            dotHeight: 8,
                                            expansionFactor: 2),
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.05),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(widget.productData.productName,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.purple[900],
                                                    Colors.indigo[900],
                                                    // secondaryColor
                                                  ])),
                                          child: Center(
                                              child: Text(
                                                  '₹ ${widget.productData.price}',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: yellowColor,
                                                      fontWeight:
                                                          FontWeight.bold))))
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Divider(color: Colors.grey[700], height: 0),
                    SizedBox(height: 40),
                    Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.05),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.blueGrey[800].withOpacity(0.3)),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: margin),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("₹" + widget.productData.price,
                                  style: TextStyle(
                                      fontSize: 28,
                                      color: redColor,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 2),
                              RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                      ),
                                      children: [
                                        TextSpan(
                                            text: 'MRP: ',
                                            style:
                                                TextStyle(color: Colors.black)),
                                        TextSpan(
                                            text: "₹${widget.productData.mrp}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                decoration: TextDecoration
                                                    .lineThrough)),
                                        TextSpan(
                                          text:
                                              " Save ${(((int.parse(widget.productData.mrp) - int.parse(widget.productData.price)) / int.parse(widget.productData.mrp)) * 100).round()}%",
                                          style: TextStyle(
                                              color: redColor,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ])),
                              SizedBox(height: 4),
                              RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                      ),
                                      children: [
                                        TextSpan(
                                            text: 'Delivery charge: ',
                                            style:
                                                TextStyle(color: Colors.black)),
                                        TextSpan(
                                          text:
                                              widget.productData.deliveryCharge,
                                          style: TextStyle(
                                              color: redColor,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ])),
                              SizedBox(height: 4),
                              Text('In stock.',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 20)),
                              SizedBox(height: 16),
                              InkWell(
                                onTap: () async {
                                  String uri = "tel:+919043089889";
                                  if (await canLaunch(uri)) {
                                    await launch(uri);
                                  } else {
                                    print("Can't launch");
                                  }
                                },
                                child: Container(
                                    height: 55,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: Colors.purple[900],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.phone,
                                                color: yellowColor),
                                            SizedBox(width: 8),
                                            Text('Order by call',
                                                style: TextStyle(
                                                  color: yellowColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                              SizedBox(height: 8),
                              InkWell(
                                onTap: () async {
                                  await cartRef
                                      .document(widget.currentUser.uid)
                                      .collection('cart')
                                      .document(widget.productData.productId)
                                      .setData({
                                    'majorCategory': widget.majorCategory,
                                    'category': widget.category,
                                    'price': widget.productData.price,
                                    'mrp': widget.productData.mrp,
                                    'deliveryCharge':
                                        widget.productData.deliveryCharge,
                                  });
                                  Fluttertoast.showToast(
                                      msg: 'Added to cart',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER);
                                },
                                child: Container(
                                    height: 55,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: Colors.indigo[900],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            isAddingToCart
                                                ? Container()
                                                : Icon(
                                                    Icons
                                                        .add_shopping_cart_rounded,
                                                    color: yellowColor),
                                            SizedBox(width: 8),
                                            isAddingToCart
                                                ? CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(yellowColor),
                                                  )
                                                : Text('Add to cart',
                                                    style: TextStyle(
                                                      color: yellowColor,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                          ],
                                        ),
                                        // SizedBox(height: 4),
                                        // Text('+91 90430 89889',
                                        //     style: TextStyle(color: Colors.white))
                                      ],
                                    )),
                              )
                            ])),
                    SizedBox(height: 20),
                    // Divider(color: Colors.grey[700], height: 0),
                    SizedBox(height: 16),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: margin),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('About this item',
                                  style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 12),
                              widget.productData.about == ''
                                  ? Container()
                                  : Text(widget.productData.about,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(fontSize: 18)),
                              SizedBox(height: 12),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: aboutItemKeys.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    constraints: BoxConstraints(minHeight: 40),
                                    child: Row(children: [
                                      Expanded(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(aboutItemKeys[index],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.grey[600]),
                                                  overflow:
                                                      TextOverflow.clip))),
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                              margin: EdgeInsets.only(left: 8),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  aboutItemValues[index],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                  overflow: TextOverflow.clip)))
                                    ]),
                                  );
                                },
                              ),
                              SizedBox(height: 8),
                            ])),
                    SizedBox(height: 10),
                    // Divider(color: Colors.grey[700], height: 0),
                    Container(
                      margin: EdgeInsets.all(margin),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Seller contact',
                                style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.purple[300],
                                    radius: 28,
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Ravindran',
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold)),
                                      Text('+91 90430 89889',
                                          overflow: TextOverflow.clip,
                                          style:
                                              TextStyle(color: Colors.black54))
                                    ],
                                  )
                                ]),
                                Ink(
                                    decoration: ShapeDecoration(
                                        shape: CircleBorder(),
                                        color: Colors.purple[900]),
                                    // color: Colors.green,
                                    child: IconButton(
                                        icon: Icon(Icons.call),
                                        color: yellowColor,
                                        onPressed: () async {
                                          String uri = "tel:+919043089889";
                                          if (await canLaunch(uri)) {
                                            await launch(uri);
                                          } else {
                                            print("Can't launch");
                                          }
                                        }))
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(children: [
                              Container(
                                  child: Text(
                                'Address',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600]),
                              )),
                              SizedBox(
                                width: 19,
                              ),
                              Container(
                                child: Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            'NOVA shopping',
                                            style: TextStyle(
                                                color: Colors.purple[900],
                                                fontStyle: FontStyle.italic,
                                                fontSize: 16),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Container(
                                          child: Text(
                                            "Plot no.'P', Kuberan street, Sri mahalaksmi nagar, Villapuram, Madurai - 625012.",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                            overflow: TextOverflow.clip,
                                          ),
                                        )
                                      ]),
                                ),

                                //
                              ),
                              InkWell(
                                onTap: () async {
                                  String uri =
                                      "https://www.google.com/maps/place/Ramesh+iyengar/@9.9016089,78.1131394,15z/data=!4m8!1m2!2m1!1sramesh+iyengar!3m4!1s0x3b00c5997f51e5f3:0xd6f679ea5df3967a!8m2!3d9.9016089!4d78.1218941";
                                  if (await canLaunch(uri)) {
                                    await launch(uri);
                                  } else {
                                    print("Can't load uri");
                                  }
                                },
                                child: Ink(
                                    height: 35,
                                    width: 35,
                                    decoration: ShapeDecoration(
                                        shape: CircleBorder(),
                                        color: Colors.indigo[900]),
                                    child: Icon(Icons.location_on,
                                        color: yellowColor)),
                              ),
                            ])
                          ]),
                    ),
                  ]));
            }),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: Colors.white,
            ),
            constraints: BoxConstraints(
              minHeight: 80,
              maxHeight: 90,
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Total: ₹ ${int.parse(widget.productData.price) * quantity}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Row(children: [
                          Container(
                            height: 30,
                            width: 30,
                            child: GestureDetector(
                                child: Icon(Icons.remove, color: Colors.black),
                                onTap: () {
                                  if (quantity > 1) {
                                    setState(() {
                                      quantity--;
                                    });
                                  } else {}
                                }),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                    color:
                                        Colors.blueGrey[900].withOpacity(0.3))),
                          ),
                          SizedBox(width: 10),
                          Text(quantity.toString().padLeft(2, '0'),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(width: 10),
                          Container(
                            height: 30,
                            width: 30,
                            child: GestureDetector(
                                child: Icon(Icons.add, color: Colors.black),
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                  });
                                }),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                    color:
                                        Colors.blueGrey[900].withOpacity(0.3))),
                          ),
                        ])
                      ]),
                  Container(
                      height: 60,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.purple[900],
                                Colors.indigo[900]
                              ])),
                      child: Center(
                          child: Text('Buy now',
                              style: TextStyle(
                                  color: yellowColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18))))
                ])),
      ),
    );
  }

  List<String> countImage() {
    List<String> imageList = [];
    if (widget.productData.image1 != '') {
      imageList.add(widget.productData.image1);
    }
    if (widget.productData.image2 != '') {
      imageList.add(widget.productData.image2);
    }
    if (widget.productData.image3 != '') {
      imageList.add(widget.productData.image3);
    }
    if (widget.productData.image4 != '') {
      imageList.add(widget.productData.image4);
    }
    return imageList;
  }

  buildPageItem(String image, double width) {
    Container(
        height: width,
        child: Center(
            child: Image.network(
          image,
          height: width * 0.8,
        )));
  }
}
