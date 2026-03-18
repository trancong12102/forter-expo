const {
  withDangerousMod,
  withProjectBuildGradle,
} = require('expo/config-plugins');
const fs = require('fs');
const path = require('path');

const FORTER_POD_SOURCE =
  "source 'https://bitbucket.org/forter-mobile/forter-ios-specs'";

function withForterIOS(config) {
  return withDangerousMod(config, [
    'ios',
    (cfg) => {
      const podfilePath = path.join(
        cfg.modRequest.platformProjectRoot,
        'Podfile',
      );
      let podfileContents = fs.readFileSync(podfilePath, 'utf8');

      if (!podfileContents.includes(FORTER_POD_SOURCE)) {
        podfileContents = FORTER_POD_SOURCE + '\n' + podfileContents;
      }

      fs.writeFileSync(podfilePath, podfileContents);
      return cfg;
    },
  ]);
}

const FORTER_MAVEN_REPO = `        maven {
            url "https://mobile-sdks.forter.com/android"
            credentials {
                username "forter-android-sdk"
                password "HvYumAfjVQYQFyoGsmNAefGdR84Esqig"
            }
        }`;

function withForterAndroid(config) {
  return withProjectBuildGradle(config, (cfg) => {
    if (!cfg.modResults.contents.includes('mobile-sdks.forter.com')) {
      cfg.modResults.contents = cfg.modResults.contents.replace(
        /allprojects\s*\{[\s\S]*?repositories\s*\{/,
        (match) => match + '\n' + FORTER_MAVEN_REPO,
      );
    }
    return cfg;
  });
}

module.exports = (config) => {
  config = withForterIOS(config);
  config = withForterAndroid(config);
  return config;
};
