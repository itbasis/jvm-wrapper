import org.apache.commons.io.FilenameUtils
import org.gradle.internal.impldep.org.eclipse.jgit.util.Paths
import org.jetbrains.intellij.IntelliJPluginExtension
import org.jetbrains.intellij.tasks.PatchPluginXmlTask
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

tasks.withType(Test::class.java).all {
  useJUnitPlatform {
    includeEngines("junit-jupiter")
  }
  failFast = true
}

tasks.getByPath("check").dependsOn(tasks.withType(VerifyPluginTask::class.java))

configure<IntelliJPluginExtension> {
  version = "2017.3"

  sandboxDirectory = FilenameUtils.concat(rootDir.canonicalPath, ".sandbox")

  pluginName = rootProject.name
}
tasks.withType(PatchPluginXmlTask::class.java).all {
  untilBuild("181.*")
}
tasks.withType(PublishTask::class.java).all {
  setChannels("dev")
  setUsername(project.findProperty("jetbrains.username") as String?)
  setPassword(project.findProperty("jetbrains.password") as String?)
}

dependencies {

  "compile"(kotlin("stdlib-jdk8"))

  // https://stackoverflow.com/questions/49638462/how-to-run-kotlintest-tests-using-the-gradle-kotlin-dsl
  "testImplementation"("org.junit.jupiter:junit-jupiter-api:latest.release")
  "testRuntimeOnly"("org.junit.jupiter:junit-jupiter-engine:latest.release")
  "testImplementation"("org.junit.jupiter:junit-jupiter-params:latest.release")
  "testImplementation"("io.github.glytching:junit-extensions:latest.release")
}
