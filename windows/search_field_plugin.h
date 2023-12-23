#ifndef FLUTTER_PLUGIN_SEARCH_FIELD_PLUGIN_H_
#define FLUTTER_PLUGIN_SEARCH_FIELD_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace search_field {

class SearchFieldPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SearchFieldPlugin();

  virtual ~SearchFieldPlugin();

  // Disallow copy and assign.
  SearchFieldPlugin(const SearchFieldPlugin&) = delete;
  SearchFieldPlugin& operator=(const SearchFieldPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace search_field

#endif  // FLUTTER_PLUGIN_SEARCH_FIELD_PLUGIN_H_
