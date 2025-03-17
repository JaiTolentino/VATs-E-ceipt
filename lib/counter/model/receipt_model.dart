import 'package:posclient/counter/model/product_model.dart';

class ReceiptModel {
  ReceiptModel(
    this.customerName,
    this.address,
    this.referenceNumber,
    this.serviceCharge,
    this.amount,
    this.vat,
    this.vatableSales,
    this.total,
    this.discount,
    this.cash,
    this.change,
    this.POSoperator,
    this.dateTimeCreated,
    this.userEmail,
    this.paymentMethod,
    this.receiptCategory,
    this.products,
  );
  String customerName;
  String address;
  int referenceNumber;
  double serviceCharge;
  double amount;
  double vat;
  double vatableSales;
  double total;
  double discount;
  double cash;
  double change;
  String POSoperator;
  String dateTimeCreated;
  String userEmail;
  String paymentMethod;
  String receiptCategory;
  List<ProductModel> products;
}
