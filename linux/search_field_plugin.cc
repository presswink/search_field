#include "include/search_field/search_field_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#include "search_field_plugin_private.h"

#define SEARCH_FIELD_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), search_field_plugin_get_type(), \
                              SearchFieldPlugin))

struct _SearchFieldPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(SearchFieldPlugin, search_field_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void search_field_plugin_handle_method_call(
    SearchFieldPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getPlatformVersion") == 0) {
    response = get_platform_version();
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

FlMethodResponse* get_platform_version() {
  struct utsname uname_data = {};
  uname(&uname_data);
  g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
  g_autoptr(FlValue) result = fl_value_new_string(version);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static void search_field_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(search_field_plugin_parent_class)->dispose(object);
}

static void search_field_plugin_class_init(SearchFieldPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = search_field_plugin_dispose;
}

static void search_field_plugin_init(SearchFieldPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  SearchFieldPlugin* plugin = SEARCH_FIELD_PLUGIN(user_data);
  search_field_plugin_handle_method_call(plugin, method_call);
}

void search_field_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  SearchFieldPlugin* plugin = SEARCH_FIELD_PLUGIN(
      g_object_new(search_field_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "search_field",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
