import com.gradle.scan.plugin.BuildScanExtension
import org.gradle.plugins.ide.idea.model.IdeaModel
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

tasks.withType<Wrapper> {
  distributionType = Wrapper.DistributionType.BIN
  gradleVersion = "4.7-rc-2"
}

group = "ru.itbasis.jvm-wrapper"

plugins {
  `build-scan`
  idea
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
}
