import org.apache.commons.io.FileUtils
import org.apache.commons.io.FilenameUtils
import org.gradle.internal.impldep.org.eclipse.jgit.util.Paths
import org.jetbrains.intellij.IntelliJPluginExtension
import org.jetbrains.intellij.tasks.PatchPluginXmlTask
import org.jetbrains.intellij.tasks.PrepareSandboxTask
import org.jetbrains.intellij.tasks.PublishTask
import org.jetbrains.intellij.tasks.VerifyPluginTask
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.jetbrains.kotlin.gradle.plugin.KotlinPlatformJvmPlugin

buildscript {
  repositories {
    jcenter()
    gradlePluginPortal()
  }
  dependencies {
    classpath("gradle.plugin.org.jetbrains.intellij.plugins:gradle-intellij-plugin:latest.release")
    classpath("gradle.plugin.org.jlleitschuh.gradle:ktlint-gradle:latest.release")
  }
}

apply {
  plugin<KotlinPlatformJvmPlugin>()
  plugin("org.jetbrains.intellij")
  plugin("org.jlleitschuh.gradle.ktlint")
}

configure<JavaPluginConvention> {
  sourceCompatibility = JavaVersion.VERSION_1_8
}

tasks.withType(KotlinCompile::class.java).all {
  kotlinOptions {
    jvmTarget = JavaVersion.VERSION_1_8.toString()
  }
}

tasks.getByPath("check").dependsOn(tasks.withType(VerifyPluginTask::class.java))

configure<IntelliJPluginExtension> {
  version = "2017.3"

  sandboxDirectory = FilenameUtils.concat(rootDir.canonicalPath, ".sandbox")

  pluginName = rootProject.name
}

tasks.withType(PatchPluginXmlTask::class.java).all {
  untilBuild("182.*")
}

tasks.withType(PrepareSandboxTask::class.java) {
  doFirst {
    File(configDirectory.parentFile, "/system/log").takeIf { it.isDirectory }?.deleteRecursively()
  }
}

tasks.withType(PublishTask::class.java).all {
  setChannels("dev")
  setUsername(project.findProperty("jetbrains.username") as String?)
  setPassword(project.findProperty("jetbrains.password") as String?)
}

dependencies {
  "compile"(project(":plugin-common"))

  "compile"(group = "com.github.shafirov.klogging", name = "klogging.jvm")

//  "compile"(kotlin("stdlib-jdk8"))

//  "testImplementation"(group = "io.kotlintest", name = "kotlintest-runner-junit4")
  "testImplementation"(group = "org.mockito", name = "mockito-junit-jupiter")
}
