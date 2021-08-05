A simple tool to verify binary compatibility between Android Studio and
new Kotlin plugins.

It uses the IntelliJ Plugin Verifier to find compatibility issues---not
just in the Kotlin plugin, but in *all* bundled plugins
(because some bundled plugins depend on Kotlin). The final
result is essentially a concatenation of the compatibility-problems.txt
files produced by the verifier.

Since there are false positives, we actually run the verifier twice:
once with the old Kotlin plugin, and again with the new one. Then
we diff the results.
