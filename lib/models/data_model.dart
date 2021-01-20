import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  final String productName;
  final String about;
  final String price;
  final String mrp;
  final String deliveryCharge;
  final String weight;
  final List<dynamic> sizeList;
  final Map itemDetails;
  final String image1;
  final String image2;
  final String image3;
  final String image4;
  final String productId;

  DataModel(
      this.productName,
      this.about,
      this.price,
      this.mrp,
      this.deliveryCharge,
      this.weight,
      this.sizeList,
      this.itemDetails,
      this.image1,
      this.image2,
      this.image3,
      this.image4,
      this.productId);

  factory DataModel.fromDocument(DocumentSnapshot doc) {
    return DataModel(
        doc['productName'],
        doc['about'],
        doc['price'],
        doc['mrp'],
        doc['deliveryCharge'],
        doc['weight'],
        doc['sizeList'],
        doc['itemDetails'],
        doc['image1'],
        doc['image2'],
        doc['image3'],
        doc['image4'],
        doc['productId']);
  }
}
