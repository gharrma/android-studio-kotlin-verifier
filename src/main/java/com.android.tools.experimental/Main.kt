@file:JvmName("Main")

package com.android.tools.experimental

import com.jetbrains.pluginverifier.PluginVerifierMain
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import kotlin.io.path.*
import kotlin.streams.toList

/**
 * Runs the IntelliJ Plugin Verifier twice: once with the bundled Kotlin plugin,
 * and again with a 'new' Kotlin plugin. The diff between the results can help
 * catch binary compatibility issues (especially for plugins which depend on the
 * Kotlin plugin).
 */
fun main(args: Array<String>) {
    if (args.size != 3) error("Usage: run /path/to/android-studio /path/to/kotlin-plugin /path/to/output/dir")

    val (idePath, newKotlinPluginPath, outDirPath) = args
    val ide = Paths.get(idePath)
    val newKotlinPlugin = Paths.get(newKotlinPluginPath)
    val outDir = Paths.get(outDirPath)

    val verifierHome = outDir.resolve("verifier-home")
    val bundledPlugins = Files.list(ide.resolve("plugins")).toList()

    // First run on all bundled plugins.
    val reportDirBefore = outDir.resolve("verifier-report-before")
    val errorsBefore = outDir.resolve("all-errors-before.txt")
    runPluginVerifier(
        ideHome = ide,
        plugins = bundledPlugins,
        reportDir = reportDirBefore,
        verifierHome = verifierHome,
    )
    writeAllVerifierErrors(reportDirBefore, errorsBefore)

    // Run again, but swap out the Kotlin plugin.
    val reportDirAfter = outDir.resolve("verifier-report-after")
    val errorsAfter = outDir.resolve("all-errors-after.txt")
    runPluginVerifier(
        ideHome = ide,
        plugins = bundledPlugins.filterNot { it.name == "Kotlin" } + listOf(newKotlinPlugin),
        reportDir = reportDirAfter,
        verifierHome = verifierHome,
    )
    writeAllVerifierErrors(reportDirAfter, errorsAfter)

    // Diff the results.
    val diff = outDir.resolve("diff.txt")
    println("Writing a diff at $diff")
    ProcessBuilder("diff", errorsBefore.pathString, errorsAfter.pathString)
        .redirectOutput(diff.toFile())
        .start()
        .waitFor()
}

fun runPluginVerifier(ideHome: Path, plugins: List<Path>, reportDir: Path, verifierHome: Path) {
    val pluginList = plugins.joinToString("\n", postfix = "\n")
    println("Verifying ${plugins.size} plugins:\n$pluginList")

    val pluginListFile = createTempFile()
    pluginListFile.writeText(pluginList)

    val verifierArgs = arrayOf(
        "check-plugin",
        "@$pluginListFile",
        "-offline",
        "-verification-reports-dir",
        reportDir.pathString,
        "-runtime-dir",
        ideHome.resolve("jre").pathString,
        ideHome.pathString,
    )

    System.setProperty("plugin.verifier.home.dir", verifierHome.pathString)
    PluginVerifierMain.main(verifierArgs)
}

/** Concatenates all errors found into a single file. */
fun writeAllVerifierErrors(reportDir: Path, out: Path) {
    val errorFiles = Files.walk(reportDir).toList()
        .filter { it.name == "compatibility-problems.txt" || it.name == "invalid-plugin.txt" }
        .sortedBy { it.pathString }

    println("Concatenating ${errorFiles.size} error reports")
    val concatenated = buildString {
        for (report in errorFiles) {
            val pluginId = report.parent?.parent?.name ?: "<unknown>"
            appendLine("================================================")
            appendLine("Plugin: $pluginId")
            appendLine("================================================")
            append(report.readText())
            append("\n\n\n")
        }
    }

    out.writeText(concatenated)
}
