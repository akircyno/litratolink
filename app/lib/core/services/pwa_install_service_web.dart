// Web-only JS interop using dart:js_interop (Dart 3.x)
import 'dart:js_interop';

@JS('pwaInstallAvailable')
external bool _available();

@JS('pwaPromptInstall')
external void _prompt();

@JS('pwaIsInstalled')
external bool _installed();

bool isPromptAvailable() {
  try {
    return _available();
  } catch (_) {
    return false;
  }
}

bool isInstalled() {
  try {
    return _installed();
  } catch (_) {
    return false;
  }
}

void promptInstall() {
  try {
    _prompt();
  } catch (_) {}
}
