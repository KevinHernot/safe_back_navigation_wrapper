# Extraction Notes

This package was extracted from Hopen's Flutter client.

## Original Source

- `hopen/lib/presentation/widgets/safe_back_navigation_wrapper.dart`

## Extraction Goals

- remove routing-package coupling
- preserve the modern `PopScope` behavior
- keep the surface area intentionally small

## Good Future Additions

- optional confirmation-guard helpers
- platform-specific behavior notes and examples
- cookbook examples for `go_router` and nested navigators
