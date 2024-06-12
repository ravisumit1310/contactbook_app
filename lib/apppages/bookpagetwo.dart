import 'package:contactbook_app/bloc_logic/contacts_bloc.dart';
import 'package:contactbook_app/coloursandtheme/colourstheme.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class pageTwo extends StatefulWidget {
  const pageTwo({super.key});

  @override
  State<pageTwo> createState() => _pageTwoState();
}

class _pageTwoState extends State<pageTwo> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;
  String? _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Contact Book"),
        backgroundColor: AppColors.secondaryColor,
        elevation: 10,
        shadowColor: AppColors.shadowColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
          // IconButton(
          //   icon: Icon(Icons.save),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => pageTwo()),
          //     );
          //     // Define the action when the icon is pressed
          //     // ScaffoldMessenger.of(context).showSnackBar(
          //     //   SnackBar(
          //     //     content: Text('Settings icon pressed'),
          //     //   ),
          //     // );
          //   },
          // ),
        ],
      ),
      body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(1, 3),
              ),
            ],
            color: Colors.blue.shade50,
            // Example color, replace with AppColors.primaryColor if defined
            borderRadius: BorderRadius.circular(25), // Add rounded corners
          ),
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 6,
                      ),
                      CircleAvatar(
                        child: Image.asset(
                          'assets/iconimage/boyimg.png',
                          fit: BoxFit.cover,
                          height: 150,
                          width: 150,
                        ),
                        radius: 85,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          contentPadding: EdgeInsets.all(6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onSaved: (value) {
                          _firstName = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter first name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          contentPadding: EdgeInsets.all(6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onSaved: (value) {
                          _lastName = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Empty last name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          contentPadding: EdgeInsets.all(6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        onSaved: (value) {
                          _phoneNumber = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            Contact newContact = Contact(
                              givenName: _firstName,
                              familyName: _lastName,
                              phones: [
                                Item(label: 'mobile', value: _phoneNumber)
                              ],
                            );
                            context
                                .read<ContactsBloc>()
                                .add(SaveContacts(newContact));
                            Navigator.pop(context, true);
                          }
                        },
                        child: Text(
                          'Save',
                          style: GoogleFonts.playfairDisplay(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          elevation: 3,
                          textStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
