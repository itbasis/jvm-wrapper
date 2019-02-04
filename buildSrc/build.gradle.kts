@file:Suppress("UnstableApiUsage")

plugins {
  `kotlin-dsl`
}

kotlinDslPluginOptions {
  experimentalWarning.set(false)
}

repositories {
  jcenter()
  gradlePluginPortal()
}

val kotlinVersion = "1.3.20"

dependencies {
  implementation("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
  implementation("io.gitlab.arturbosch.detekt:detekt-gradle-plugin:1.0.0-RC12")
}

gradlePlugin {
  plugins {
    register("travis-ci-plugin") {
      id = "travis-ci"
      implementationClass = "ru.itbasis.gradle.plugins.travis_ci.TravisCIPlugin"
    }
  }
}
