targets:
  $default:
    builders:
      json_serializable:
        enabled: true
        generate_for:
          include:
            - lib/**.model.dart
            - lib/**_bloc.dart
            - lib/**_cubit.dart
      freezed|freezed:
        enabled: true
        generate_for:
          include: # https://stackoverflow.com/questions/66664166/flutter-build-runner-build-for-specific-file-extensions-in-build-yaml
          - lib/**_bloc.dart
          - lib/**_event.dart
          - lib/**_state.dart
          - lib/**_cubit.dart
          - lib/**.model.dart
      injectable_generator:injectable_builder:
        enabled: true
        generate_for:
          include:
            - lib/**_bloc.dart
            - lib/**_cubit.dart
            - lib/**.dao.dart
        options:
          explicit_to_json: true
          include_if_null: false
          delete_conflicting_outputs: true
          track_dependencies: true