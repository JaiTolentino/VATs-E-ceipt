import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posclient/counter/cubit/resetpassword_cubit.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: ResetPasswordView(),
    );
  }
}

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 29, 43, 1),
      body: Padding(
          padding: EdgeInsets.only(right: 27, left: 27),
          child: Column(children: [
            const SizedBox(
              height: 70,
            ),
            Image.asset('assets/images/Login_Logo.png'),
            SizedBox(
              height: 65,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Email address'),
              ],
            ),
            const TextField(
              decoration: InputDecoration(
                  hintText: 'Enter Email',
                  hintStyle: TextStyle(
                      color: Colors.white38, fontWeight: FontWeight.w400)),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Password'),
              ],
            ),
            BlocBuilder<ResetPasswordCubit, bool>(
              builder: (context, state) {
                return TextField(
                  obscureText: state,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () =>
                            context.read<ResetPasswordCubit>().changeValue(),
                        icon: const Icon(Icons.remove_red_eye),
                      ),
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(
                          color: Colors.white38, fontWeight: FontWeight.w400)),
                );
              },
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Password'),
              ],
            ),
            BlocBuilder<ResetPasswordCubit, bool>(
              builder: (context, state) {
                return TextField(
                  obscureText: state,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () =>
                            context.read<ResetPasswordCubit>().changeValue(),
                        icon: const Icon(Icons.remove_red_eye),
                      ),
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(
                          color: Colors.white38, fontWeight: FontWeight.w400)),
                );
              },
            ),
            SizedBox(
              height: 75,
            ),
            TextButton(
              onPressed: () {
                const snackBar = SnackBar(content: Text('Login'));

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  backgroundColor: Color.fromRGBO(57, 181, 74, 1),
                  foregroundColor: Colors.black,
                  fixedSize: Size(320, 50)),
              child: const Text(
                'Reset Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ])),
    );
  }
}
