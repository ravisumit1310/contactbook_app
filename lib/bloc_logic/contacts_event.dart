part of 'contacts_bloc.dart';

@immutable
sealed class ContactsEvent {}

class FetchContacts extends ContactsEvent {}

class SaveContacts extends ContactsEvent {
  final Contact contact;

  SaveContacts(this.contact);
}

class DeleteContacts extends ContactsEvent {
  final Contact contact;

  DeleteContacts(this.contact);
}
