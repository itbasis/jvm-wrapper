import org.gradle.api.tasks.wrapper.Wrapper.DistributionType.ALL

plugins {
  `travis-ci`

  id("org.jetbrains.intellij") version "0.4.3" apply false
}

tasks {
  wrapper {
    distributionType = ALL
  }
}

allprojects {
  version = rootDir.resolve("version.txt").readLines().first()

  repositories {
    mavenCentral()
    jcenter()
  }
}
