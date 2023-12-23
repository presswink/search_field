//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <text_search_field/text_search_field_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) text_search_field_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "TextSearchFieldPlugin");
  text_search_field_plugin_register_with_registrar(text_search_field_registrar);
}
