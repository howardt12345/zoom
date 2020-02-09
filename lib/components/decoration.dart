

import 'package:flutter/material.dart';

outlineDecoration(context) => new BoxDecoration(
    borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
    border: new Border.all(color: Theme.of(context).textTheme.body2.color.withAlpha(50))
);