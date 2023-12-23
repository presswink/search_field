//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <search_field/search_field_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) search_field_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SearchFieldPlugin");
  search_field_plugin_register_with_registrar(search_field_registrar);
}
