# Extraction Notes

This package began as an internal Flutter navigation helper.

## Original Scope

- app-specific back-navigation wrapper with fallback hooks

## Extraction Goals

- remove routing-package coupling
- preserve the modern `PopScope` behavior
- keep the surface area intentionally small

## Good Future Additions

- optional confirmation-guard helpers
- platform-specific behavior notes and examples
- cookbook examples for `go_router` and nested navigators
