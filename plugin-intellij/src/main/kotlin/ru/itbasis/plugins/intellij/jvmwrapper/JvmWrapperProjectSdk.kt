package ru.itbasis.plugins.intellij.jvmwrapper

import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.components.AbstractProjectComponent
import com.intellij.openapi.externalSystem.service.project.IdeModifiableModelsProviderImpl
import com.intellij.openapi.module.ModuleManager
import com.intellij.openapi.project.Project
import com.intellij.openapi.projectRoots.JavaSdk
import com.intellij.openapi.projectRoots.ProjectJdkTable
import com.intellij.openapi.projectRoots.Sdk
import com.intellij.openapi.projectRoots.impl.ProjectJdkImpl
import com.intellij.openapi.projectRoots.impl.SdkConfigurationUtil
import com.intellij.openapi.roots.LanguageLevelModuleExtensionImpl
import com.intellij.openapi.roots.ProjectRootManager
import com.intellij.openapi.roots.impl.LanguageLevelProjectExtensionImpl
import com.intellij.openapi.roots.impl.ProjectRootManagerImpl
import java.io.File

class JvmWrapperProjectSdk(
  project: Project,
  private val javaSdk: JavaSdk,
  private val projectJdkTable: ProjectJdkTable
) :
  AbstractProjectComponent(project) {
  override fun projectOpened() {
    val ideaFolder = File(myProject.baseDir.canonicalPath).resolve(".idea")
    val jvmWrapperScript = ideaFolder.resolveSibling(JvmWrapper.SCRIPT_FILE_NAME)
    if (!jvmWrapperScript.exists()) return

    val jvmWrapper = JvmWrapper(projectDir = File(myProject.baseDir.canonicalPath))

    ApplicationManager.getApplication().runWriteAction {
      var findJdk: Sdk? = projectJdkTable.findJdk(jvmWrapper.sdkName)
      while (findJdk != null) {
        projectJdkTable.removeJdk(findJdk)
        findJdk = projectJdkTable.findJdk(jvmWrapper.sdkName)
      }
//
      val sdk = SdkConfigurationUtil.createAndAddSDK(jvmWrapper.jdkHomeDir.absolutePath, javaSdk) as ProjectJdkImpl
      val wrapperSdk = sdk.clone().apply { name = jvmWrapper.sdkName }
      projectJdkTable.updateJdk(sdk, wrapperSdk)
//
      (ProjectRootManager.getInstance(myProject) as ProjectRootManagerImpl).projectSdk = wrapperSdk
//
      LanguageLevelProjectExtensionImpl.getInstanceImpl(myProject).default = true
      LanguageLevelProjectExtensionImpl.MyProjectExtension(myProject).projectSdkChanged(wrapperSdk)
//
      val moduleModel = ModuleManager.getInstance(myProject).modifiableModel
      moduleModel.apply {
        modules.forEach { module ->
          IdeModifiableModelsProviderImpl(myProject).getModifiableRootModel(module).apply {
            setSdk(wrapperSdk)
            inheritSdk()
            commit()
          }
//
          (LanguageLevelModuleExtensionImpl.getInstance(module).getModifiableModel(true) as LanguageLevelModuleExtensionImpl).apply {
            languageLevel = null
            commit()
          }
        }
        commit()
      }
    }
  }
}
