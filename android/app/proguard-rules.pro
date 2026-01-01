# Flutter plugin rules to prevent MissingPluginException
# Keep all Flutter plugin classes

# Keep permission_handler plugin
-keep class com.baseflow.permissionhandler.** { *; }

# Keep record plugin
-keep class com.llfbandit.record.** { *; }

# Keep GeneratedPluginRegistrant
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Keep all Flutter engine classes
-keep class io.flutter.** { *; }
-keep class androidx.** { *; }

