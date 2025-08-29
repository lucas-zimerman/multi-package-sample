set -x -e

LOCAL_NODE_BINARY="node"
if [ -z "$SENTRY_CLI_EXECUTABLE" ]; then
  # Try standard resolution safely
  RESOLVED_PATH=$(
    "$LOCAL_NODE_BINARY" --print "require('path').dirname(require.resolve('@sentry/cli/package.json'))" 2>/dev/null
  ) || true
  
  if [ $? -eq 0 ] && [ -n "$RESOLVED_PATH" ]; then
    SENTRY_CLI_PACKAGE_PATH="$RESOLVED_PATH"
  else
    # Fallback: parse NODE_PATH from the .bin/sentry-cli shim
    PNPM_BIN_PATH="$PWD/node_modules/@sentry/react-native/node_modules/.bin/sentry-cli"

    if [ -f "$PNPM_BIN_PATH" ]; then
      CLI_FILE_TEXT=$(cat "$PNPM_BIN_PATH")

      #Filter where PNPM stored @Sentry/Cli
      NODE_PATH_LINE=$(echo "$CLI_FILE_TEXT" | grep -oE 'NODE_PATH="[^"]+"' | head -n1)
      NODE_PATH_VALUE=$(echo "$NODE_PATH_LINE" | sed -E 's/^NODE_PATH="([^"]+)".*/\1/')
      SENTRY_CLI_PACKAGE_PATH=${NODE_PATH_VALUE%%/bin*}
    fi
  fi
fi
echo $SENTRY_CLI_PACKAGE_PATH