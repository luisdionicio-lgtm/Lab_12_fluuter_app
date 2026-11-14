import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../services/app_store.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class ProductList extends StatefulWidget {
  final AppStore store;
  final VoidCallback onRegister;
  final String initialCategory;
  const ProductList({
    super.key,
    required this.store,
    required this.onRegister,
    this.initialCategory = 'Todos',
  });
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final search = TextEditingController();
  late String category;
  String sort = 'Catálogo';
  @override
  void initState() {
    super.initState();
    category = widget.initialCategory;
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = search.text.trim().toLowerCase();
    final products = widget.store.products
        .where(
          (p) =>
              (category == 'Todos' || category == p.category) &&
              (p.name.toLowerCase().contains(q) ||
                  p.description.toLowerCase().contains(q) ||
                  p.id.toLowerCase().contains(q)),
        )
        .toList();
    if (sort == 'Menor precio') {
      products.sort((a, b) => a.cents.compareTo(b.cents));
    }
    if (sort == 'Mayor precio') {
      products.sort((a, b) => b.cents.compareTo(a.cents));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LISTAR\nPRODUCTOS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 31,
            height: 1,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: CupertinoSearchTextField(
                key: const Key('product-search'),
                controller: search,
                onChanged: (_) => setState(() {}),
                placeholder: 'Buscar producto…',
                backgroundColor: surface,
                style: const TextStyle(
                  color: ink,
                  fontSize: 15,
                  fontFamily: 'Manrope',
                ),
                placeholderStyle: const TextStyle(
                  color: muted,
                  fontSize: 14,
                  fontFamily: 'Manrope',
                ),
              ),
            ),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: () => showCupertinoModalPopup<void>(
                context: context,
                builder: (sheetContext) => CupertinoActionSheet(
                  title: const Text('Ordenar productos'),
                  actions: ['Catálogo', 'Menor precio', 'Mayor precio']
                      .map(
                        (option) => CupertinoActionSheetAction(
                          isDefaultAction: option == sort,
                          onPressed: () {
                            setState(() => sort = option);
                            Navigator.pop(sheetContext);
                          },
                          child: Text(option),
                        ),
                      )
                      .toList(),
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text('Cancelar'),
                  ),
                ),
              ),
              child: const Icon(
                CupertinoIcons.slider_horizontal_3,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['Todos', ...categories]
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      minimumSize: const Size(0, 36),
                      color: category == c ? mint : surface,
                      onPressed: () => setState(() => category = c),
                      child: Text(
                        c,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: ink,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 22),
        if (products.isEmpty)
          BoldPanel(
            child: Column(
              children: [
                const Icon(Icons.search_off, size: 40),
                const SizedBox(height: 12),
                const Text(
                  'No encontramos productos',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                CupertinoButton(
                  onPressed: () {
                    search.clear();
                    setState(() => category = 'Todos');
                  },
                  child: const Text('Restablecer filtros'),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, i) => tile(context, products[i], i),
          ),
        const SizedBox(height: 16),
        Text(
          '${products.length} productos · precios en soles',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget tile(BuildContext context, Product p, int index) => InkWell(
    onTap: () => showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(p.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Photo(p.image, width: 260, height: 170),
              const SizedBox(height: 16),
              Text(p.description),
              const SizedBox(height: 12),
              Text(
                p.price,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 23,
                ),
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    ),
    child: BoldPanel(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Photo(p.image, width: 56, height: 60),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  p.id.length > 12
                      ? 'OR-${p.id.substring(p.id.length - 6)}'
                      : p.id,
                  style: const TextStyle(fontSize: 11, color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            decoration: BoxDecoration(
              color: [mint, coral, cyan, const Color(0xFFFFC400)][index % 4],
              border: Border.all(color: ink, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              p.price.replaceAll('.00', ''),
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
            ),
          ),
        ],
      ),
    ),
  );
}
