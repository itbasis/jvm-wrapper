package ru.itbasis.plugins.intellij.jvmwrapper

import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.components.ApplicationComponent
import com.intellij.openapi.diagnostic.Logger
import com.intellij.openapi.project.Project
import com.intellij.openapi.project.ProjectManager
import com.intellij.openapi.project.ProjectManagerListener
import com.intellij.openapi.projectRoots.JavaSdk
import com.intellij.openapi.projectRoots.ProjectJdkTable
import com.intellij.openapi.projectRoots.Sdk
import com.intellij.openapi.projectRoots.impl.ProjectJdkImpl
import com.intellij.openapi.projectRoots.impl.SdkConfigurationUtil
import com.intellij.openapi.roots.ProjectRootManager
import java.io.File

class JvmWrapperPlugin : ApplicationComponent {
  companion object {
    @Suppress("unused")
    private val LOG = Logger.getInstance(JvmWrapperPlugin::class.java)
  }

  override fun initComponent() {
    val connection = ApplicationManager.getApplication().messageBus.connect()
    connection.subscribe(ProjectManager.TOPIC, object : ProjectManagerListener {
      override fun projectOpened(project: Project?) {
        if (project == null) return

        val ideaFolder = File(project.baseDir.canonicalPath).resolve(".idea")
        val jvmWrapperScript = ideaFolder.resolveSibling(JvmWrapper.SCRIPT_FILE_NAME)
        if (!jvmWrapperScript.exists()) return

        val jvmWrapper = JvmWrapper(projectDir = File(project.baseDir.canonicalPath))

        val projectJdkTable = ProjectJdkTable.getInstance()

        ApplicationManager.getApplication().runWriteAction {
          var findJdk: Sdk? = projectJdkTable.findJdk(jvmWrapper.sdkName)
          while (findJdk != null) {
            projectJdkTable.removeJdk(findJdk)
            findJdk = projectJdkTable.findJdk(jvmWrapper.sdkName)
          }
        }

        val sdk = SdkConfigurationUtil.createAndAddSDK(jvmWrapper.jdkHomeDir.absolutePath, JavaSdk.getInstance()) as ProjectJdkImpl
        val wrapperSdk = sdk.clone()
        wrapperSdk.name = jvmWrapper.sdkName
        projectJdkTable.updateJdk(sdk, wrapperSdk)

        ApplicationManager.getApplication().runWriteAction {
          ProjectRootManager.getInstance(project).projectSdk = wrapperSdk
        }
      }
    })
  }
}
