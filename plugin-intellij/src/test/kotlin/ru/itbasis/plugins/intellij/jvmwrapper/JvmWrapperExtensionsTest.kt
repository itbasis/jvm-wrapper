package ru.itbasis.plugins.intellij.jvmwrapper

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertThrows
import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.MethodSource
import ru.itbasis.jvmwrapper.core.toBoolean
import java.lang.IllegalArgumentException

class JvmWrapperExtensionsTest {

  companion object {
    @JvmStatic
    fun dataPassed() = listOf(
      arrayOf("Y", true),
      arrayOf("y", true),
      arrayOf("N", false),
      arrayOf("n", false)
    )

    @JvmStatic
    fun dataFail() = listOf(
      arrayOf("bla")
    )
  }

  @ParameterizedTest
  @MethodSource("dataPassed")
  fun toBooleanPassed(value: Any?, expected: Boolean?) {
    assertEquals(expected, value?.toString()?.toBoolean())
  }

  @ParameterizedTest
  @MethodSource("dataFail")
  fun toBooleanFail(value: Any?) {
    assertThrows(IllegalArgumentException::class.java) { value?.toString()?.toBoolean() }
  }
}
