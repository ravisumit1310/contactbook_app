import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc() : super(ContactsInitial()) {
    on<FetchContacts>((event, emit) async {
      emit(ContactLoading());
      final newState = await fetchContacts();
      emit(newState);
    });

    on<SaveContacts>((event, emit) async {
      try {
        await ContactsService.addContact(event.contact);
        add(FetchContacts());
      } catch (e) {
        emit(ContactsError(e.toString()));
      }
    });

    on<DeleteContacts>((event, emit) async {
      emit(ContactsDeleting());
      final newState = await deleteContact(event.contact);
      emit(newState);
    });
  }

  Future<ContactsState> fetchContacts() async {
    try {
      if (await Permission.contacts.isGranted) {
        List<Contact> contacts = (await ContactsService.getContacts()).toList();
        return ContactLoaded(contacts);
      } else {
        await Permission.contacts.request();
        if (await Permission.contacts.isGranted) {
          List<Contact> contacts =
              (await ContactsService.getContacts()).toList();
          return ContactLoaded(contacts);
        } else {
          return ContactsError("Permission denied");
        }
      }
    } catch (e) {
      return ContactsError(e.toString());
    }
  }

  Future<ContactsState> saveContacts(Contact contact) async {
    try {
      if (await Permission.contacts.isGranted) {
        await ContactsService.addContact(contact);
        return ContactsSaved();
      } else {
        return ContactsError("Permission Denied");
      }
    } catch (e) {
      return ContactsError(e.toString());
    }
  }

  Future<ContactsState> deleteContact(Contact contact) async {
    try {
      if (await Permission.contacts.isGranted) {
        await ContactsService.deleteContact(contact);
        return ContactsDeleting();
      } else {
        await Permission.contacts.request();
        if (await Permission.contacts.isGranted) {
          await ContactsService.deleteContact(contact);
          return ContactDeleted();
        } else {
          return ContactsError("Permission denied");
        }
      }
    } catch (e) {
      return ContactsError(e.toString());
    }
  }
}
