#include "include/text_search_field/text_search_field_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "text_search_field_plugin.h"

void TextSearchFieldPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  text_search_field::TextSearchFieldPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
