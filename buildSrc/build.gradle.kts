@file:Suppress("UnstableApiUsage")

plugins {
  `kotlin-dsl`
}

kotlinDslPluginOptions {
  experimentalWarning.set(false)
}

repositories {
  gradlePluginPortal()
  mavenCentral()
  jcenter()
}

val kotlinVersion = "1.3.+"

dependencies {
  implementation("org.jetbrains.kotlin:kotlin-gradle-plugin:+")

  implementation("io.gitlab.arturbosch.detekt:detekt-gradle-plugin:+")
  implementation("io.kotlintest:kotlintest-gradle-plugin:+")

// TODO  implementation("gradle.plugin.org.jetbrains.intellij.plugins:gradle-intellij-plugin:+")
}

gradlePlugin {
  plugins {
    register("travis-ci-plugin") {
      id = "travis-ci"
      implementationClass = "ru.itbasis.gradle.plugins.travis_ci.TravisCIPlugin"
    }
  }
}
