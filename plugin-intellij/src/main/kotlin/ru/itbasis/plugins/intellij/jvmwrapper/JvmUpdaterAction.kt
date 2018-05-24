package ru.itbasis.plugins.intellij.jvmwrapper

import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent

class JvmUpdaterAction : AnAction("Refresh") {
  override fun update(e: AnActionEvent) {
    val project = e.project!!

    e.presentation.isEnabledAndVisible = true && JvmWrapperService.getInstance(project).hasWrapper()
  }

  override fun actionPerformed(event: AnActionEvent) {
    JvmWrapperService.getInstance(event.project!!).updateProjectSdk()
  }
}
