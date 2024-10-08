import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posclient/counter/model/product_model.dart';
import 'package:posclient/counter/model/receipt_model.dart';
import 'package:posclient/counter/model/user_model.dart';

class FirestoreService {
  final CollectionReference userData =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference receiptsData =
      FirebaseFirestore.instance.collection('Receipts');

  final storageRef = FirebaseStorage.instance.ref();

  Future<Iterable<ReceiptModel>> getUserReceipts(String email) {
    return receiptsData
        .where('userEmail', isEqualTo: email)
        .get()
        .then((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<ProductModel> list = [];
        return ReceiptModel(
          data['customerName'].toString(),
          data['address'].toString(),
          int.parse(data['referenceNumber'].toString()),
          double.parse(data['serviceCharge'].toString()),
          double.parse(data['amount'].toString()),
          double.parse(data['vat'].toString()),
          double.parse(data['total'].toString()),
          double.parse(data['cash'].toString()),
          double.parse(data['change'].toString()),
          data['POSoperator'].toString(),
          data['dateTimeCreated'].toString(),
          data['userEmail'].toString(),
          data['paymentMethod'].toString(),
          data['receiptCategory'].toString(),
          list,
        );
      }).toList();
    });
  }

  Stream<Iterable<UserModel>> getUsers() {
    return userData.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel(
          fullName: data['fullName'].toString(),
          email: doc['email'].toString(),
        );
      }).toList();
    });
  }

  Future<void> addUser(UserModel user) {
    return userData
        .doc(user.email)
        .set({'fullName': user.fullName, 'email': user.email, 'role': 'user'});
  }

  Future<void> addReceipt(ReceiptModel receipt) {
    final receiptRef =
        receiptsData.doc(receipt.referenceNumber.toString()).set({
      'customerName': receipt.customerName,
      'address': receipt.address,
      'referenceNumber': receipt.referenceNumber,
      'amount': receipt.amount,
      'vat': receipt.vat,
      'total': receipt.total,
      'POSoperator': receipt.POSoperator,
      'dateTimeCreated': receipt.dateTimeCreated,
      'userEmail': receipt.userEmail,
      'paymentMethod': receipt.paymentMethod,
      'receiptCategory': receipt.receiptCategory,
    });
    for (final ProductModel element in receipt.products as List<ProductModel>) {
      receiptsData
          .doc(receipt.referenceNumber.toString())
          .collection('products')
          .doc(element.productCode.toString())
          .set({
        'code': element.productCode,
        'name': element.name,
        'price': element.price,
        'quantity': element.quantity,
      });
    }

    return receiptRef;
  }

  Future<void> assignReceiptToUser(int referenceNumber, String email) {
    return receiptsData
        .doc(referenceNumber.toString())
        .update({'userEmail': email});
  }

  Future<void> changeProductTag(int referenceNumber, String tag) {
    return receiptsData
        .doc(referenceNumber.toString())
        .update({'receiptCategory': tag});
  }

  Future<UserModel?> getUser(String email) {
    final DocumentReference<Object?> data = userData.doc(email);
    final user = data.get().then((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return UserModel(
        fullName: data['fullName'].toString(),
        email: data['email'].toString(),
      );
    });
    return user;
  }

  Future<ReceiptModel?> getReceipt(int referenceNumber) {
    final DocumentReference<Object?> data =
        receiptsData.doc(referenceNumber.toString());
    final receipt = data.get().then((doc) {
      final data = doc.data() as Map<String, dynamic>;
      List<ProductModel> list = [];
      return ReceiptModel(
        data['customerName'].toString(),
        data['address'].toString(),
        int.parse(data['referenceNumber'].toString()),
        double.parse(data['serviceCharge'].toString()),
        double.parse(data['amount'].toString()),
        double.parse(data['vat'].toString()),
        double.parse(data['total'].toString()),
        double.parse(data['cash'].toString()),
        double.parse(data['change'].toString()),
        data['POSoperator'].toString(),
        data['dateTimeCreated'].toString(),
        data['userEmail'].toString(),
        data['paymentMethod'].toString(),
        data['receiptCategory'].toString(),
        list,
      );
    });
    return receipt;
  }

  Future<List<ProductModel>> getReceiptProducts(int referenceNumber) {
    return receiptsData
        .doc(referenceNumber.toString())
        .collection('products')
        .get()
        .then(
      (snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return ProductModel(
              int.parse(data['code'].toString()),
              data['name'].toString(),
              int.parse(data['price'].toString()),
              int.parse(data['quantity'].toString()));
        }).toList();
      },
    );
  }

  Future<void> uploadUserProfilePhoto(XFile file, String email) {
    final userRef = storageRef.child('profiles/${email}');
    return userRef.putFile(
      File(file.path),
      SettableMetadata(
        contentType: "Image/jpeg",
      ),
    );
  }

  Future<String?> getUserProfile(String email) {
    return storageRef.child('profiles/${email}').getDownloadURL();
  }

  Future<String?> getDefaultProfile() async {
    return storageRef.child('profiles/default.png').getDownloadURL();
  }

  Future<void> changeFullName(String email, String name) {
    return userData.doc(email).update({'fullName': name});
  }
}
