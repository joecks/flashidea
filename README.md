# Blitz Idea


## Publish next version

### Common

1. Run build runner
```bash 
flutter pub run build_runner build  --delete-conflicting-outputs
```
2. Change pubspec.yaml

```diff
+ version: 1.0.2+3
- version: 1.0.1+2
```

### Android

```bash
flutter build appbundle --release
```