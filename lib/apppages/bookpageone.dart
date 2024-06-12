import 'package:contactbook_app/apppages/bookpagetwo.dart';
import 'package:contactbook_app/bloc_logic/contacts_bloc.dart';
import 'package:contactbook_app/coloursandtheme/colourstheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactsBloc()..add(FetchContacts()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Contact Book"),
          backgroundColor: AppColors.secondaryColor,
          elevation: 10,
          shadowColor: AppColors.shadowColor,
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.notifications),
            //   onPressed: () {
            //     // Define the action when the icon is pressed
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text('Notifications icon pressed'),
            //       ),
            //     );
            //   },
            // ),
            IconButton(
              icon: Icon(Icons.contact_page),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pageTwo()),
                ).then((val) {
                  if (val == true) {
                    context.read<ContactsBloc>().add(FetchContacts());
                  }
                });
              },
            ),
          ],
        ),
        body: BlocBuilder<ContactsBloc, ContactsState>(
          builder: (context, state) {
            if (state is ContactLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ContactLoaded) {
              return ListView.separated(
                itemCount: state.contacts.length,
                itemBuilder: (context, index) {
                  final contact = state.contacts[index];
                  final givenName = contact.givenName ?? 'Unknown';
                  final phoneNo =
                      (contact.phones != null && contact.phones!.isNotEmpty)
                          ? contact.phones![0].value ?? 'No Number'
                          : 'No Number';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.buttonColor,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/iconimage/boyimg.png',
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                    title: Text(givenName),
                    subtitle: Text(phoneNo),
                    trailing: IconButton(
                      icon: Icon(Icons.call),
                      onPressed: () async {
                        Uri dialnumber = Uri(scheme: 'tel', path: phoneNo);
                        await launchUrl(dialnumber);
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  height: 5,
                  thickness: 1,
                ),
              );
            } else if (state is ContactsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return Center(child: Text('No Contact Found'));
            }
          },
        ),
      ),
    );
  }
}

// primaryColor
// shadowColor
// clickColor
// secondaryColor
// buttonColor
