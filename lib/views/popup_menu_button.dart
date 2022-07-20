import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/bloc/app_bloc.dart';
import 'package:testingbloc_course/bloc/app_event.dart';
import 'package:testingbloc_course/dialogs/delete_account_dialog.dart';
import 'package:testingbloc_course/dialogs/logout_dialog.dart';

enum MenuAction { logout, deleteAccount }

class MainPopUpMenuButton extends StatelessWidget {
  const MainPopUpMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(onSelected: (value) async {
      switch (value) {
        case MenuAction.logout:
          final shouldLogout = await showLogoutDialog(context);
          if (shouldLogout) {
            context.read<AppBloc>().add(
                  const AppEventLogOut(),
                );
          }
          break;
        case MenuAction.deleteAccount:
          final shouldDelete = await showDeleteAccountDialog(context);
          if (shouldDelete) {
            context.read<AppBloc>().add(
                  const AppEventDeleteAccount(),
                );
          }
          break;
      }
    }, itemBuilder: (context) {
      return [
        const PopupMenuItem<MenuAction>(
          value: MenuAction.logout,
          child: Text('Log out'),
        ),
        const PopupMenuItem<MenuAction>(
          value: MenuAction.deleteAccount,
          child: Text('Delete account'),
        ),
      ];
    });
  }
}
