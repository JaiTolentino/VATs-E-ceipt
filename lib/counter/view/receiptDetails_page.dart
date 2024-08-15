import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:posclient/counter/cubit/receiptDetails_cubit.dart';
import 'package:posclient/counter/firestore_service/firestore_bloc.dart';
import 'package:posclient/counter/firestore_service/firestore_service.dart';

class ReceiptdetailsPage extends StatelessWidget {
  const ReceiptdetailsPage({required this.referenceNumber, super.key});
  final int referenceNumber;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ReceiptdetailsCubit()),
        BlocProvider(create: (context) => FirestoreBloc(FirestoreService()))
      ],
      child: ReceiptdetailsView(
        referenceNumber: referenceNumber,
      ),
    );
  }
}

class ReceiptdetailsView extends StatefulWidget {
  const ReceiptdetailsView({required this.referenceNumber, super.key});
  final int referenceNumber;
  @override
  State<ReceiptdetailsView> createState() => _ReceiptdetailsViewState();
}

class _ReceiptdetailsViewState extends State<ReceiptdetailsView> {
  TextEditingController tagsController = TextEditingController();
  @override
  void initState() {
    BlocProvider.of<FirestoreBloc>(context)
        .add(GetReceipt(widget.referenceNumber));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go(
              '/receipt/${widget.referenceNumber}',
            );
          },
        ),
        title: Text('Receipt Details'),
      ),
      body:
          BlocBuilder<FirestoreBloc, FirestoreState>(builder: (context, state) {
        if (state is FirestoreReceiptLoaded) {
          tagsController.text = state.receipt!.receiptCategory.isEmpty
              ? 'None'
              : state.receipt!.receiptCategory;

          DateTime dateTime = DateTime.parse(
            state.receipt!.dateTimeCreated,
          );
          String formattedDate =
              DateFormat('E, d MMM yyyy HH:mm:ss').format(dateTime);

          String dateFormatted = DateFormat('MMMM d, yyyy').format(dateTime);

          int subTotal = 0;
          double VAT = 0;
          double Total;
          List<int> totals = [];

          for (final product in state.products) {
            var total = product.price * product.quantity;
            totals.add(total);
          }

          for (final total in totals) {
            subTotal = subTotal + total;
          }

          VAT = subTotal * 0.12;
          Total = VAT + subTotal;
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Color.fromRGBO(31, 29, 43, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        // height: MediaQuery.of(context).size.height * .85,
                        width: MediaQuery.of(context).size.width * .8,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Text(
                                  "VAT'S Marketing Corporation",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                height: 100,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(5),
                                        strokeWidth: 2,
                                        dashPattern: [5, 6],
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 20),
                                          child: Text(
                                            formattedDate,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Container(
                                              width: 70,
                                              height: 30,
                                              color: Colors.white,
                                              child: Center(
                                                child: Text(
                                                  "VAT'S",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Address',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      state.receipt!.address,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Divider(
                                  thickness: 1,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Operator',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    state.receipt!.POSoperator,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Customer Name',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    state.receipt!.customerName,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Payment Method',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    state.receipt!.paymentMethod,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Divider(
                                  thickness: 1,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Reference Number',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    state.receipt!.referenceNumber.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Divider(
                                  thickness: 1,
                                ),
                              ),
                              for (var product in state.products)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '@${product.price}x${product.quantity}',
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                109, 114, 120, 1),
                                            fontSize: 9,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${product.price * product.quantity} PHP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Subtotal',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '$subTotal PHP',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'VAT',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '$VAT PHP',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Divider(
                                  thickness: 1,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '$Total PHP',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "Thanks for fueling our passion. Drop by again, if your wallet isn't still sulking. You're always welcome here!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 9),
                                ),
                              ),
                              Image.asset('assets/images/Receipt_Logo.png'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.65,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reference Number',
                                    style: TextStyle(
                                      color: Color.fromRGBO(50, 50, 50, 1),
                                    ),
                                  ),
                                  TextField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                        hintText: state.receipt!.referenceNumber
                                            .toString()),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date',
                                    style: TextStyle(
                                        color: Color.fromRGBO(50, 50, 50, 1)),
                                  ),
                                  TextField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                        hintText: dateFormatted),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                        color: Color.fromRGBO(50, 50, 50, 1)),
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    style: TextStyle(
                                        color: Color.fromRGBO(50, 50, 50, 1),
                                        fontWeight: FontWeight.w700),
                                    controller: TextEditingController(
                                      text: '₱ ${Total.toString()}',
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Method of Payment',
                                    style: TextStyle(
                                        color: Color.fromRGBO(50, 50, 50, 1)),
                                  ),
                                  TextField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                        hintText: state.receipt!.paymentMethod),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tag',
                                    style: TextStyle(
                                        color: Color.fromRGBO(50, 50, 50, 1)),
                                  ),
                                  BlocBuilder<ReceiptdetailsCubit, bool>(
                                    builder: (contexts, states) {
                                      return TextFormField(
                                        readOnly: states,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(50, 50, 50, 1)),
                                        controller: tagsController,
                                        decoration: InputDecoration(
                                            suffixIconColor:
                                                Color.fromRGBO(57, 181, 74, 1),
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  if (states) {
                                                    contexts
                                                        .read<
                                                            ReceiptdetailsCubit>()
                                                        .changeMode();
                                                  } else {
                                                    BlocProvider.of<
                                                                FirestoreBloc>(
                                                            context)
                                                        .add(
                                                      ChangeProductTag(
                                                        state.receipt!
                                                            .referenceNumber,
                                                        tagsController.text
                                                            .trim(),
                                                      ),
                                                    );
                                                  }
                                                },
                                                icon: BlocProvider.of<
                                                                ReceiptdetailsCubit>(
                                                            context)
                                                        .state
                                                    ? Icon(Icons.edit)
                                                    : Icon(
                                                        Icons.save_rounded))),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                          Image.asset('assets/images/Receipt_Logo.png'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return Center(
          child: Text(
            "Loading...",
            style: TextStyle(color: Colors.black),
          ),
        );
      }),
    );
  }
}
