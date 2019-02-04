@file:Suppress("UnstableApiUsage")

package ru.itbasis.gradle.plugins.travis_ci

import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.api.plugins.JavaPlugin
import org.gradle.kotlin.dsl.getValue
import org.gradle.kotlin.dsl.invoke
import org.gradle.kotlin.dsl.register

class TravisCIPlugin : Plugin<Project> {
  override fun apply(target: Project): Unit = target.run {
    require(target == rootProject) { "The plugin can be applied only to the root project." }

    tasks {
      val generateConfig by register<GenerateConfigFile>(GenerateConfigFile.TASK_NAME) {
        group = GROUP_NAME

        outputFile.set(layout.projectDirectory.file(".travis.yml"))
      }

      maybeCreate(JavaPlugin.PROCESS_RESOURCES_TASK_NAME).dependsOn(generateConfig)
    }
  }

  companion object {
    const val GROUP_NAME = "ci"

    enum class SUPPORTED_OS {
      ANY, LINUX, OSX
    }
  }
}
