#ifndef FLUTTER_PLUGIN_TEXT_SEARCH_FIELD_PLUGIN_H_
#define FLUTTER_PLUGIN_TEXT_SEARCH_FIELD_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace text_search_field {

class TextSearchFieldPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  TextSearchFieldPlugin();

  virtual ~TextSearchFieldPlugin();

  // Disallow copy and assign.
  TextSearchFieldPlugin(const TextSearchFieldPlugin&) = delete;
  TextSearchFieldPlugin& operator=(const TextSearchFieldPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace text_search_field

#endif  // FLUTTER_PLUGIN_TEXT_SEARCH_FIELD_PLUGIN_H_
