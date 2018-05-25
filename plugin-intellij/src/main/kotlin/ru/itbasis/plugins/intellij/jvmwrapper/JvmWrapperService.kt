package ru.itbasis.plugins.intellij.jvmwrapper

import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.application.Result
import com.intellij.openapi.application.WriteAction
import com.intellij.openapi.components.ServiceManager
import com.intellij.openapi.progress.ProgressIndicator
import com.intellij.openapi.progress.ProgressManager
import com.intellij.openapi.progress.Task
import com.intellij.openapi.project.Project
import com.intellij.openapi.projectRoots.JavaSdk
import com.intellij.openapi.projectRoots.ProjectJdkTable
import com.intellij.openapi.projectRoots.Sdk
import com.intellij.openapi.projectRoots.impl.ProjectJdkImpl
import com.intellij.openapi.projectRoots.impl.SdkConfigurationUtil
import com.intellij.openapi.roots.ProjectRootManager
import com.intellij.openapi.roots.impl.LanguageLevelProjectExtensionImpl
import com.intellij.openapi.roots.impl.ProjectRootManagerImpl
import com.twelvemonkeys.io.FileUtil
import ru.itbasis.jvmwrapper.core.JVMW_PROPERTY_FILE_NAME
import ru.itbasis.jvmwrapper.core.JvmWrapper
import ru.itbasis.jvmwrapper.core.ProcessStepListener
import ru.itbasis.jvmwrapper.core.vendor.DownloadProcessListener
import java.io.File

class JvmWrapperService(
  private val project: Project,
  private val javaSdk: JavaSdk,
  private val projectJdkTable: ProjectJdkTable
) {
  companion object {
    @JvmStatic
    fun getInstance(project: Project): JvmWrapperService = ServiceManager.getService(project, JvmWrapperService::class.java)
  }

  fun hasWrapper(): Boolean {
    return true
  }

  fun getWrapper(): JvmWrapper? {
    var result: JvmWrapper? = null
    ProgressManager.getInstance().run(object : Task.Backgroundable(project, "JVM Wrapper") {
      override fun run(progressIndicator: ProgressIndicator) {
        result = JvmWrapper(
          workingDir = File(project.baseDir.takeIf { it.findChild(JVMW_PROPERTY_FILE_NAME) != null }!!.canonicalPath),
          stepListener = stepListener(progressIndicator),
          downloadProcessListener = downloadProcessListener(progressIndicator)
        )
      }
    })
    return result
  }

  private fun getSdk(): Sdk? {
    return object : WriteAction<Sdk>() {
      override fun run(result: Result<Sdk>) {
        val wrapper = getWrapper() ?: return
        val sdkName = "${JvmWrapper.SCRIPT_FILE_NAME}-${wrapper.jvmName}"

        var findJdk = projectJdkTable.findJdk(sdkName)
        while (findJdk != null) {
          projectJdkTable.removeJdk(findJdk)
          findJdk = projectJdkTable.findJdk(sdkName)
        }
//
        val sdk = SdkConfigurationUtil.createAndAddSDK(wrapper.jvmHomeDir.absolutePath, javaSdk) as ProjectJdkImpl
        val wrapperSdk = sdk.clone().apply { name = sdkName }
        projectJdkTable.updateJdk(sdk, wrapperSdk)
        result.setResult(wrapperSdk)
      }
    }.execute().resultObject
  }

  fun updateProjectSdk(wrapperSdk: Sdk? = getSdk()) {
    if (wrapperSdk == null) return

    ApplicationManager.getApplication().runWriteAction {
      (ProjectRootManager.getInstance(project) as ProjectRootManagerImpl).projectSdk = wrapperSdk
//
      LanguageLevelProjectExtensionImpl.getInstanceImpl(project).default = true
      LanguageLevelProjectExtensionImpl.MyProjectExtension(project).projectSdkChanged(wrapperSdk)
    }
  }

  fun refresh() {
    if (hasWrapper()) updateProjectSdk()
  }

  private fun stepListener(progressIndicator: ProgressIndicator): ProcessStepListener = { msg ->
    ProgressManager.checkCanceled()

    progressIndicator.run {
      fraction = 0.0
      text = msg
    }
  }

  private fun downloadProcessListener(progressIndicator: ProgressIndicator): DownloadProcessListener = { (url), sizeCurrent, sizeTotal ->
    progressIndicator.run {
      ProgressManager.checkCanceled()
      val percentage = sizeCurrent.toDouble() / sizeTotal
      fraction = percentage
      text = "%s / %s (%.2f%%) < %s".format(
        FileUtil.toHumanReadableSize(sizeCurrent),
        FileUtil.toHumanReadableSize(sizeTotal), percentage * 100, url
      )
      return@run this.isRunning
    }
  }
}
