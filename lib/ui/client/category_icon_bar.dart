
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoom/components/categories.dart';
import 'package:zoom/components/colors.dart';

class CategoryIconBar extends StatelessWidget {

  final Function(int) onIndexChange;
  CategoryIconBar({this.onIndexChange});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryIcon(
          category: categories.keys.toList()[index],
          iconData: categories[categories.keys.toList()[index]],
          onPressed: () {
            onIndexChange(index);
          },
        );
      }
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final String category;
  final IconData iconData;
  final VoidCallback onPressed;
  final bool selected;

  CategoryIcon({
    this.category,
    this.iconData,
    this.onPressed,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      child: FlatButton(
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              iconData,
              color: primaryColor,
            ),
            Text(
              category,
              style: Theme.of(context).textTheme.button.copyWith(
                  color: secondaryColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}
