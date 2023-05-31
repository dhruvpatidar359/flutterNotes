import 'package:flutter/material.dart';
import 'package:tommy/utilites/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'You cannot share the note',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
