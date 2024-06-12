import 'package:contactbook_app/apppages/bookpageone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_logic/contacts_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContactsBloc>(
          create: (context) => ContactsBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Contact App',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        home: PageOne(),
      ),
    );
  }
}
