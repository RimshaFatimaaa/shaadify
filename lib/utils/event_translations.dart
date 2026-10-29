import 'package:flutter/material.dart';
import '../models/wedding_event.dart';
import '../l10n/app_localizations.dart';

class EventTranslations {
  static String getEventName(BuildContext context, EventType eventType) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return eventType.displayName;
    
    switch (eventType) {
      case EventType.mehndi:
        return l10n.eventMehndi;
      case EventType.barat:
        return l10n.eventBarat;
      case EventType.walima:
        return l10n.eventWalima;
      case EventType.mayun:
        return l10n.eventMayun;
      case EventType.engagement:
        return l10n.eventEngagement;
      case EventType.nikah:
        return l10n.eventNikah;
      case EventType.qawaliNight:
        return l10n.eventQawaliNight;
    }
  }
}
