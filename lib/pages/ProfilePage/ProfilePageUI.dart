import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/pages/ProfilePage/ProfilePageLogic.dart';

class ProfilePageUI extends StatelessWidget {
  const ProfilePageUI({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    final logic = context.watch<ProfilePageLogic>();

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text("Profile & Settings", style: textTheme.headlineSmall
                ?.copyWith(color: colorScheme.primary),),
            Text("Manage your account and preferences", style: textTheme.titleMedium
                ?.copyWith(color: colorScheme.primary.withAlpha(160)),),
            const SizedBox(height: 16),
            // ---------------------------------------------------
            // Personal Info
            // ---------------------------------------------------
            Card(
              color: colorScheme.onPrimary,
              shadowColor: colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------------------------------------------------
                      // Title
                      // ---------------------------------------------------
                      Text(
                        "Personal Information",
                        style: textTheme.titleMedium
                            ?.copyWith(color: colorScheme.primary),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // ---------------------------------------------------
                          // Icon
                          // ---------------------------------------------------
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.inversePrimary.withAlpha(40),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Symbols.person,
                              size: 32,
                              color: colorScheme.primary.withAlpha(240),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // ---------------------------------------------------
                          // Name & Age
                          // ---------------------------------------------------
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: ${logic.profileName}",
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: colorScheme.primary),
                              ),

                              Text(
                                "Age: ${logic.age}",
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: colorScheme.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // ---------------------------------------------------
            // Goals
            // ---------------------------------------------------
            Card(
              color: colorScheme.onPrimary,
              shadowColor: colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------------------------------------------
                    // Title
                    // ---------------------------------------------------
                    Text(
                      "Your Goals",
                      style: textTheme.titleMedium
                          ?.copyWith(color: colorScheme.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Areas you're focusing on in your journaling journey",
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                    ),
                    const SizedBox(height: 16),
                    // ---------------------------------------------------
                    // Tags
                    // ---------------------------------------------------
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: logic.goals.map((goal) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: colorScheme.inversePrimary,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            goal,
                            style: textTheme.titleSmall
                                ?.copyWith(color: colorScheme.primary.withAlpha(200)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ]
                ),
              ),
            ),
            const SizedBox(height: 16),
            // ---------------------------------------------------
            // Appearance Settings
            // ---------------------------------------------------
            Card(
              color: colorScheme.onPrimary,
              shadowColor: colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------------------------------------------
                    // Title
                    // ---------------------------------------------------
                    Text(
                      "Appearance",
                      style: textTheme.titleMedium
                          ?.copyWith(color: colorScheme.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Customize your app's appearance",
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                    ),
                    const SizedBox(height: 16),
                    // ---------------------------------------------------
                    // Dark Mode Toggle
                    // ---------------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.inversePrimary.withAlpha(40),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                logic.isDarkMode ? Symbols.dark_mode_rounded : Symbols.light_mode_rounded,
                                size: 24,
                                color: colorScheme.primary.withAlpha(240),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Dark Mode",
                                  style: textTheme.bodyLarge
                                      ?.copyWith(color: colorScheme.primary),
                                ),
                                Text(
                                  logic.isDarkMode ? "Enabled" : "Disabled",
                                  style: textTheme.bodySmall
                                      ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Switch(
                          value: logic.isDarkMode,
                          onChanged: (_) => logic.toggleDarkMode(),
                          activeColor: colorScheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // ---------------------------------------------------
            // Profiles Management
            // ---------------------------------------------------
            Card(
              color: colorScheme.onPrimary,
              shadowColor: colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------------------------------------------
                    // Title
                    // ---------------------------------------------------
                    Text(
                      "Profiles",
                      style: textTheme.titleMedium
                          ?.copyWith(color: colorScheme.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Each profile has its own journal entries",
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                    ),
                    const SizedBox(height: 16),
                    
                    // ---------------------------------------------------
                    // Current Profile
                    // ---------------------------------------------------
                    if (logic.currentProfileId != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceBright,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.primary.withAlpha(128),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Symbols.person,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                logic.profileName,
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: colorScheme.primary),
                              ),
                            ),
                            Text(
                              "Current",
                              style: textTheme.bodySmall
                                  ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 12),
                    
                    // ---------------------------------------------------
                    // All Profiles List
                    // ---------------------------------------------------
                    if (logic.allProfiles.length > 1)
                      ...logic.allProfiles.where((p) => p.id != logic.currentProfileId).map((profile) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Symbols.person_outline,
                                  size: 20,
                                  color: colorScheme.primary.withAlpha(200),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    profile.name,
                                    style: textTheme.bodyMedium
                                        ?.copyWith(color: colorScheme.primary),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Symbols.swap_horiz,
                                    size: 20,
                                    color: colorScheme.primary.withAlpha(200),
                                  ),
                                  onPressed: () => logic.switchProfile(profile.id),
                                  tooltip: "Switch to this profile",
                                ),
                                IconButton(
                                  icon: Icon(
                                    Symbols.delete_outline,
                                    size: 20,
                                    color: colorScheme.error.withAlpha(200),
                                  ),
                                  onPressed: () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Delete Profile"),
                                        content: Text("Are you sure you want to delete '${profile.name}'? All entries for this profile will be deleted."),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            style: TextButton.styleFrom(
                                              foregroundColor: colorScheme.error,
                                            ),
                                            child: Text("Delete"),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirmed == true) {
                                      await logic.deleteProfile(profile.id);
                                    }
                                  },
                                  tooltip: "Delete profile",
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    
                    const SizedBox(height: 12),
                    
                    // ---------------------------------------------------
                    // Add New Profile Button
                    // ---------------------------------------------------
                    FilledButton.icon(
                      onPressed: () async {
                        final nameController = TextEditingController();
                        final result = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Create New Profile"),
                            content: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: "Profile Name",
                                hintText: "Enter profile name",
                              ),
                              autofocus: true,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel"),
                              ),
                              FilledButton(
                                onPressed: () {
                                  if (nameController.text.trim().isNotEmpty) {
                                    Navigator.pop(context, nameController.text.trim());
                                  }
                                },
                                child: Text("Create"),
                              ),
                            ],
                          ),
                        );
                        if (result != null && result.isNotEmpty) {
                          await logic.createProfile(name: result);
                        }
                      },
                      icon: Icon(
                        Symbols.add,
                        size: 20,
                        color: colorScheme.primary.withAlpha(200),
                      ),
                      label: Text(
                        "Create New Profile",
                        style: TextStyle(
                          color: colorScheme.primary.withAlpha(200),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        elevation: 0,
                        backgroundColor: colorScheme.secondaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ]
      ),
    );
  }
}