import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/assets/image_assets.dart';
import '../../../core/const/constants.dart';
import '../../../core/enums/app_theme_mode.dart';
import '../../../core/enums/language.dart';
import '../../../core/extensions/spacing.dart';
import '../../../core/extensions/text_style_extensions.dart';
import '../../../injection_container.dart';
import '../../bloc/app/app_bloc.dart';
import '../../bloc/settings/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator.get<SettingsCubit>()..init(),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Social login
              BlocConsumer<SettingsCubit, SettingsState>(
                listener: (context, state) {
                  if (state is STLoginFailed) {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.message,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      context.read<SettingsCubit>().emit(STMessageClosed());
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
                builder: (context, state) {
                  SettingsCubit settingsCubit = context.read<SettingsCubit>();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (settingsCubit.userEntity?.image != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: ClipOval(
                                child: Image.network(
                                  settingsCubit.userEntity?.image ?? '',
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                settingsCubit.userEntity?.name ?? '',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                "${l10n.level}: ${settingsCubit.userEntity?.level ?? '0'} | "
                                "${l10n.score}: ${settingsCubit.userEntity?.score ?? '0'}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const VSpace(16),
                      if (settingsCubit.userEntity?.isAnonymous == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.joinHangManWithYourSocialMediaAccount,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const VSpace(16),
                            InkWell(
                              onTap: () => context.read<SettingsCubit>().googleSignIn(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      ImageAssets.google,
                                      height: 24,
                                      width: 24,
                                    ),
                                    const HSpace(8),
                                    Text(
                                      l10n.joinWithGoogle,
                                      style: Theme.of(context).textTheme.titleMedium?.textColor(const Color(0xFFDE5241)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
              const VSpace(32),

              // Support Us
              Text(
                l10n.supportUs,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const VSpace(24),
              InkWell(
                onTap: () {
                  final Uri url = Uri.parse(googlePlayURL);
                  launchUrl(url, mode: LaunchMode.externalApplication);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.rate5Starts,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Share.share(
                    'Check out this amazing game hangman word quest. $googlePlayURL',
                    subject: 'Hangman Word Quest',
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.shareHangman,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
              const VSpace(16),

              Text(l10n.settings, style: Theme.of(context).textTheme.bodyLarge),
              const VSpace(16),
              // Language
              Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
              BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    trailing: Image.asset(state.selectedLanguage.image, height: 32, width: 32),
                    title: Text(state.selectedLanguage.text),
                    onTap: () => showLanguageBottomSheet(context),
                  );
                },
              ),
              const VSpace(12),

              // Theme
              Text(l10n.theme, style: Theme.of(context).textTheme.titleMedium),
              const VSpace(16),
              BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  return SegmentedButton<AppThemeMode>(
                    segments: <ButtonSegment<AppThemeMode>>[
                      ...AppThemeMode.values.map((themeMode) {
                        return ButtonSegment(
                          value: themeMode,
                          icon: Icon(themeMode.iconData),
                          label: Text(themeMode.text),
                        );
                      }),
                    ],
                    multiSelectionEnabled: false,
                    showSelectedIcon: false,
                    selected: <AppThemeMode>{state.selectedThemeMode},
                    onSelectionChanged: (Set<AppThemeMode> selectedMode) {
                      context.read<AppBloc>().add(ChangeThemeMode(selectedThemeMode: selectedMode.first));
                    },
                  );
                },
              ),
              const VSpace(64),
            ],
          ),
        ),
      ),
    );
  }

  void showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.chooseLanguage,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16.0),
              BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: Language.values.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          context.read<AppBloc>().add(ChangeLanguage(selectedLanguage: Language.values[index]));
                          Future.delayed(const Duration(milliseconds: 300)).then((value) => Navigator.of(context).pop());
                        },
                        leading: ClipOval(
                          child: Image.asset(
                            Language.values[index].image,
                            height: 32.0,
                            width: 32.0,
                          ),
                        ),
                        title: Text(Language.values[index].text),
                        trailing: Language.values[index] == state.selectedLanguage
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: Language.values[index] == state.selectedLanguage ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5) : BorderSide(color: Colors.grey[300]!),
                        ),
                        tileColor: Language.values[index] == state.selectedLanguage ? Theme.of(context).colorScheme.primary.withOpacity(0.05) : null,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16.0);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
