<br/>
<p align="center">
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

[![build-release-android](https://github.com/DislikesSchool/EduPage2/actions/workflows/build-release-apk.yml/badge.svg)](https://github.com/DislikesSchool/EduPage2/actions/workflows/build-release-apk.yml) ![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/dislikesschool/edupage2) ![Downloads](https://img.shields.io/github/downloads/DislikesSchool/EduPage2/total) ![Contributors](https://img.shields.io/github/contributors/DislikesSchool/EduPage2?color=dark-green) ![Issues](https://img.shields.io/github/issues/DislikesSchool/EduPage2) ![License](https://img.shields.io/github/license/DislikesSchool/EduPage2)

## Table Of Contents

- [Table Of Contents](#table-of-contents)
- [About The Project](#about-the-project)
- [Built With](#built-with)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
  - [Creating A Pull Request](#creating-a-pull-request)
- [License](#license)
- [Authors](#authors)
- [Acknowledgements](#acknowledgements)

## About The Project

If you have ever used EduPage, you already know that it's slow. And not just on the school WiFi network, where there are hundreds or thousands of other people, using the network at the same time, but also on your home network, which should be faster right? Well, your network is in most cases faster than the school network, which indicates, that the issue is not on our side, but rather EduPage's servers just being slow.

And that's why we made EduPage2. So far, EduPage 2 lacks a pretty big amount of features, that are included in the official app. But don't worry! With almost dayly updates, we are constantly releasing new features, and optimising the existing ones.

EduPage2 uses local caching on your device, and a caching server with our own privte software, which periodically updates data from EduPage, strips it of all useless data (which EduPage includes for some reason), and finally sends out to your device when requested.

**IMPORTANT** EduPage2 is a cutom client for EduPage. We do not have any connection to EduPage.

## Built With

This is a list of all the main tools, libraries and frameworks, that were used in this project

- [Firebase](https://firebase.google.com/)
- [OneSignal](https://onesignal.com/)
- [Flutter](https://flutter.dev/)
- [Express.js](https://expressjs.com/)
- [PlanetScale](https://planetscale.com/)
- [Passport.js](https://www.passportjs.org/)

## Getting Started

All our backend stuff is luckily managed by us, which makes getting started very esasy for you.

### Prerequisites

Make sure that you already have an EduPage account. Since this is a client, you need to already have an account at EduPage, to use EduPage2

### Installation

If you want to build the code yourself, all the code is provided in this repository, you can download it, and build it on your own machine.

Otherwise, you want to head to our [releases page](https://github.com/DislikesSchool/EduPage2/releases), to download the latest release. We hope to release to the Google Play Store soon, however we currently lack the finances..

If you want to run this code on an iPhone, you will have to download the source code and build it yourself, as we do not have the finances to get a Apple Developer account, and there is no way to distribute iOS apps other than through the App Store at this time.

## Usage

Once you have the app installed, it is as easy as opening up the app, logging in with your EduPage credentials, and watching it load. (It can take a little longer to load for the first time)

## Roadmap

See the [open issues](https://github.com/DislikesSchool/EduPage2/issues) for a list of proposed features (and known issues).

Or the [project board](https://github.com/orgs/DislikesSchool/projects/1/views/2) for a more organised list of upcoming features

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

- If you have suggestions for adding or removing projects, feel free to [open an issue](https://github.com/DislikesSchool/EduPage2/issues/new) to discuss it, or directly create a pull request after you edit the _README.md_ file with necessary changes.
- Please make sure you check your spelling and grammar.
- Create individual PR for each suggestion.
- Please also read through the [Code Of Conduct](https://github.com/DislikesSchool/EduPage2/blob/master/CODE_OF_CONDUCT) before posting your first idea as well.

### Creating A Pull Request

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See [LICENSE](https://github.com/DislikesSchool/EduPage2/blob/master/LICENSE) for more information.

## Authors

- **vyPal** - _A highschool student, who is bored_ - [vyPal](https://github.com/vyPal) - _Author of EduPage2_
- **czmatejt9** - _Friend_ - [czmatejt9](https://github.com/czmatejt9) - _Helped fix bugs_

## Acknowledgements

- [ShaanCoding](https://github.com/ShaanCoding/)
- [Othneil Drew](https://github.com/othneildrew/Best-README-Template)
- [ImgShields](https://shields.io/)
