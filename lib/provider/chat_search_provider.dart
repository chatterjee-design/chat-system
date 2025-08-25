import 'package:flutter/material.dart';
import '../core/constants/messages.dart';

enum DateFilter { anyTime, week, month, sixMonths, year }

enum AttachmentFilter { none, image, pdf, document, link }

class ChatSearchProvider extends ChangeNotifier {
  String _query = "";
  DateFilter _dateFilter = DateFilter.anyTime;
  AttachmentFilter _attachmentFilter = AttachmentFilter.none;

  String get query => _query;
  DateFilter get dateFilter => _dateFilter;
  AttachmentFilter get attachmentFilter => _attachmentFilter;

  void updateQuery(String newQuery) {
    _query = newQuery;
    notifyListeners();
  }

  void updateDateFilter(DateFilter filter) {
    _dateFilter = filter;
    notifyListeners();
  }

  void updateAttachmentFilter(AttachmentFilter filter) {
    _attachmentFilter = filter;
    notifyListeners();
  }

  List<Map<String, dynamic>> get filteredMessages {
    List<Map<String, dynamic>> results = messages;

    if (_query.isNotEmpty) {
      results = results
          .where(
            (msg) =>
                msg["type"] == "text" &&
                msg["content"].toString().toLowerCase().contains(
                  _query.toLowerCase(),
                ),
          )
          .toList();
    }

    results = results.where((msg) {
      final msgDate = DateTime.parse(msg["timestamp"]);
      final now = DateTime.now();

      switch (_dateFilter) {
        case DateFilter.anyTime:
          return true;
        case DateFilter.week:
          return msgDate.isAfter(now.subtract(const Duration(days: 7)));
        case DateFilter.month:
          return msgDate.isAfter(now.subtract(const Duration(days: 30)));
        case DateFilter.sixMonths:
          return msgDate.isAfter(now.subtract(const Duration(days: 180)));
        case DateFilter.year:
          return msgDate.isAfter(now.subtract(const Duration(days: 365)));
      }
    }).toList();

    if (_attachmentFilter != AttachmentFilter.none) {
      results = results.where((msg) {
        final type = msg["type"] as String;

        switch (_attachmentFilter) {
          case AttachmentFilter.image:
            return type == "image";
          case AttachmentFilter.pdf:
            return type == "pdf";
          case AttachmentFilter.document:
            return type == "document";
          case AttachmentFilter.link:
            return type == "text" &&
                msg["content"].toString().toLowerCase().contains("http");
          default:
            return true;
        }
      }).toList();
    }

    return results;
  }

  bool get hasSearchedOrFiltered =>
      _query.isNotEmpty ||
      _dateFilter != DateFilter.anyTime ||
      _attachmentFilter != AttachmentFilter.none;
}
