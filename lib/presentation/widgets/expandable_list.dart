import 'package:flutter/material.dart';

/// Genişletilebilir liste widget'ı
class ExpandableList extends StatefulWidget {
  final List<MapEntry<String, int>> items;
  final String expandText;
  final String collapseText;
  final Color textColor;
  final Color accentColor;

  const ExpandableList({
    Key? key,
    required this.items,
    required this.expandText,
    required this.collapseText,
    required this.textColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  _ExpandableListState createState() => _ExpandableListState();
}

class _ExpandableListState extends State<ExpandableList> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final displayItems =
        _showAll ? widget.items : widget.items.take(5).toList();

    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayItems.length,
          separatorBuilder:
              (_, __) =>
                  Divider(height: 1, color: widget.textColor.withOpacity(0.1)),
          itemBuilder: (context, index) {
            final item = displayItems[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.key,
                      style: TextStyle(color: widget.textColor, fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: widget.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.value.toString(),
                      style: TextStyle(
                        color: widget.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (widget.items.length > 5)
          InkWell(
            onTap: () {
              setState(() {
                _showAll = !_showAll;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: widget.textColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  _showAll
                      ? widget.expandText
                      : '${widget.collapseText} (${widget.items.length})',
                  style: TextStyle(
                    color: widget.accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
