import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelUtils {
  final Workbook _workbook = new Workbook();
  Worksheet? _sheet;
  late Style titleStyle;

  // ignore: non_constant_identifier_names
  final double COLUMN_CELL = 30;

  ExcelUtils() {
    this.titleStyle = _workbook.styles.add('title');
  }

  void createSheet(int index) {
    this._sheet = _workbook.worksheets[0];
  }

  void title(String column, String text) {
    titleStyle.backColor = '#33FF80';
    titleStyle.fontSize = 14;
    titleStyle.bold = true;
    titleStyle.hAlign = HAlignType.center;
    _sheet?.getRangeByName(column).cellStyle = titleStyle;
    _sheet?.getRangeByName(column).setText(text);
    _sheet?.getRangeByName(column).columnWidth = COLUMN_CELL;
  }

  void body(String column, String text) {
    _sheet?.getRangeByName(column).setText(text);
    _sheet?.getRangeByName(column).columnWidth = COLUMN_CELL;
  }

  void save(String namefile) {
    final List<int> bytes = _workbook.saveAsStream();
    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', namefile)
        ..click();
    }
  }
}
