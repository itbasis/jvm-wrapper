plugins {
  id("org.jetbrains.intellij")
}

intellij {
//  version = IntelliJPlugin.DEFAULT_IDEA_VERSION
  // https://www.jetbrains.com/intellij-repository/releases/
  version = "2018.1.6"
  logger.lifecycle("IntelliJ version: ${this.version}")
  sandboxDirectory = projectDir.resolve(".sandbox-${this.version}").absolutePath
//  setPlugins("com.intellij")
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
