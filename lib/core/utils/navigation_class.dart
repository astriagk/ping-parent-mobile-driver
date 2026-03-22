import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationClass {
  pushNamedAndRemoveUntil(BuildContext context, String pageName, {arg}) =>
      context.go(pageName);

  pushNamed(BuildContext context, String pageName, {arg}) =>
      context.push(pageName, extra: arg);

  push(BuildContext context, Widget page, {arg}) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  pop(BuildContext context, {arg}) => context.pop(arg);

  popAndPushNamed(BuildContext context, String pageName,
      {arg, result}) {
    context.pop(result);
    context.push(pageName, extra: arg);
  }

  pushReplacementNamed(BuildContext context, String pageName, {args}) =>
      context.pushReplacement(pageName, extra: args);
}
