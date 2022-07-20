import 'package:flutter/widgets.dart' show BuildContext;
import 'package:testingbloc_course/dialogs/generic_dialog.dart';

Future<bool> showDeleteAccountDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete Account',
    content:
        'Are you sure  you want to deleteyour account? You cannot undo this operation! ',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete account': true,
    },
  ).then((value) => value ?? false);
}
