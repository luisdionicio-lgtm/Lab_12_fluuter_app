import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../services/app_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/carousels.dart';
import 'product_form.dart';
import 'profile_screen.dart';
import 'product_list.dart';

class WorkspaceScreen extends StatefulWidget {
  final AppStore store;
  final VoidCallback onLogout;
  const WorkspaceScreen({
    super.key,
    required this.store,
    required this.onLogout,
  });
  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  int page = 0;
  DateTime calendarDate = DateTime.now();
  String selectedCategory = 'Todos';
  final scaffold = GlobalKey<ScaffoldState>();
  final titles = ['Menú', 'Registrar productos', 'Listar productos', 'Perfil'];
  void navigate(int value) {
    selectedCategory = 'Todos';
    setState(() => page = value);
    scaffold.currentState?.closeDrawer();
  }

  Widget navigation(bool mobile) => Container(
    width: 244,
    color: surface,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 38),
              child: Brand(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12, bottom: 15),
              child: Text(
                'ESPACIO DE TRABAJO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: muted,
                ),
              ),
            ),
            for (final (index, icon) in [
              Icons.space_dashboard_outlined,
              Icons.add_box_outlined,
              Icons.inventory_2_outlined,
              Icons.person_outline_rounded,
            ].indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Material(
                  color: page == index ? mint : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 3,
                    ),
                    leading: Icon(
                      icon,
                      size: 21,
                      color: page == index ? forest : muted,
                    ),
                    title: Text(
                      titles[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: page == index
                            ? FontWeight.w800
                            : FontWeight.w500,
                        color: page == index ? forest : muted,
                      ),
                    ),
                    onTap: () => navigate(index),
                  ),
                ),
              ),
            const Spacer(),
            const Divider(),
            Material(
              color: Colors.transparent,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                leading: const Icon(
                  Icons.logout_rounded,
                  size: 20,
                  color: muted,
                ),
                title: const Text(
                  'Cerrar sesión',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
                onTap: widget.onLogout,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                'Órbita · Laboratorio 08 / 09',
                style: TextStyle(fontSize: 10, color: muted),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.store,
    builder: (context, _) => LayoutBuilder(
      builder: (context, c) {
        final desktop = c.maxWidth >= 1050;
        return Scaffold(
          key: scaffold,
          backgroundColor: [const Color(0xFF102D2C), coral, forest, mint][page],
          bottomNavigationBar: CupertinoTabBar(
            currentIndex: page,
            onTap: navigate,
            backgroundColor: surface,
            activeColor: forest,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.square_grid_2x2),
                label: 'Menú',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.add_circled),
                label: 'Registrar',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search),
                label: 'Productos',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                label: 'Perfil',
              ),
            ],
          ),
          drawer: desktop ? null : Drawer(child: navigation(true)),
          body: Row(
            children: [
              if (desktop) ...[
                navigation(false),
                const VerticalDivider(width: 1),
              ],
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(
                        horizontal: desktop ? 38 : 16,
                      ),
                      decoration: const BoxDecoration(
                        color: ink,
                        border: Border(bottom: BorderSide(color: line)),
                      ),
                      child: Row(
                        children: [
                          if (!desktop)
                            IconButton(
                              tooltip: 'Abrir menú',
                              onPressed: () =>
                                  scaffold.currentState!.openDrawer(),
                              icon: const Icon(
                                Icons.menu_rounded,
                                color: Colors.white,
                              ),
                            ),
                          if (desktop) ...[
                            const Text(
                              'Workspace',
                              style: TextStyle(fontSize: 12, color: muted),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Icon(
                                Icons.chevron_right,
                                size: 15,
                                color: muted,
                              ),
                            ),
                          ],
                          Expanded(
                            child: Text(
                              titles[page],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (c.maxWidth > 650)
                            const Padding(
                              padding: EdgeInsets.only(right: 24),
                              child: Tag('Entorno demo'),
                            ),
                          InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () => navigate(3),
                            child: Row(
                              children: [
                                const ProfilePhoto(),
                                if (c.maxWidth > 650) ...[
                                  const SizedBox(width: 11),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.store.name,
                                        style: const TextStyle(
                                          color: ink,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const Text(
                                        'Administrador demo',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        key: ValueKey('page-scroll-$page'),
                        padding: EdgeInsets.all(desktop ? 38 : 16),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1280),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.store.storageWarning)
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      'No se pudieron leer algunos datos locales. Se muestran los datos de ejemplo.',
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                  ),
                                // El estado del catálogo vive por encima de las pantallas: navegar no
                                // pierde productos. ValueKey reinicia formularios al cambiar de tarea.
                                KeyedSubtree(
                                  key: ValueKey(page),
                                  child: switch (page) {
                                    1 => ProductForm(
                                      store: widget.store,
                                      onSaved: () => navigate(2),
                                    ),
                                    2 => ProductList(
                                      initialCategory: selectedCategory,
                                      store: widget.store,
                                      onRegister: () => navigate(1),
                                    ),
                                    3 => ProfileScreen(store: widget.store),
                                    _ => home(context),
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
  Widget home(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'MENÚ',
        style: TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          height: 1,
        ),
      ),
      const SizedBox(height: 20),
      BoldPanel(
        color: ink,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VALOR DEL CATÁLOGO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: mint,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'S/ ${(widget.store.products.fold<int>(0, (total, p) => total + p.cents) / 100).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: mint,
                      fontWeight: FontWeight.w900,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${widget.store.products.length} productos',
              style: const TextStyle(color: cyan, fontSize: 11),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 14,
        childAspectRatio: 1,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          menuTile(
            'Registrar\nproductos',
            CupertinoIcons.add_circled,
            mint,
            () => navigate(1),
          ),
          menuTile(
            'Listar\nproductos',
            CupertinoIcons.list_bullet,
            coral,
            () => navigate(2),
          ),
          menuTile(
            'Perfil',
            CupertinoIcons.person,
            forest,
            () => navigate(3),
            light: true,
          ),
          menuTile(
            'Logout',
            CupertinoIcons.square_arrow_right,
            const Color(0xFFFFC400),
            widget.onLogout,
          ),
        ],
      ),
      const SizedBox(height: 24),
      SizedBox(
        width: double.infinity,
        child: CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          color: surface,
          onPressed: () => showCupertinoModalPopup<void>(
            context: context,
            builder: (context) {
              DateTime selected = calendarDate;
              return Container(
                height: 340,
                color: CupertinoColors.systemBackground,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 18),
                          child: Text(
                            'Calendario',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        CupertinoButton(
                          onPressed: () {
                            setState(() => calendarDate = selected);
                            Navigator.pop(context);
                          },
                          child: const Text('Listo'),
                        ),
                      ],
                    ),
                    Expanded(
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: selected,
                        onDateTimeChanged: (value) => selected = value,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.calendar, color: forest, size: 20),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  'Calendario · ${calendarDate.day.toString().padLeft(2, '0')}/${calendarDate.month.toString().padLeft(2, '0')}/${calendarDate.year}',
                  style: const TextStyle(color: forest, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 30),
      const Text(
        'EN TU ÓRBITA',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 22,
        ),
      ),
      const SizedBox(height: 14),
      DiscoveryCarousel(
        onExplore: (category) => setState(() {
          selectedCategory = category;
          page = 2;
        }),
      ),
      const SizedBox(height: 20),
      ProductCarousel(
        products: widget.store.products,
        onView: () => navigate(2),
      ),
    ],
  );
  Widget menuTile(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool light = false,
  }) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: BoldPanel(
        color: color,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: light ? Colors.white : ink, size: 24),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title,
                    softWrap: false,
                    style: TextStyle(
                      color: light ? Colors.white : ink,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 7),
            Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: light ? Colors.white : ink,
            ),
          ],
        ),
      ),
    ),
  );
}
