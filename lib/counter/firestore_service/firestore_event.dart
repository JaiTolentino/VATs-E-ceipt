part of 'firestore_bloc.dart';

abstract class FirestoreEvent {}

class GetUsers extends FirestoreEvent {}

class AddUser extends FirestoreEvent {
  AddUser(this.user);
  final UserModel user;
}

class GetUser extends FirestoreEvent {
  GetUser(this.email);
  final String email;
}

class GetUserReceipts extends FirestoreEvent {
  GetUserReceipts(this.email);
  final String email;
}

class GetUserReceiptsUpdateTag extends FirestoreEvent {
  GetUserReceiptsUpdateTag(this.email, this.query);
  final String email;
  final String query;
}

class GetUserReceiptsUpdate extends FirestoreEvent {
  GetUserReceiptsUpdate(this.email, this.query);
  final String email;
  final String query;
}

class AddReceipt extends FirestoreEvent {
  AddReceipt(this.receipt);
  final ReceiptModel receipt;
}

class AssignReceiptToUser extends FirestoreEvent {
  AssignReceiptToUser(this.referenceNumber, this.email);
  final int referenceNumber;
  final String email;
}

class GetReceipt extends FirestoreEvent {
  GetReceipt(this.referenceNumber);
  final int referenceNumber;
}

class GetReceiptProducts extends FirestoreEvent {
  GetReceiptProducts(this.referenceNumber);
  final int referenceNumber;
}

class ChangeProductTag extends FirestoreEvent {
  ChangeProductTag(this.referenceNumber, this.tag);
  final int referenceNumber;
  final String tag;
}

class UploadUserProfilePhoto extends FirestoreEvent {
  UploadUserProfilePhoto(this.file, this.email);
  final XFile file;
  final String email;
}

class ChangeFullName extends FirestoreEvent {
  ChangeFullName(this.email, this.name);
  final String email;
  final String name;
}

class GetUserProfile extends FirestoreEvent {
  GetUserProfile(this.email);
  final String email;
}
