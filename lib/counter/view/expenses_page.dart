import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:posclient/counter/cubit/expenses_cubit.dart';
import 'package:posclient/counter/firestore_service/firestore_bloc.dart';
import 'package:posclient/counter/firestore_service/firestore_service.dart';
import 'package:posclient/counter/model/product_model.dart';
import 'package:posclient/counter/model/receipt_model.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ExpensesCubit(),
          child: ExpensesView(),
        ),
        BlocProvider(create: (context) => FirestoreBloc(FirestoreService()))
      ],
      child: ExpensesView(),
    );
  }
}

class ExpensesView extends StatefulWidget {
  const ExpensesView({super.key});

  @override
  State<ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {
  final user = FirebaseAuth.instance.currentUser;
  final searchController = TextEditingController();

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      context.go('/');
    }
    BlocProvider.of<FirestoreBloc>(context).add(
      GetUserReceipts(user!.email!),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextField(
                    controller: searchController,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          BlocProvider.of<FirestoreBloc>(context).add(
                              GetUserReceiptsUpdate(
                                  user!.email!, searchController.text));
                        },
                      ),
                      fillColor: Colors.black,
                      hintStyle: TextStyle(wordSpacing: 20),
                      hintText: "Search",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Filter by tag:',
                        style: TextStyle(color: Colors.black),
                      ),
                      BlocBuilder<FirestoreBloc, FirestoreState>(
                        builder: (context, state) {
                          Set<String> uniqueCategories = {};
                          List<DropdownMenuItem<String>> dropdownData = [];

                          if (state is FirestoreUserReceiptsLoaded) {
                            for (var i = 0;
                                i < state.userReceipts.length;
                                i++) {
                              String category =
                                  state.userReceipts[i].receiptCategory;
                              if (category == '') {
                                category = 'No Tag';
                              }
                              if (uniqueCategories.add(category)) {
                                dropdownData.add(
                                  DropdownMenuItem(
                                    child: Text(category),
                                    value:
                                        state.userReceipts[i].receiptCategory,
                                  ),
                                );
                              }
                            }
                            return DropdownButton(
                              value: context.select((ExpensesCubit cubit) =>
                                          cubit.state) ==
                                      ''
                                  ? dropdownData[0].value
                                  : context.select(
                                      (ExpensesCubit cubit) => cubit.state),
                              items: dropdownData,
                              onChanged: (value) {
                                BlocProvider.of<FirestoreBloc>(context).add(
                                    GetUserReceiptsUpdateTag(user!.email!,
                                        value!.toString().trim()));
                                context
                                    .read<ExpensesCubit>()
                                    .changeState(value.toString());
                              },
                            );
                          } else if (state
                              is FirestoreUserReceiptsUpdatedLoaded) {
                            for (var i = 0;
                                i < state.userReceipts.length;
                                i++) {
                              String category =
                                  state.userReceipts[i].receiptCategory;
                              if (category == '') {
                                category = 'No Tag';
                              }
                              if (uniqueCategories.add(category)) {
                                dropdownData.add(
                                  DropdownMenuItem(
                                    child: Text(category),
                                    value:
                                        state.userReceipts[i].receiptCategory,
                                  ),
                                );
                              }
                            }
                            return DropdownButton(
                              value: context.select((ExpensesCubit cubit) =>
                                          cubit.state) ==
                                      ''
                                  ? dropdownData[0].value
                                  : context.select(
                                      (ExpensesCubit cubit) => cubit.state),
                              items: dropdownData,
                              onChanged: (value) {
                                BlocProvider.of<FirestoreBloc>(context).add(
                                    GetUserReceiptsUpdateTag(user!.email!,
                                        value!.toString().trim()));
                                context
                                    .read<ExpensesCubit>()
                                    .changeState(value.toString());
                              },
                            );
                          } else {
                            return Text(
                              'Loading',
                              style: TextStyle(color: Colors.black),
                            );
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
              BlocBuilder<FirestoreBloc, FirestoreState>(
                builder: (context, state) {
                  if (state is FirestoreUserReceiptsLoaded) {
                    if (state.userReceipts.length > 0) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: state.userReceipts.length,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(
                              state.userReceipts[index].dateTimeCreated,
                            );
                            String formattedDate =
                                DateFormat('MMM d').format(dateTime);
                            return Column(
                              children: [
                                Container(
                                  width: 350,
                                  child: Text(
                                    formattedDate,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // List<ProductModel> products = [
                                    //   ProductModel(0001, 'Pirelli', 550, 2),
                                    //   ProductModel(0002, 'Michellin', 950, 1),
                                    // ];
                                    // BlocProvider.of<FirestoreBloc>(context).add(
                                    //   AddReceipt(
                                    //     ReceiptModel(
                                    //       '',
                                    //       '',
                                    //       20240005,
                                    //       4000,
                                    //       60,
                                    //       4060,
                                    //       'zara',
                                    //       DateTime.now().toLocal().toString(),
                                    //       '',
                                    //       'cash',
                                    //       'no tag',
                                    //       products,
                                    //     ),
                                    //   ),
                                    // );
                                    context.go(
                                      '/receipt/${state.userReceipts[index].referenceNumber}',
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    elevation: 5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset(
                                              'assets/images/DefaultReceiptImage.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        // Icon(
                                        //   Icons.image,
                                        //   size: 80,
                                        // ),
                                        Container(
                                          width: 270,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 10, top: 10),
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 3,
                                                                bottom: 3,
                                                                right: 8,
                                                                left: 8),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                            color:
                                                                Color.fromRGBO(
                                                                    57,
                                                                    181,
                                                                    74,
                                                                    1),
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            state
                                                                    .userReceipts[
                                                                        index]
                                                                    .receiptCategory
                                                                    .isEmpty
                                                                ? 'No Tag'
                                                                : state
                                                                    .userReceipts[
                                                                        index]
                                                                    .receiptCategory,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        57,
                                                                        181,
                                                                        74,
                                                                        1),
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            state
                                                                .userReceipts[
                                                                    index]
                                                                .referenceNumber
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 10),
                                                          child: Text(
                                                            '₱ ' +
                                                                state
                                                                    .userReceipts[
                                                                        index]
                                                                    .total
                                                                    .toString(),
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No expenses yet',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                        ),
                      );
                    }
                  } else if (state is FirestoreUserReceiptsUpdatedLoaded) {
                    print(state.userReceipts.length);
                    if (state.userReceipts.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: state.userReceipts.length,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(
                              state.userReceipts[index].dateTimeCreated,
                            );
                            String formattedDate =
                                DateFormat('MMM d').format(dateTime);
                            return Column(
                              children: [
                                Container(
                                  width: 350,
                                  child: Text(
                                    formattedDate,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // List<ProductModel> products = [
                                    //   ProductModel(0001, 'Pirelli', 550, 2),
                                    //   ProductModel(0002, 'Michellin', 950, 1),
                                    // ];
                                    // BlocProvider.of<FirestoreBloc>(context).add(
                                    //   AddReceipt(
                                    //     ReceiptModel(
                                    //       '',
                                    //       '',
                                    //       20240005,
                                    //       4000,
                                    //       60,
                                    //       4060,
                                    //       'zara',
                                    //       DateTime.now().toLocal().toString(),
                                    //       '',
                                    //       'cash',
                                    //       'no tag',
                                    //       products,
                                    //     ),
                                    //   ),
                                    // );
                                    context.go(
                                      '/receipt/${state.userReceipts[index].referenceNumber}',
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    elevation: 5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset(
                                              'assets/images/DefaultReceiptImage.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 270,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 10, top: 10),
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 3,
                                                                bottom: 3,
                                                                right: 8,
                                                                left: 8),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                            color:
                                                                Color.fromRGBO(
                                                                    57,
                                                                    181,
                                                                    74,
                                                                    1),
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            state
                                                                    .userReceipts[
                                                                        index]
                                                                    .receiptCategory
                                                                    .isEmpty
                                                                ? 'No Tag'
                                                                : state
                                                                    .userReceipts[
                                                                        index]
                                                                    .receiptCategory,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        57,
                                                                        181,
                                                                        74,
                                                                        1),
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            state
                                                                .userReceipts[
                                                                    index]
                                                                .referenceNumber
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 10),
                                                          child: Text(
                                                            '₱ ' +
                                                                state
                                                                    .userReceipts[
                                                                        index]
                                                                    .total
                                                                    .toString(),
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No expenses yet',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                        ),
                      );
                    }
                  }
                  return Center(
                    child: Text(
                      'No expenses yet',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color.fromRGBO(57, 181, 74, 1),
          unselectedLabelStyle:
              const TextStyle(color: Color.fromRGBO(130, 130, 130, 1)),
          showUnselectedLabels: true,
          unselectedItemColor: Color.fromRGBO(130, 130, 130, 1),
          backgroundColor: const Color.fromRGBO(31, 29, 43, 1),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () => context.go('/home'), icon: Icon(Icons.home)),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: IconButton(
                  icon: Icon(Icons.qr_code),
                  onPressed: () => context.go('/qr'),
                ),
                label: "QR Code"),
            BottomNavigationBarItem(
                icon: IconButton(
                  icon: Icon(Icons.receipt),
                  onPressed: () => context.go('/expenses'),
                ),
                label: "Expenses"),
            BottomNavigationBarItem(
                icon: IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () => context.go('/account'),
                ),
                label: "Account"),
          ],
        ),
      ),
    );
  }
}
