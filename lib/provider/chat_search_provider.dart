import 'package:flutter/material.dart';
import '../core/constants/messages.dart';

enum DateFilter { anyTime, week, month, sixMonths, year }

enum AttachmentFilter { none, image, pdf, document, link }

enum SenderFilter { all, me, other }

enum SortFilter { mostRelevant, mostRecent }

class ChatSearchProvider extends ChangeNotifier {
  String _query = "";
  DateFilter _dateFilter = DateFilter.anyTime;
  AttachmentFilter _attachmentFilter = AttachmentFilter.none;
  SenderFilter _senderFilter = SenderFilter.all;
  SortFilter _sortFilter = SortFilter.mostRelevant;

  String get query => _query;
  DateFilter get dateFilter => _dateFilter;
  AttachmentFilter get attachmentFilter => _attachmentFilter;
  SenderFilter get senderFilter => _senderFilter;
  SortFilter get sortFilter => _sortFilter;

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

  void updateSenderFilter(SenderFilter filter) {
    _senderFilter = filter;
    notifyListeners();
  }

  bool hasLink(String text) {
    final urlRegex = RegExp(
      r'((https?:\/\/)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\S*)?)',
      caseSensitive: false,
    );
    return urlRegex.hasMatch(text);
  }

  void updateSortFilter(SortFilter filter) {
    _sortFilter = filter;
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
            return type == "text" && hasLink(msg["content"].toString());
          default:
            return true;
        }
      }).toList();
    }

    if (_senderFilter != SenderFilter.all) {
      results = results.where((msg) {
        final senderId = msg["senderId"].toString();
        switch (_senderFilter) {
          case SenderFilter.me:
            return senderId == "1";
          case SenderFilter.other:
            return senderId != "1";
          case SenderFilter.all:
            return true;
        }
      }).toList();
    }

    return results;
  }

  bool get hasSearchedOrFiltered =>
      _query.isNotEmpty ||
      _dateFilter != DateFilter.anyTime ||
      _attachmentFilter != AttachmentFilter.none ||
      _senderFilter != SenderFilter.all;
}
