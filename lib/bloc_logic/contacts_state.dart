part of 'contacts_bloc.dart';

@immutable
sealed class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactLoading extends ContactsState {}

class ContactsSaving extends ContactsState {}

class ContactsSaved extends ContactsState {}

class ContactsDeleting extends ContactsState {}

class ContactDeleted extends ContactsState {}

class ContactLoaded extends ContactsState {
  final List<Contact> contacts;

  ContactLoaded(this.contacts);
}

class ContactsError extends ContactsState {
  final String message;

  ContactsError(this.message);
}
