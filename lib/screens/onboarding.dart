import 'package:eduapge2/api.dart';
import 'package:eduapge2/main.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduapge2/l10n/app_localizations.dart';

class SetupScreen extends StatefulWidget {
  final String err;
  const SetupScreen({super.key, required this.err});

  @override
  BaseState<StatefulWidget> createState() => _SetupScreenState();
}

class _SetupScreenState extends BaseState<SetupScreen> {
  final _introKey = GlobalKey<IntroductionScreenState>();
  AppLocalizations? local;
  late SharedPreferences sharedPreferences;

  Map<String, dynamic>? serverCapabilities;

  // Login info
  bool _useCustomEndpoint = false;
  bool showPassword = false;
  String loginError = "";

  // Settings
  bool useQuickStart = true;
  bool storeDataOnServer = false;
  bool storeCredentials = true;
  bool storeMessages = true;
  bool storeTimeline = true;

  // Flow control
  bool canGoToNext = true;
  bool canGoToPrevious = true;
  bool isLoggingIn = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController serverController = TextEditingController();
  TextEditingController customEndpointController = TextEditingController();

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  Future<void> getPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? sEmail = sharedPreferences.getString("email");
    String? sPassword = sharedPreferences.getString("password");
    String? sServer = sharedPreferences.getString("server");
    String? sEndpoint = sharedPreferences.getString("customEndpoint");

    emailController = TextEditingController(text: sEmail);
    passwordController = TextEditingController(text: sPassword);
    serverController = TextEditingController(text: sServer);
    customEndpointController = TextEditingController(text: sEndpoint);

    if (sEndpoint != null && sEndpoint != "") {
      _useCustomEndpoint = true;
    }

    if (sEmail != null && sPassword != null) {
      if (await EP2Data.getInstance().user.validate()) {
        _introKey.currentState?.animateScroll(2);

        try {
          final response = await EP2Data.getInstance()
              .dio
              .get("${EP2Data.getInstance().baseUrl}/server/capabilities");

          serverCapabilities = response.data;
        } catch (e) {
          setState(() {
            serverCapabilities = {
              "cache": true,
              "encryption": false,
              "storage": false
            };
          });
        }
      }
    }

    if (widget.err.isNotEmpty) {
      loginError = widget.err;
    }

