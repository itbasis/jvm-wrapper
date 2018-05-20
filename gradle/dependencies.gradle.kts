import org.gradle.plugins.ide.idea.model.IdeaModel

val junitVersion: String by extra
val kotlinVersion: String by extra
val kotlinTestVersion: String by extra

apply {
  plugin<IdeaPlugin>()
}

configure<IdeaModel> {
  module {
    isDownloadJavadoc = false
    isDownloadSources = false
  }
}

configurations.all {
  resolutionStrategy {
    failOnVersionConflict()

    eachDependency {
      when (requested.group) {
        "org.junit.jupiter" -> useVersion(junitVersion)
        "org.junit.vintage" -> useVersion(junitVersion)
        "org.junit.platform" -> useVersion("1.1.1")
        "org.mockito" -> useVersion("2.18.3")
        "org.opentest4j" -> useVersion("1.1.0")
        "org.objenesis" -> useVersion("2.6")
        "org.jetbrains.kotlin" -> useVersion(kotlinVersion)
        "io.kotlintest" -> useVersion(kotlinTestVersion)
      }
    }
  }
}
