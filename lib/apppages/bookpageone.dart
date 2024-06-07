import 'package:contactbook_app/apppages/bookpagetwo.dart';
import 'package:contactbook_app/coloursandtheme/colourstheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class PageOne extends StatefulWidget {
  const PageOne({super.key});

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  List<Contact> contacts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getContactPremission();
  }

  //asking for contacts permission
  void getContactPremission() async {
    if (await Permission.contacts.isGranted) {
      fetchContacts();
    } else {
      await Permission.contacts.request();
      if (await Permission.contacts.isGranted) {
        fetchContacts();
      }
    }
  }

  //fetching the contacts after permission granted
  void fetchContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    setState(() {
      contacts = _contacts;
      isLoading = false;
    });
  }

  //saving and refreshing the new contact got by the 2nd page
  // void saveContact(Contact contact) async {
  //   await ContactsService.addContact(contact);
  //   fetchContacts();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Contact Book"),
        backgroundColor: AppColors.secondaryColor,
        elevation: 10,
        shadowColor: AppColors.shadowColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Define the action when the icon is pressed
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Notifications icon pressed'),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.contact_page),
            onPressed: () async {
              final result = Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pageTwo()),
              );
              if (result == true) {
                fetchContacts();
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(1, 3),
                  ),
                ],
                color: Colors.blue
                    .shade50, // Example color, replace with AppColors.primaryColor if defined
                borderRadius: BorderRadius.circular(25), // Add rounded corners
              ),
              //color: AppColors.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                //checking for any potential Null value
                                final contact = contacts[index];
                                final givenName =
                                    contact.givenName ?? 'Unknown Number';

                                //Ensure the contact has a phone number != Null
                                final phoneNo = (contact.phones != null &&
                                        contact.phones!.isNotEmpty)
                                    ? contact.phones![0].value ?? 'No number'
                                    : 'No Number';

                                //calling features implementation
                                Uri dialnumber =
                                    Uri(scheme: 'tel', path: phoneNo);

                                //calling thorugh numpad
                                callNumber() async {
                                  await launchUrl(dialnumber);
                                }

                                //calling through contact book
                                directCall() async {
                                  await FlutterPhoneDirectCaller.callNumber(
                                      phoneNo);
                                }

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
                                  title: Text(
                                    givenName,
                                    maxLines: 1,
                                  ),
                                  subtitle: Text(
                                    phoneNo,
                                  ),
                                  trailing: IconButton(
                                    iconSize: 35,
                                    icon: const Icon(Icons.call),
                                    onPressed: directCall,
                                  ),
                                );
                              },
                              itemCount: contacts.length,
                              separatorBuilder: (context, index) {
                                return Divider(
                                  height: 5,
                                  thickness: 1,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      right: 10,
                      child: FloatingActionButton(
                        onPressed: () {},
                        child: Icon(Icons.dialpad_rounded),
                      ),
                    ),
                  ],
                ),
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
