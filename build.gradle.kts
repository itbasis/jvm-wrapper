import com.gradle.scan.plugin.BuildScanExtension
import io.gitlab.arturbosch.detekt.DetektCheckTask
import io.gitlab.arturbosch.detekt.DetektPlugin
import io.gitlab.arturbosch.detekt.extensions.DetektExtension
import io.gitlab.arturbosch.detekt.extensions.ProfileExtension
import org.gradle.plugins.ide.idea.model.IdeaModel
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

tasks.withType<Wrapper> {
  distributionType = Wrapper.DistributionType.BIN
//  gradleVersion = "4.8-rc-1"
  gradleVersion = "4.7"
}

group = "ru.itbasis.jvm-wrapper"

buildscript {
  val kotlinVersion: String by extra
  dependencies {
    classpath(kotlin("gradle-plugin", kotlinVersion))
    classpath("gradle.plugin.io.gitlab.arturbosch.detekt:detekt-gradle-plugin:latest.release")
  }
}
plugins {
  `build-scan`
}
apply {
  plugin<IdeaPlugin>()
}

configure<BuildScanExtension> {
  setTermsOfServiceUrl("https://gradle.com/terms-of-service")
  setTermsOfServiceAgree("yes")

  if (!System.getenv("CI").isNullOrEmpty()) {
    publishAlways()
    tag("CI")
  }
}

configure<IdeaModel> {
  project {
    vcs = "Git"
  }
}

allprojects {
  version = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmm"))

  apply {
    from("$rootDir/gradle/dependencies.gradle.kts")
    plugin<BasePlugin>()
//    plugin<DetektPlugin>()
  }

//  configure<DetektExtension> {
//    this.defaultProfile()
//  }

  tasks.withType<DetektCheckTask> {
    //    input = projectDir.resolve("src/main/kotlin")
    tasks.findByName(LifecycleBasePlugin.CHECK_TASK_NAME)?.dependsOn(this)
  }

  repositories {
    jcenter()
  }
}
