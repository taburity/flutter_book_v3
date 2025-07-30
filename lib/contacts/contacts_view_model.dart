import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'contact_data.dart';
import 'contacts_model.dart';

class ContactsViewModel extends ChangeNotifier {
  int _stackIndex = 0;
  int get stackIndex => _stackIndex;
  List<ContactData> _contacts = [];
  List<ContactData> get contacts => _contacts;
  ContactData? entityBeingEdited;
  String? chosenDate;
  final Directory docsDir;

  ContactsViewModel(this.docsDir);

  Future<void> loadContacts() async {
    _contacts = await ContactsModel.db.getAll();
    notifyListeners();
  }

  void startEditing({ContactData? contact}) {
    entityBeingEdited = contact ?? ContactData(name: '');
    notifyListeners();
  }

  void setChosenDate(String? date) {
    chosenDate = date;
    notifyListeners();
  }

  void setStackIndex(int index) {
    _stackIndex = index;
    notifyListeners();
  }

  Future<void> save() async {
    if (entityBeingEdited == null) return;
    if (entityBeingEdited!.id == null) {
      var id = await ContactsModel.db.create(entityBeingEdited!);
      _renameTempAvatar(id);
    } else {
      await ContactsModel.db.update(entityBeingEdited!);
      _renameTempAvatar(entityBeingEdited!.id!);
    }
    await loadContacts();
    setStackIndex(0);
  }

  Future<void> delete(int id) async {
    final avatarFile = File(join(docsDir.path, id.toString()));
    if (avatarFile.existsSync()) avatarFile.deleteSync();
    await ContactsModel.db.delete(id);
    await loadContacts();
  }

  void _renameTempAvatar(int id) {
    final avatarFile = File(join(docsDir.path, "avatar"));
    if (avatarFile.existsSync()) {
      avatarFile.renameSync(join(docsDir.path, id.toString()));
    }
  }

  void triggerRebuild() {
    notifyListeners();
  }
}
