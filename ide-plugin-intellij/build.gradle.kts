import org.jetbrains.intellij.IntelliJPlugin

plugins {
  id("org.jetbrains.intellij")
}

intellij {
  //  setPlugins("org.jetbrains.java")
//  version = IntelliJPlugin.DEFAULT_IDEA_VERSION
  version = "2018.1.6"
  logger.lifecycle("IntelliJ version: ${this.version}")
  sandboxDirectory = projectDir.resolve(".sandbox-${this.version}").absolutePath
}

tasks {
  prepareSandbox {
    doFirst {
      configDirectory.resolve("system/log").deleteRecursively()
    }
  }

  patchPluginXml {
    untilBuild("184.*")
    setVersion(project.version)
  }
}
