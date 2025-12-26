# Build Fix for hf_xet Package

## Issue
The `transformers` package depends on `hf_xet`, which uses Cargokit (Rust bindings). When building for Android on Linux CI, it tries to build for all platforms including macOS and fails with:

```
Exception: Missing environment variable CARGOKIT_DARWIN_PLATFORM_NAME
```

## Solution

### For CI/CD (GitHub Actions, etc.)
Add this environment variable to your CI/CD workflow before running the build:

```yaml
env:
  CARGOKIT_DARWIN_PLATFORM_NAME: x86_64
```

### For Local Development
If you encounter this issue locally, you can set it before building:

```bash
export CARGOKIT_DARWIN_PLATFORM_NAME=x86_64
flutter build apk
```

Or add it to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
export CARGOKIT_DARWIN_PLATFORM_NAME=x86_64
```

## Alternative Solution
If setting the environment variable doesn't work, you may need to configure Cargokit to skip macOS builds. This can be done by modifying the `hf_xet` package configuration, but that would require forking the package.

## Note
This is a known issue with packages using Cargokit when building on Linux for Android. The environment variable tells Cargokit what macOS platform to target, even though we're not building for macOS.

