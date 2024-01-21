import 'package:admin/values/position_utils.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final int index;
  final void Function(int i) onTapDrawer;
  const SideMenu({Key? key, this.index = 0, required this.onTapDrawer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            // child: Image.asset("assets/images/logo.png"),
            child: Center(
              child: Text(
                "Sistem Pelaporan",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          DrawerListTile(
            title: "Laporan",
            svgSrc: Icons.bookmark,
            press: () {
              onTapDrawer(0);
            },
            selected: index == 0,
          ),
          // DrawerListTile(
          //   title: "Laporan Keluar",
          //   svgSrc: "assets/icons/menu_tran.svg",
          //   press: () {
          //     onTapDrawer(1);
          //   },
          //   selected: index == 1,
          // ),
          DrawerListTile(
            title: "Lokasi Kejadian",
            svgSrc: Icons.location_on,
            press: () {
              onTapDrawer(1);
            },
            selected: index == 1,
          ),
          DrawerListTile(
            title: "User",
            svgSrc: Icons.people,
            press: () {
              onTapDrawer(2);
            },
            selected: index == 2,
          ),
          // DrawerListTile(
          //   title: "Logout",
          //   svgSrc: Icons.logout,
          //   press: () {
          //     onTapDrawer(3);
          //   },
          //   selected: index == 3,
          // ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData svgSrc;
  final bool selected;
  final VoidCallback press;

  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(svgSrc, color: Colors.grey,),
      // SvgPicture.asset(
      //   svgSrc,
      //   colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
      //   height: 16,
      // ),
      title: Row(
        children: [
          H(16),
          Text(
            title,
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
      selected: selected,
    );
  }
}
