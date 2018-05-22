package ru.itbasis.jvmwrapper.core

typealias ProcessStepListener = (msg: String) -> Unit

fun <R> String.step(stepListener: ProcessStepListener?, command: () -> R): R {
  stepListener?.invoke(this)
  return command()
}
