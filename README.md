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

Usage:
```
./gradlew run --args='/path/to/android-studio /path/to/kotlin-plugin /path/to/out/dir'
```

This will create several files inside `/path/to/out/dir`:
```
all-errors-before.txt
all-errors-after.txt
diff.txt
...
```

The file `diff.txt` will show all binary compatibility issues introduced by the new Kotlin plugin.

See [here](https://github.com/gharrma/android-studio-kotlin-verifier/commit/c1ebd0264e77f029758e1cf59d3f3d47f00c4d55) for an example diff showing incompatibilities between Android Studio Arctic Fox and Kotlin plugin 1.5.30-M1.
