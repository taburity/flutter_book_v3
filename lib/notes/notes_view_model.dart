import 'package:flutter/material.dart';
import '../notes/note_data.dart';
import 'notes_model.dart';

class NotesViewModel extends ChangeNotifier {
  int _stackIndex = 0;
  int get stackIndex => _stackIndex;
  List<NoteData> _notes = [];
  List<NoteData> get notes => _notes;
  NoteData? entityBeingEdited;
  String color = '';

  Future<void> loadNotes() async {
    _notes = await NotesModel.db.getAll();
    notifyListeners();
  }
  void startEditing({NoteData? note}) {
    entityBeingEdited = note ?? NoteData(title: '', content: '', color: '');
    color = entityBeingEdited!.color;
    notifyListeners();
  }
  void setColor(String newColor) {
    color = newColor;
    notifyListeners();
  }
  void setStackIndex(int index) {
    _stackIndex = index;
    notifyListeners();
  }
  Future<void> save() async {
    if (entityBeingEdited == null) return;
    entityBeingEdited!.color = color;
    if (entityBeingEdited!.id == null) {
      await NotesModel.db.create(entityBeingEdited!);
    } else {
      await NotesModel.db.update(entityBeingEdited!);
    }
    await loadNotes();
    setStackIndex(0);
  }
  Future<void> delete(int id) async {
    await NotesModel.db.delete(id);
    await loadNotes();
  }
}
