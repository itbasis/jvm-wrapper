package ru.itbasis.plugins.intellij.jvmwrapper

import org.junit.jupiter.api.extension.ExtensionContext
import org.junit.jupiter.params.provider.Arguments
import org.junit.jupiter.params.provider.ArgumentsProvider
import java.util.stream.Stream

data class TestVersion(
  val jvmVendor: String,
  val jvmType: String,
  val jvmVersion: String,
  val fullVersion: String,
  val useSystem: String? = null,
  val reuseJvmVersion: String? = null
) {
  override fun toString(): String {
    return "$jvmVendor-$jvmType-$jvmVersion (system=$useSystem, reuse=$reuseJvmVersion)"
  }
}

class TestVersionArguments : ArgumentsProvider {
  override fun provideArguments(p0: ExtensionContext?): Stream<out Arguments> {
    return listOf(
      Arguments.of(
        TestVersion(
          jvmVendor = "oracle",
          jvmType = "jdk",
          jvmVersion = "10",
          fullVersion = "10+46",
          useSystem = "10"
        )
      ),
      Arguments.of(
        TestVersion(
          jvmVendor = "oracle",
          jvmType = "jdk",
          jvmVersion = "8",
          fullVersion = "1.8.0_162-b12",
          useSystem = "8"
        )
      )
    ).stream()
  }
}
