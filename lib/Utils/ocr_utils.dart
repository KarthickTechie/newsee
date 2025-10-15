import 'dart:math';

Map<String, String> extractDLInfo(String extractedText) {
  // Pattern for DL number: matches fDL. No., DL. No., or f.DL. No. followed by 2 uppercase letters + 2 digits + more digits
  // Adjusted to handle potential line breaks or extra spaces in OCR output

  final RegExp dlRegex = RegExp(
    r'(?:(?:fDL NO\. |fDL No\. |fDL\. No\. |DL\. No\. |f\.DL\. No\. )\s*([A-Z]{2}\d{2}\s*\d{9,11}))',
    multiLine: true,
  );
  final Match? dlMatch = dlRegex.firstMatch(extractedText);
  String dlNumber = dlMatch?.group(1) ?? '';

  // If no match, try a more flexible fallback pattern looking for 2 letters + 2 digits + more after "fDL. No." or similar
  if (dlNumber.isEmpty) {
    final RegExp fallbackRegex = RegExp(
      r'(?:fDL\. No\.|DL\. No\.|f\.DL\. No\.)\s*([A-Z]{2}\d{2}\d+)',
      multiLine: true,
    );
    final Match? fallbackMatch = fallbackRegex.firstMatch(extractedText);
    dlNumber = fallbackMatch?.group(1) ?? '';
  }

  if (dlNumber.isEmpty) {
    final RegExp dlRegex = RegExp(
      r'(?:(?:fDL\. No\.|DL\. No\.|f\.DL\. No\.)\s*([A-Z]{2}\d{2}\s*\d{9,11}))',
      multiLine: true,
    );
    final Match? fallbackMatch = dlRegex.firstMatch(extractedText);
    dlNumber = fallbackMatch?.group(1) ?? '';
  }

  // Find the range after "Name" until the next "Date" or "Son"
  final int nameStartIndex = extractedText.indexOf('Name');
  if (nameStartIndex == -1) {
    return {'idtype': 'DL', 'id': dlNumber, 'name': ''};
  }

  final String afterName = extractedText.substring(
    nameStartIndex + 4,
  ); // Skip "Name"
  final int dateIndex = afterName.indexOf('Date');
  final int sonIndex = afterName.indexOf('Son');
  final int endIndex = [
    dateIndex,
    sonIndex,
  ].where((idx) => idx != -1).reduce(min);
  String nameCandidate = '';
  if (endIndex != -1) {
    nameCandidate = afterName.substring(0, endIndex).trim();
  } else {
    // Fallback: take next 2 lines or until next I/flutter
    final lines = afterName.split('\n');
    if (lines.length >= 3) {
      nameCandidate = '${lines[0].trim()}\n${lines[1].trim()}';
    } else {
      nameCandidate = lines.join('\n').trim();
    }
  }

  // Extract uppercase words for name
  final RegExp nameWordRegex = RegExp(r'\b[A-Z]{2,}\b');
  final Iterable<Match> nameMatches = nameWordRegex.allMatches(nameCandidate);
  final String name = nameMatches.map((m) => m.group(0)!).join(' ');

  return {'idtype': 'DL', 'id': dlNumber, 'name': name};
}
