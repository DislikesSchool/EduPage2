<br/>
<p align="center">
  <a href="https://github.com/DislikesSchool/EduPage2">
    <img src="https://raw.githubusercontent.com/DislikesSchool/EduPage2/master/assets/EduPage2/png/logo-512px.png" alt="Logo" width="160" height="160">
  </a>
  <h3 align="center">EduPage2</h3>

  <p align="center">
    The fastest client for EduPage
    <br/>
    <br/>
    <a href="https://github.com/DislikesSchool/EduPage2/issues">Report Bug</a>
    .
    <a href="https://github.com/DislikesSchool/EduPage2/issues">Request Feature</a>
  </p>
</p>

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/dislikesschool/edupage2) ![Downloads](https://img.shields.io/github/downloads/DislikesSchool/EduPage2/total) ![Contributors](https://img.shields.io/github/contributors/DislikesSchool/EduPage2?color=dark-green) ![Issues](https://img.shields.io/github/issues/DislikesSchool/EduPage2) ![License](https://img.shields.io/github/license/DislikesSchool/EduPage2) [![codecov](https://codecov.io/github/DislikesSchool/EduPage2/branch/master/graph/badge.svg?token=HKP9WFL0LN)](https://codecov.io/github/DislikesSchool/EduPage2) [![weblate](https://hosted.weblate.org/widget/edupage-2/edupage-2-flutter/svg-badge.svg)](https://hosted.weblate.org/engage/edupage-2/)


[![test-coverage](https://github.com/DislikesSchool/EduPage2/actions/workflows/test-coverage.yml/badge.svg)](https://github.com/DislikesSchool/EduPage2/actions/workflows/test-coverage.yml)
[![build-patch-android](https://github.com/DislikesSchool/EduPage2/actions/workflows/build-patch.yml/badge.svg)](https://github.com/DislikesSchool/EduPage2/actions/workflows/build-patch.yml)

[![Discord](https://discordapp.com/api/guilds/1143488418840584224/widget.png?style=shield)](https://discord.gg/xy5nqWa2kQ)
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/I3I2K0XUW)

## Table Of Contents

- [Table Of Contents](#table-of-contents)
- [About The Project](#about-the-project)
- [Backend Status](#backend-status)
  - [Quick status](#quick-status)
  - [Statuspage](#statuspage)
- [Disclaimer](#disclaimer)
- [Built With](#built-with)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
  - [Translating](#translating)
  - [Creating A Pull Request](#creating-a-pull-request)
- [License](#license)
- [Contributors](#contributors)
- [Acknowledgements](#acknowledgements)

## About The Project

If you have ever used EduPage, you already know that it's slow. And not just on the school Wi-Fi network, where there are hundreds or thousands of other people, using the network at the same time, but also on your home network, which should be faster right? Well, your network is in most cases faster than the school network, which indicates, that the issue is not on our side, but rather EduPage's servers just being slow.

And that's why we made EduPage2. So far, EduPage2 lacks a pretty big amount of features, that are included in the official app. But don't worry! With almost daily updates, we are constantly releasing new features, and optimising the existing ones.

EduPage2 uses local caching on your device, and a caching server with our own privte software, which periodically updates data from EduPage, strips it of all useless data (which EduPage includes for some reason), and finally sends out to your device when requested.

## Backend Status

### Quick status

| Host       | Status                                                                                                                                             |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| Render.com | [![Better Stack Badge](https://uptime.betterstack.com/status-badges/v1/monitor/w8hv.svg)](https://uptime.betterstack.com/?utm_source=status_badge) |
| Deta.space | [![Better Stack Badge](https://uptime.betterstack.com/status-badges/v1/monitor/wt8i.svg)](https://uptime.betterstack.com/?utm_source=status_badge) |

### Statuspage

Currently there are two status pages for the EduPage2 backend. The one on [Better Stack](https://ep2.betteruptime.com/) which we have confirmed to work, and the other one on [Statuspage](https://edupage2.statuspage.io/) which seems to work, but we will have to wait unitl an outage occurs to test that.

## Disclaimer

**EduPage2** is an open-source project with contributions from multiple individuals and is not affiliated with or endorsed by the creators of EduPage. EduPage is a separate and (possibly) trademarked platform owned by asc Applied Software Consultants, s.r.o.

Please note that while EduPage2 is designed to work as a drop-in replacement or alternative mobile client for EduPage, it is not officially supported by the EduPage team. Any issues or inquiries related to EduPage2 should be directed to the project's [GitHub Issues](https://github.com/DislikesSchool/EduPage2/issues) provided in this repository.

This project is open source and distributed under the [GPL-3.0 license](https://choosealicense.com/licenses/gpl-3.0/), and all contributions are welcome from the community. However, use it responsibly and in compliance with the terms of use of the original EduPage platform.

## Built With

This is a list of all the main tools, libraries and frameworks, that were used in this project

- [Flutter](https://flutter.dev/) - _App framework_
- [Firebase](https://firebase.google.com/) - _Messaging, remote config_
- [OneSignal](https://onesignal.com/) - _Push notifications_
- [Shorebird](https://shorebird.dev/) - _Remote patching_
- [Golang](https://go.dev/) - _Backend programming language_
- [Gin](https://gin-gonic.com/) - _Server library_
- [Weblate](https://hosted.weblate.org/engage/edupage-2/) - _Managing translations_

## Getting Started

All our backend stuff is luckily managed by us, which makes getting started very easy for you.

### Prerequisites

Make sure that you already have an EduPage account. Since this is a client, you need to already have an account at EduPage, to use EduPage2.

### Installation

If you want to build the code yourself, all the code is provided in this repository, you can download it, and build it on your own machine.

Otherwise, you want to head to our [releases page](https://github.com/DislikesSchool/EduPage2/releases), to download the latest release. We hope to release to the Google Play Store soon, however we currently lack the finances...

If you want to run this code on an iPhone, you will have to download the source code and build it yourself, as we do not have the finances to get an Apple Developer account, and there is no way to distribute iOS apps other than through the App Store at this time.

## Usage

Once you have the app installed, it is as easy as opening up the app, logging in with your EduPage credentials, and watching it load. (It can take a little longer to load for the first time.)

## Roadmap

See the [open issues](https://github.com/DislikesSchool/EduPage2/issues) for a list of proposed features (and known issues).

Or the [project board](https://github.com/orgs/DislikesSchool/projects/1/views/2) for a more organised list of upcoming features.

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

- If you have suggestions for adding or removing projects, feel free to [open an issue](https://github.com/DislikesSchool/EduPage2/issues/new) to discuss it, or directly create a pull request after you edit the _README.md_ file with necessary changes.
- Please make sure you check your spelling and grammar.
- Create individual PR for each suggestion.
- Please also read through the [Code Of Conduct](https://github.com/DislikesSchool/EduPage2/blob/master/CODE_OF_CONDUCT) before posting your first idea as well.

### Translating

If you would like to take part in translating this project into other languages, or help improve existing translations, you can now do so easily using [Weblate](https://hosted.weblate.org/engage/edupage-2/)!

<a href="https://hosted.weblate.org/engage/edupage-2/">
<img src="https://hosted.weblate.org/widget/edupage-2/edupage-2-flutter/multi-auto.svg" alt="Translation status" />
</a>

### Creating A Pull Request

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the GPL-3.0 License. See [LICENSE](https://github.com/DislikesSchool/EduPage2/blob/master/LICENSE) for more information.

## Contributors

- **[vyPal](https://github.com/vyPal)** - _Author of EduPage2_
- **[WattMann](https://github.com/WattMann)** - _Created Edupage API in golang_
- **[czmatejt9](https://github.com/czmatejt9)** - _Helped fix bugs_
- **[SAMUELLL41](https://github.com/SAMUELLL41)** - _Slovak translation_
- **[Ondass](https://www.instagram.com/ondras150/)** - _Old logo_

## Acknowledgements

- [AppIcon](https://www.appicon.co/) - Creation of icons for app
- [LOGO.com](https://logo.com/) - New logo
- [ShaanCoding](https://github.com/ShaanCoding/) - Readme generator
- [Othneil Drew](https://github.com/othneildrew/Best-README-Template) - Readme template
- [ImgShields](https://shields.io/) - Readme shields
