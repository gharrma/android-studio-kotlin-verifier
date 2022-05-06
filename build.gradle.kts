plugins {
    kotlin("jvm") version "1.5.21"
    id("application")
}

application {
    mainClass.set("com.android.tools.experimental.StudioKotlinVerifier")
}

repositories {
    maven("https://packages.jetbrains.team/maven/p/intellij-plugin-verifier/intellij-plugin-verifier/")
    maven("https://cache-redirector.jetbrains.com/intellij-dependencies/")
    maven("https://www.jetbrains.com/intellij-repository/releases/")
    mavenCentral()
}

dependencies {
    implementation("org.jetbrains.intellij.plugins:verifier-cli:1.278")
}

java {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
}

tasks.compileKotlin {
    kotlinOptions.jvmTarget = "11"
}

tasks.compileTestKotlin {
    kotlinOptions.jvmTarget = "11"
}
