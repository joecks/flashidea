# Blitz Idea


## Publish next version

### Common

1. Run build runner
```bash 
fastlane build_runner
```
2. Change tag

```bash
git tag 1.1.0
```

### Android

```bash
fastlane publish platform:android android_output:appbundle build_type:release
```

### iOS

```bash
fastlane publish platform:ios build_type:release
```