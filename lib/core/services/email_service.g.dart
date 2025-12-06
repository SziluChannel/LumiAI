// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EmailService)
const emailServiceProvider = EmailServiceProvider._();

final class EmailServiceProvider
    extends $AsyncNotifierProvider<EmailService, void> {
  const EmailServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emailServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emailServiceHash();

  @$internal
  @override
  EmailService create() => EmailService();
}

String _$emailServiceHash() => r'61335d4f10518e8d3c79b8c079c02439db7840c7';

abstract class _$EmailService extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
