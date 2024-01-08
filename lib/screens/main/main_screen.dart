import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/list_user/list_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../laporan_masuk/laporan_masuk.dart';
import '../lokasi_kejadian/lokasi_kejadian.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var index = 0;
  Widget page = LaporanMasukScreen();

  void onTapDrawer(int i) {
    setState(() {
      if (i == 0) {
        page = LaporanMasukScreen();
      }
      // else if (i == 1) {
      //   page = LaporanKeluarScreen();
      // }
      else if (i == 1) {
        page = LokasiKejadianScreen();
      } else if (i == 2) {
        page = ListUserScreen();
      }

      index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(index: index, onTapDrawer: onTapDrawer),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(
                  index: index,
                  onTapDrawer: onTapDrawer,
                ),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: page,
            ),
          ],
        ),
      ),
    );
  }
}
