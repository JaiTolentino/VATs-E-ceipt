import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:posclient/counter/cubit/qrcode_cubit.dart';
import 'package:posclient/counter/firestore_service/firestore_bloc.dart';
import 'package:posclient/counter/firestore_service/firestore_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatelessWidget {
  const QrCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => QrcodeCubit(),
        ),
        BlocProvider(
            create: (context) => FirestoreBloc(
                  FirestoreService(),
                )),
      ],
      child: QrCodeView(),
    );
  }
}

class QrCodeView extends StatefulWidget {
  const QrCodeView({super.key});

  @override
  State<QrCodeView> createState() => _QrCodeViewState();
}

class _QrCodeViewState extends State<QrCodeView> {
  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      context.go('/');
    }
    BlocProvider.of<FirestoreBloc>(context).add(GetUser(user!.email!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(31, 29, 43, 1),
        leadingWidth: 150,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                context.go('/home');
              },
              color: Colors.white,
            ),
            Text(
              "Homepage",
              style: TextStyle(color: Colors.white, fontSize: 14),
            )
          ],
        ),
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Scan Qr Code",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700),
              ),
              Row(
                children: [
                  Text(
                    "Homepage",
                    style: TextStyle(
                        color: Color.fromRGBO(31, 29, 43, 1), fontSize: 14),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.info_rounded),
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: BlocBuilder<FirestoreBloc, FirestoreState>(
        builder: (context, state) {
          if (state is FirestoreUserLoaded) {
            final jsonString = {
              "fullName": "${state.user!.fullName}",
              "email": "${state.user!.email}"
            };
            final body = json.encode(jsonString);
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Color.fromRGBO(77, 201, 97, .52),
              child: Padding(
                padding: EdgeInsets.all(27),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Show one of these codes to the cashier of any participating merchant to get your receipt",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            margin: EdgeInsetsDirectional.all(5),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Color.fromRGBO(77, 201, 97, 1),
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: QrImageView(
                              data: body,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 300,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(11)),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              border: Border.all(
                                  color: Color.fromRGBO(77, 201, 97, 1),
                                  width: 3),
                            ),
                            child: Center(
                              child: Text(
                                "Your voucher will be redeemed immediately",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 80,
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,
                                ),
                                child: Image.network(
                                  state.file!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                state.user!.fullName,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                "Loading...",
                style: TextStyle(color: Colors.black),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        color: Color.fromRGBO(31, 29, 43, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.qr_code,
                color: Color.fromRGBO(77, 201, 97, 1),
              ),
            ),
            Text(
              "QR Code",
              style:
                  TextStyle(fontSize: 8, color: Color.fromRGBO(77, 201, 97, 1)),
            )
          ],
        ),
      ),
    );
  }
}
