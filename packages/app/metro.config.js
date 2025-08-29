const { wrapWithReanimatedMetroConfig } = require('react-native-reanimated/metro-config');
const path = require('path');
const { getSentryExpoConfig } = require('@sentry/react-native/metro');

const config = getSentryExpoConfig(__dirname, {
    annotateReactComponents: true,
});

config.resolver.unstable_enablePackageExports = true;

// https://docs.expo.dev/guides/monorepos/
const projectRoot = __dirname;
const monorepoRoot = path.resolve(projectRoot, '..');
const monorepoPackages = {
    '@archive/shared': path.resolve(monorepoRoot, 'shared'),
};

config.watchFolders = [projectRoot, ...Object.values(monorepoPackages)];
config.resolver.extraNodeModules = monorepoPackages;
config.resolver.nodeModulesPaths = [path.resolve(projectRoot, 'node_modules'), path.resolve(monorepoRoot, 'node_modules')];

module.exports = wrapWithReanimatedMetroConfig(config);