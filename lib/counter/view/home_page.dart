import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:posclient/counter/cubit/hompage_cubit.dart';
import 'package:posclient/counter/firestore_service/firestore_bloc.dart';
import 'package:posclient/counter/firestore_service/firestore_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomepageCubit(),
        ),
        BlocProvider(create: (_) => FirestoreBloc(FirestoreService()))
      ],
      child: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      context.go('/');
    }
    BlocProvider.of<FirestoreBloc>(context).add(GetUserReceipts(user!.email!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 350,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color.fromRGBO(57, 181, 74, 1),
                    Color.fromRGBO(136, 219, 147, 1),
                    Color.fromRGBO(176, 239, 185, 1),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 27),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<FirestoreBloc, FirestoreState>(
                      builder: (context, state) {
                        if (state is FirestoreUserReceiptsLoaded) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Welcome Back, \n${state.user!.fullName}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 32,
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 142,
                      width: 321,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "TODAY'S EXPENDITURE",
                            style: TextStyle(
                              color: Color.fromRGBO(31, 29, 43, 1),
                              fontSize: 10,
                            ),
                          ),
                          BlocBuilder<FirestoreBloc, FirestoreState>(
                            builder: (context, state) {
                              if (state is FirestoreUserReceiptsLoaded) {
                                double totalExpenditure = 0.0;
                                for (final data in state.userReceipts) {
                                  totalExpenditure =
                                      data.total + totalExpenditure;
                                }
                                return Text(
                                  '₱ ${totalExpenditure.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 34),
                                );
                              } else {
                                return Text(
                                  "0.00",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 34),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 10,
                      width: 293,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(34, 213, 102, 1),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6))),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Receipts",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(50, 50, 50, 1),
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<FirestoreBloc, FirestoreState>(
              builder: (context, state) {
                if (state is FirestoreUserReceiptsLoaded) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 170,
                    child: ListView.builder(
                      itemCount: state.userReceipts.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(
                          state.userReceipts[index].dateTimeCreated,
                        );
                        String formattedDate =
                            DateFormat('MMM d').format(dateTime);
                        return GestureDetector(
                          onTap: () {
                            context.go(
                              '/receipt/${state.userReceipts[index].referenceNumber}',
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0.5,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: 120,
                              height: 138,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          formattedDate,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  50, 50, 50, 1)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "₱ ${state.userReceipts[index].total}",
                                        style: TextStyle(
                                          color: Color.fromRGBO(50, 50, 50, 1),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                bottom: 10),
                                            child: Text(
                                              '${state.userReceipts[index].referenceNumber}',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      50, 50, 50, 1)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Text(
                    'Loading Receipts',
                    style: TextStyle(color: Colors.black),
                  );
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
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
                onPressed: () => context.go('/home'),
                icon: Icon(Icons.home),
              ),
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
