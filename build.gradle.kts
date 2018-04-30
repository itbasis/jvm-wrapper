import com.gradle.scan.plugin.BuildScanExtension
import org.gradle.plugins.ide.idea.model.IdeaModel
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

tasks.withType<Wrapper> {
  distributionType = Wrapper.DistributionType.BIN
  gradleVersion = "4.7"
}

group = "ru.itbasis.jvm-wrapper"

buildscript {
  val kotlinVersion: String by extra
  dependencies {
    classpath(kotlin("gradle-plugin", kotlinVersion))
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
    plugin<IdeaPlugin>()
  }

  configure<IdeaModel> {
    module {
      isDownloadJavadoc = false
      isDownloadSources = false
    }
  }

  repositories {
    jcenter()
  }

}
