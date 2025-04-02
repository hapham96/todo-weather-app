import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LoggerTrackerService {
  static final LoggerTrackerService _instance =
      LoggerTrackerService._internal();
  factory LoggerTrackerService() => _instance;

  late final Logger _logger;
  final List<String> _logBuffer = [];

  bool _isLogging = true;
  bool _includeTimestamp = true;

  LoggerTrackerService._internal() {
    _logger = Logger(printer: PrettyPrinter(methodCount: 0, lineLength: 70));
  }

  void startLog({bool includeTimestamp = true}) {
    _isLogging = true;
    _includeTimestamp = includeTimestamp;
    log("🔄 Logging started", tag: "LoggerTracker", level: Level.info);
  }

  void stopLog() {
    log("🛑 Logging stopped", tag: "LoggerTracker", level: Level.info);
    _isLogging = false;
  }

  void log(String message, {Level level = Level.info, String? tag}) {
    if (!_isLogging) return;

    final usedTag = tag ?? _getCallerTag();
    final timestamp =
        _includeTimestamp ? "[${DateTime.now().toIso8601String()}] " : "";
    final fullMessage = "$timestamp[$usedTag] $message";

    _logBuffer.add(fullMessage);

    switch (level) {
      case Level.debug:
        _logger.d(fullMessage);
        break;
      case Level.warning:
        _logger.w(fullMessage);
        break;
      case Level.error:
        _logger.e(fullMessage);
        break;
      case Level.info:
      default:
        _logger.i(fullMessage);
        break;
    }
  }

  void logInfo(String msg, {String? tag}) =>
      log(msg, level: Level.info, tag: tag);
  void logDebug(String msg, {String? tag}) =>
      log(msg, level: Level.debug, tag: tag);
  void logWarning(String msg, {String? tag}) =>
      log(msg, level: Level.warning, tag: tag);
  void logError(String msg, {String? tag}) =>
      log(msg, level: Level.error, tag: tag);

  Future<File> saveLogToFile([String? filename]) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final fileName = filename ?? "log_$timestamp.txt";
    final file = File('${directory.path}/$fileName');

    final logContent = _logBuffer.join('\n');
    await file.writeAsString(logContent);

    log(
      "📁 Log saved to: ${file.path}",
      tag: "LoggerTracker",
      level: Level.info,
    );

    return file;
  }

  void clearBuffer() => _logBuffer.clear();

  String _getCallerTag() {
    try {
      final trace = StackTrace.current.toString().split('\n');
      final callerLine = trace[3];
      final match = RegExp(r'#\d+\s+(.+)\s+\(').firstMatch(callerLine);
      return match?.group(1) ?? 'Unknown';
    } catch (_) {
      return 'Unknown';
    }
  }

  bool get isLogging => _isLogging;
  List<String> get logBuffer => List.unmodifiable(_logBuffer);
}
