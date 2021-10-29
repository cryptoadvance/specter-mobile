import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils.dart';

class LightFilterItemModel {
  final String title, key;
  final String icon;

  final Color iconColor, backgroundColor;

  final Color activeIconColor, activeBackgroundColor;

  final Function? onSelect;

  LightFilterItemModel({
    required this.title,
    required this.key,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.activeIconColor,
    required this.activeBackgroundColor,
    this.onSelect
  });
}

class LightFilter extends StatefulWidget {
  final List<LightFilterItemModel> filters;
  final Function(Map<String, String>) onChange;

  LightFilter({required this.filters, required this.onChange});

  @override
  State<StatefulWidget> createState() {
    return LightFilterState();
  }
}

class LightFilterState extends State<LightFilter> {
  Map<String, String> filtersStates = HashMap();

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    widget.filters.forEach((el) {
      var filterValue = filtersStates[el.key];
      items.add(Container(
        child: LightFilterItem(
          filterItem: el,
          filterValue: filterValue,
          onItemSelect: () {
            itemSelected(el.key);
          },
          onItemSetValue: (String val) {
            itemSetValue(el.key, val);
          }
        )
      ));
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items
    );
  }

  void itemSelected(String filterKey) {
    if (filtersStates.containsKey(filterKey)) {
      filtersStates.remove(filterKey);
    } else {
      filtersStates[filterKey] = '1';
    }

    //
    setState(() {
    });

    //
    wasModified();
  }

  void itemSetValue(String filterKey, String val) {
    filtersStates[filterKey] = val;

    //
    setState(() {
    });

    //
    wasModified();
  }

  void wasModified() {
    widget.onChange(filtersStates);
  }
}

class LightFilterItem extends StatelessWidget {
  final LightFilterItemModel filterItem;
  final String? filterValue;
  final Function onItemSelect, onItemSetValue;

  LightFilterItem({required this.filterItem, required this.onItemSelect, required this.onItemSetValue, this.filterValue});

  @override
  Widget build(BuildContext context) {
    Color iconColor = filterItem.iconColor;
    Color bgColor = filterItem.backgroundColor;

    bool isActive = (filterValue != null);
    if (isActive) {
      iconColor = filterItem.activeIconColor;
      bgColor = filterItem.activeBackgroundColor;
    }

    var roundBox = Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: () async {
            if (filterItem.onSelect != null) {
              if (!isActive) {
                String val = await filterItem.onSelect!();
                onItemSetValue(val);
              } else {
                onItemSelect();
              }
              return;
            }

            //
            onItemSelect();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: ClipOval(
              child: Container(
                  width: 64,
                  height: 64,
                  color: bgColor,
                  child: Center(
                      child: SvgPicture.asset(filterItem.icon, color: iconColor)
                  )
              )
          )
      )
    );

    var bottomLabel = Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(filterItem.title)
    );

    return Container(
      child: Column(
        children: [
          Container(
            child: roundBox
          ),
          Container(
            child: bottomLabel
          )
        ]
      )
    );
  }
}