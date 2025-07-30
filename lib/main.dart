import "dart:io";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "appointments/appointments_view.dart";
import "contacts/contacts_view.dart";
import "notes/notes_view.dart";
import "tasks/tasks_view.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("## main(): FlutterBook Starting");
  Directory docsDir = await startMeUp();
  runApp(FlutterBook(docsDir: docsDir));
}

Future<Directory> startMeUp() async {
  return await getApplicationDocumentsDirectory();
}

class FlutterBook extends StatelessWidget {
  final Directory _docsDir;

  const FlutterBook({super.key, required Directory docsDir}) : _docsDir = docsDir;

  @override
  Widget build(BuildContext context) {
    print("## FlutterBook.build()");
    return MaterialApp(
        home : DefaultTabController(
            length : 4,
            child : Scaffold(
                appBar : AppBar(
                    title : Text("FlutterBook"),
                    bottom : TabBar(
                        tabs : [
                          Tab(icon : Icon(Icons.date_range), text : "Appointments"),
                          Tab(icon : Icon(Icons.contacts), text : "Contacts"),
                          Tab(icon : Icon(Icons.note), text : "Notes"),
                          Tab(icon : Icon(Icons.assignment_turned_in), text : "Tasks")
                        ])),
                body : TabBarView(
                    children : [
                      Appointments(docsDir: _docsDir),
                      ContactsView(docsDir: _docsDir),
                      NotesView(docsDir: _docsDir),
                      TasksView(docsDir: _docsDir)
                    ]))));
  }
}