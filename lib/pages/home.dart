import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novashop/main.dart';
import 'package:novashop/models/user_model.dart';
import 'package:novashop/widgets/constants.dart';
import 'package:novashop/widgets/progress.dart';

import 'cart.dart';
import 'display_products.dart';
import 'liked.dart';

class HomePage extends StatefulWidget {
  final UserModel currentUser;

  const HomePage({Key key, this.currentUser}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

Container drawer(
    String selectedItem, BuildContext context, UserModel currentUser) {
  String drawerItemSelected = selectedItem;
  return Container(
    width: 350,
    child: Drawer(
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple[900],
                  Colors.indigo[900],
                ]),
          ),
          padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: 20),
                    Row(children: [
                      CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white54,
                          backgroundImage:
                              NetworkImage(currentUser.profileImage)),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text('Welcome, ${currentUser.name}.',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      )
                    ]),
                  ],
                ),
                Column(children: [
                  GestureDetector(
                    onTap: drawerItemSelected == 'Home'
                        ? null
                        : () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(currentUser: currentUser)));
                            // setState(() {
                            //   drawerItemSelected = 'Home';
                            // });
                          },
                    child: drawerMenu(
                        isSelected: drawerItemSelected == 'Home',
                        icon: Icons.home,
                        title: 'Home'),
                  ),
                  SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: drawerItemSelected == 'Liked items'
                                  ? null
                                  : (context) => Liked(
                                      currentUser: currentUser,
                                      isContainDrawer: true)));
                      // setState(() {
                      //   drawerItemSelected = 'Liked items';
                      // });
                    },
                    child: drawerMenu(
                        isSelected: drawerItemSelected == 'Liked items',
                        icon: Icons.favorite,
                        title: 'Liked items'),
                  ),
                  SizedBox(height: 4),
                  GestureDetector(
                    onTap: drawerItemSelected == 'Cart'
                        ? null
                        : () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Cart(
                                        currentUser: currentUser,
                                        isContainDrawer: true)));
                            // setState(() {
                            //   drawerItemSelected = 'Cart';
                            // });
                          },
                    child: drawerMenu(
                        isSelected: drawerItemSelected == 'Cart',
                        icon: Icons.shopping_cart,
                        title: 'Cart'),
                  ),
                  SizedBox(height: 4),
                  GestureDetector(
                    onTap: drawerItemSelected == 'Your orders'
                        ? null
                        : () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(currentUser: currentUser)));
                            // setState(() {
                            //   drawerItemSelected = 'Your orders';
                            // });
                          },
                    child: drawerMenu(
                        isSelected: drawerItemSelected == 'Your orders',
                        icon: Icons.shopping_bag_rounded,
                        title: 'Your orders'),
                  ),
                  SizedBox(height: 4),
                  GestureDetector(
                    onTap: drawerItemSelected == 'About seller'
                        ? null
                        : () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(currentUser: currentUser)));
                            // setState(() {
                            //   drawerItemSelected = 'About seller';
                            // });
                          },
                    child: drawerMenu(
                        isSelected: drawerItemSelected == 'About seller',
                        icon: Icons.notes_rounded,
                        title: 'About seller'),
                  ),
                ]),
                GestureDetector(
                  onTap: () {},
                  child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.white54,
                      ),
                      title: Text('Logout',
                          style:
                              TextStyle(color: Colors.white54, fontSize: 16))),
                )
              ])),
    ),
  );
}

Container drawerMenu({bool isSelected, String title, IconData icon}) {
  return Container(
    decoration: BoxDecoration(
        color: isSelected ? Colors.white12 : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(15))),
    child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white54,
        ),
        title:
            Text(title, style: TextStyle(color: Colors.white54, fontSize: 20))),
  );
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, primaryColor])),
      child: Scaffold(
          drawer: drawer('Home', context, widget.currentUser),
          appBar: AppBar(
              // leading: IconButton(
              //   icon: Icon(Icons.menu_rounded),
              //   onPressed: () {
              //     // Scaffold.of(context).openDrawer();
              //   },
              // ),
              title: Text('NOVA',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color,
                      fontFamily: 'GoogleSans')),
              actions: [
                IconButton(
                    icon: Icon(Icons.favorite_border_rounded),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Liked(
                                    currentUser: widget.currentUser,
                                    isContainDrawer: false,
                                  )));
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
              ]),
          body: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(height: 10),
              FutureBuilder(
                  future: productsRef.get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return linearProgressIndicator();
                    }
                    List<String> majorCategoryList = [];
                    snapshot.data.documents.forEach((doc) {
                      majorCategoryList.add(doc.id);
                    });
                    return ListView.builder(
                      itemCount: majorCategoryList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                            future: productsRef
                                .document(majorCategoryList[index])
                                .collection('categories')
                                .get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              }
                              List<Widget> categories = [];
                              snapshot.data.documents.forEach((doc) {
                                categories.add(
                                    listTile(doc.id, majorCategoryList[index]));
                              });
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.blueGrey[800]
                                          .withOpacity(0.3)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.blueGrey.shade200,
                                  //     offset: Offset(0.0, 1.0), //(x,y)
                                  //     blurRadius: 8.0,
                                  //   ),
                                  // ],
                                ),
                                child: ExpansionTile(
                                  title: ListTile(
                                      title: Text(majorCategoryList[index])),
                                  children: categories,
                                ),
                              );
                            });
                      },
                    );
                  }),
            ],
          ))),
    );
  }

  Widget listTile(String category, String majorCategory) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DisplayProducts(
                    majorCategory: majorCategory,
                    category: category,
                    currentUser: currentUser)));
      },
      child: Container(
        height: 45,
        child: Row(
          children: [
            SizedBox(width: 30),
            Text(category, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
