import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tommy/services/auth/auth_service.dart';
import 'package:tommy/services/crud/note_service.dart';

class NewNotesView extends StatefulWidget {
  const NewNotesView({super.key});

  @override
  State<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<NewNotesView> {
  DatabaseNote? _note;
  late final NotesService
      _notesService; // for creating the object of notesService
  late final TextEditingController
      _textEditingController; // for controlling the text

  @override
  void initState() {
    // TODO: implement initState
    _notesService = NotesService();
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _textControllerListner() async {
    final note = _note;
    log("hi");
    log(note.toString());

    if (note == null) return;

    final text = _textEditingController.text;
    log(text + " i ");

    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setUpTextControllerListner() {
    _textEditingController.removeListener(_textControllerListner);
    _textEditingController.addListener(_textControllerListner);
   
  }

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
  
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;

    final email = currentUser.email!;
   
    final owner = await _notesService.getUser(email: email);
   
    final t = await _notesService.createNote(owner: owner);
 
    return t;
  }

// this is for the deleting purpose
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textEditingController.text;
    print(text);

    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
      ),
      body: FutureBuilder(
          future: createNewNote(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _note = snapshot.data;
                _setUpTextControllerListner();
                // TODO: Handle this case.
                return TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration:
                      const InputDecoration(hintText: "type your note here"),
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
