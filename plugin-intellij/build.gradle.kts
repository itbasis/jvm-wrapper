import org.apache.commons.io.FilenameUtils
import org.gradle.internal.impldep.org.eclipse.jgit.util.Paths
import org.gradle.plugins.ide.idea.model.IdeaModel
import org.jetbrains.intellij.IntelliJPluginExtension
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

//import org.junit.platform.gradle.plugin.JUnitPlatformExtension
//import org.junit.platform.console.options.Details


buildscript {
  repositories {
    jcenter()
    gradlePluginPortal()
  }
  dependencies {
    classpath("gradle.plugin.org.jetbrains.intellij.plugins:gradle-intellij-plugin:latest.release")
    classpath("gradle.plugin.org.jlleitschuh.gradle:ktlint-gradle:latest.release")
    classpath("org.junit.platform:junit-platform-gradle-plugin:latest.release")
  }
}

plugins {
  idea
  kotlin("jvm") version embeddedKotlinVersion
}
apply {
  plugin("org.jetbrains.intellij")
  plugin("org.jlleitschuh.gradle.ktlint")
  plugin("org.junit.platform.gradle.plugin")
}

configure<JavaPluginConvention> {
  sourceCompatibility = JavaVersion.VERSION_1_8
}

configure<IdeaModel> {
  module {
    isDownloadJavadoc = false
    isDownloadSources = false
  }
}

tasks.withType(KotlinCompile::class.java).all {
  kotlinOptions {
    jvmTarget = JavaVersion.VERSION_1_8.toString()
  }
}

//extensions.getByType(JUnitPlatformExtension::class.java).apply {
//  filters {
//    engines {
//      include("junit-jupiter")
//    }
//  }
////    logManager = "org.apache.logging.log4j.jul.LogManager"
//  details = Details.TREE
//}

configure<IntelliJPluginExtension> {
  version = "2017.3"

  sandboxDirectory = FilenameUtils.concat(rootDir.canonicalPath, ".sandbox")

  pluginName = "jvm-wrapper"
}

repositories {
  jcenter()
}

dependencies {
  //  "compile"(project(":library"))

  implementation(kotlin("stdlib-jdk8"))

  testImplementation("org.junit.jupiter:junit-jupiter-api:latest.release")
  testImplementation("org.junit.jupiter:junit-jupiter-params:latest.release")
  testImplementation("org.junit.jupiter:junit-jupiter-engine:latest.release")
  testImplementation("io.github.glytching:junit-extensions:latest.release")
}
