package ru.itbasis.plugins.intellij.jvmwrapper

import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent

class JvmUpdaterAction : AnAction("Refresh") {
  override fun update(event: AnActionEvent) {
    event.presentation.isEnabledAndVisible = JvmWrapperService.getInstance(event.project!!).hasWrapper()
  }

  override fun actionPerformed(event: AnActionEvent) = ProjectSdkUpdater.getInstance(event.project!!).update()
}