    setState(() {});
  }

  Future<bool> attemptLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        loginError = local!.loginCredentialsRequired;
      });
      return false;
    }

    if (_useCustomEndpoint) {
      EP2Data.getInstance().baseUrl = customEndpointController.text;
    }

    User user = User(
      username: emailController.text,
      password: passwordController.text,
      server: serverController.text,
    );

    bool result = await user.login();

    if (!result) {
      setState(() {
        loginError = local!.loginInvalidCredentials;
      });
      return false;
    }

    try {
      final response = await EP2Data.getInstance()
          .dio
          .get("${EP2Data.getInstance().baseUrl}/server/capabilities");

      serverCapabilities = response.data;
    } catch (e) {
      setState(() {
        serverCapabilities = {
          "cache": true,
          "encryption": false,
          "storage": false
        };
      });
    }

    return true;
  }

  void saveSettings() {
    sharedPreferences.setString("email", emailController.text);
    sharedPreferences.setString("password", passwordController.text);
    sharedPreferences.setString("server", serverController.text);
    sharedPreferences.setString(
        "customEndpoint", customEndpointController.text);
    sharedPreferences.setBool("demo", false);
    sharedPreferences.setBool("quickstart", useQuickStart);
    sharedPreferences.setBool("storeDataOnServer", storeDataOnServer);
    sharedPreferences.setBool("storeCredentials", storeCredentials);
    sharedPreferences.setBool("storeMessages", storeMessages);
    sharedPreferences.setBool("storeTimeline", storeTimeline);
    sharedPreferences.setBool("onboardingCompleted", true);
    sharedPreferences.setBool("isFirstStart", true);

    EP2Data.getInstance().user.login();
    EP2Data.getInstance().user.updateDataStorageSettings(
        storeDataOnServer, storeCredentials, storeMessages, storeTimeline);
  }

  void useDemoMode() {
    sharedPreferences.setString("email", "");
    sharedPreferences.setString("password", "");
    sharedPreferences.setBool("demo", true);
    Navigator.pop(context);
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (loginError.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    loginError,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ],
            ),
          ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email),
            hintText: local!.loginUsername,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.key),
            hintText: local!.loginPassword,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            suffixIcon: IconButton(
              icon:
                  Icon(showPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
            ),
          ),
          obscureText: !showPassword,
          keyboardType: TextInputType.visiblePassword,
        ),
        if (loginError.isNotEmpty || serverController.text.isNotEmpty)
          Column(
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: serverController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.cloud_queue),
                  hintText: local!.loginServer,
                  helperText: local!.loginServerOptional,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                ),
                keyboardType: TextInputType.url,
              ),
            ],
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: _useCustomEndpoint,
              onChanged: (value) {
                setState(() {
                  _useCustomEndpoint = value!;
                });
              },
            ),
            Text(local!.loginCustomEndpointCheckbox),
          ],
        ),
        if (_useCustomEndpoint)
          TextField(
            controller: customEndpointController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.language),
              hintText: local!.loginCustomEndpoint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    local ??= AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          key: _introKey,
          pages: [
            // Welcome page
            PageViewModel(
              title: local!.setupWelcomeTitle,
              body: local!.setupWelcomeBody,
              image: Center(
                child: Image.asset('assets/EduPage2/png/logo-no-background.png',
                    width: 200),
              ),
              decoration: const PageDecoration(
                titleTextStyle:
                    TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                bodyTextStyle: TextStyle(fontSize: 18.0),
                imagePadding: EdgeInsets.only(top: 40.0),
              ),
            ),

            // Login page
            PageViewModel(
              title: local!.loginPleaseLogin,
              bodyWidget: Column(
                children: [
                  Text(
                    local!.loginUseExistingCredentials,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 20),
                  _buildLoginForm(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoggingIn
                        ? null // Disable button while logging in
                        : () async {
                            setState(() {
                              isLoggingIn = true; // Start loading
                            });

                            bool success = false;
                            try {
                              success = await attemptLogin();
                            } finally {
                              setState(() {
                                isLoggingIn =
                                    false; // End loading regardless of outcome
                              });
                            }

                            if (success) {
                              _introKey.currentState?.next();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: isLoggingIn
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(local!.loggingIn),
                            ],
                          )
                        : Text(local!.loginLogin),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: useDemoMode,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(local!.loginDemoButton),
                  ),
                ],
              ),
              decoration: const PageDecoration(
                titleTextStyle:
                    TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                bodyPadding: EdgeInsets.only(top: 20.0),
              ),
            ),

            // QuickStart page
            PageViewModel(
              title: local!.setupQuickStartTitle,
              bodyWidget: Column(
                children: [
                  Text(
                    local!.setupQuickStartExplanation,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    title: Text(local!.setupQuickStartEnable),
                    subtitle: Text(local!.setupQuickStartDetails),
                    trailing: Switch(
                      value: useQuickStart,
                      onChanged: (value) {
                        setState(() {
                          useQuickStart = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  local!.setupQuickStartInfo,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(local!.setupQuickStartBenefits),
                          const SizedBox(height: 4),
                          Text(local!.setupQuickStartDrawbacks),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              decoration: const PageDecoration(
                titleTextStyle:
                    TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                bodyPadding: EdgeInsets.only(top: 20.0),
              ),
            ),

            // Data storage page
            PageViewModel(
              title: local!.setupDataStorageTitle,
              bodyWidget: Column(
                children: [
                  Text(
                    local!.setupDataStorageExplanation,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 20),
                  if (serverCapabilities != null &&
                      !(serverCapabilities!["storage"] ?? false))
                    Card(
                      color: Colors.amber.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.warning_amber_rounded,
                                    color: Colors.amber.shade800),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    local!.setupDataStorageDisabled,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber.shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(local!.setupDataStorageDisabledExplanation),
                          ],
                        ),
                      ),
                    ),
                  if (serverCapabilities == null ||
                      (serverCapabilities!["storage"] ?? false)) ...[
                    ListTile(
                      title: Text(local!.setupDataStorageEnable),
                      trailing: Switch(
                        value: storeDataOnServer,
                        onChanged: (value) {
                          setState(() {
                            storeDataOnServer = value;
                          });
                        },
                      ),
                    ),
                    const Divider(),
                    if (storeDataOnServer) ...[
                      Text(
                        local!.setupDataStorageChoose,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CheckboxListTile(
                        title: Text(local!.setupDataStorageAttendance),
                        value: storeCredentials,
                        onChanged: (value) {
                          setState(() {
                            storeCredentials = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(local!.setupDataStorageGrades),
                        value: storeMessages,
                        onChanged: (value) {
                          setState(() {
                            storeMessages = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(local!.setupDataStorageMessages),
                        value: storeTimeline,
                        onChanged: (value) {
                          setState(() {
                            storeTimeline = value!;
                          });
                        },
                      ),
                    ],
                    const SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  serverCapabilities != null &&
                                          (serverCapabilities!["encryption"] ??
                                              false)
                                      ? Icons.shield
                                      : Icons.shield_outlined,
                                  color: serverCapabilities != null &&
                                          (serverCapabilities!["encryption"] ??
                                              false)
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    serverCapabilities != null &&
                                            (serverCapabilities![
                                                    "encryption"] ??
                                                false)
                                        ? local!
                                            .setupDataStoragePrivacyEncrypted
                                        : local!
                                            .setupDataStoragePrivacyUnencrypted,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              serverCapabilities != null &&
                                      (serverCapabilities!["encryption"] ??
                                          false)
                                  ? local!
                                      .setupDataStoragePrivacyDetailsEncrypted
                                  : local!
                                      .setupDataStoragePrivacyDetailsUnencrypted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            local!.setupFeaturesAvailable,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _buildFeatureStatus(
                            local!.setupFeatureBasic,
                            true,
                          ),
                          _buildFeatureStatus(
                            local!.setupFeatureSearch,
                            (serverCapabilities != null &&
                                    (serverCapabilities!["storage"] ??
                                        false)) &&
                                storeDataOnServer &&
                                storeCredentials &&
                                storeMessages,
                          ),
                          _buildFeatureStatus(
                            local!.setupFeatureNotifications,
                            (serverCapabilities != null &&
                                    (serverCapabilities!["storage"] ??
                                        false)) &&
                                storeDataOnServer &&
                                storeCredentials &&
                                storeTimeline,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              decoration: const PageDecoration(
                titleTextStyle:
                    TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                bodyPadding: EdgeInsets.only(top: 20.0),
              ),
            ),

            // Setup complete page
            PageViewModel(
              title: local!.setupCompleteTitle,
              body: local!.setupCompleteBody,
              image: Center(
                child: Icon(Icons.check_circle,
                    size: 100.0, color: Colors.green.shade600),
              ),
              decoration: const PageDecoration(
                titleTextStyle:
                    TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                bodyTextStyle: TextStyle(fontSize: 18.0),
                imagePadding: EdgeInsets.only(top: 40.0),
              ),
            ),
          ],
          onDone: () {
            // Save all settings and exit setup
            saveSettings();
            Navigator.pop(context);
          },
          onChange: (page) {
            // Is a page that enables/disables the next button
            switch (page) {
              case 0:
                setState(() {
                  canGoToNext = true;
                });
                break;
              case 1:
                setState(() {
                  canGoToNext = false;
                });
                break;
              case 2:
                setState(() {
                  canGoToNext = true;
                  canGoToPrevious = false;
                });
                break;
              case 3:
                setState(() {
                  canGoToPrevious = true;
                });
                break;
            }
          },
          showBackButton: canGoToPrevious,
          showNextButton: canGoToNext,
          freeze: !canGoToNext,
          back: const Icon(Icons.arrow_back),
          next: const Icon(Icons.arrow_forward),
          done: Text(local!.setupDone,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          dotsDecorator: const DotsDecorator(
            color: Colors.grey,
            activeColor: Colors.blue,
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureStatus(String feature, bool available) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            available ? Icons.check_circle : Icons.cancel,
            color: available ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(feature)),
        ],
      ),
    );
  }
}
