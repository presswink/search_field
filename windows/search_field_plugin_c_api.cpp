#include "include/search_field/search_field_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "search_field_plugin.h"

void SearchFieldPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  search_field::SearchFieldPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
