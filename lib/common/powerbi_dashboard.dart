import 'package:codename_ttportal/home/model/dashboard_model.dart';
import 'package:codename_ttportal/resources/colors.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

class PowerBIDashboard extends StatefulWidget {
  final Dashboard dashboard;

  const PowerBIDashboard({
    super.key,
    required this.dashboard,
  });

  @override
  _PowerBIDashboardState createState() => _PowerBIDashboardState();
}

class _PowerBIDashboardState extends State<PowerBIDashboard> {
  late String viewId;

  @override
  void initState() {
    super.initState();
    viewId = 'powerbi-${widget.dashboard.id}';
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) => html.IFrameElement()
        ..src = widget.dashboard.link
        ..style.border = 'none',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dashboard.name),
        backgroundColor: tectransblue,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: HtmlElementView(
          viewType: viewId,
        ),
      ),
    );
  }
}
