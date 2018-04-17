import com.gradle.scan.plugin.BuildScanExtension
import org.gradle.plugins.ide.idea.model.IdeaModel

tasks.withType<Wrapper> {
  distributionType = Wrapper.DistributionType.BIN
  gradleVersion = "4.6"
}

group = "ru.itbasis.jvm-wrapper"
version = "20180331_1212"

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
