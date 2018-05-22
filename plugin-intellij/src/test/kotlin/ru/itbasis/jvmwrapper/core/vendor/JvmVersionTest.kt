package ru.itbasis.jvmwrapper.core.vendor

import io.kotlintest.shouldBe
import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.ArgumentsSource
import ru.itbasis.jvmwrapper.core.JvmVersion

class JvmVersionTest {
  @ParameterizedTest
  @ArgumentsSource(value = JvmVersionSampleArgumentsProvider::class)
  fun `new instance`(jvmVersionSample: JvmVersionSample) {
    val actual = JvmVersion(version = jvmVersionSample.version)
    actual.type.name.toLowerCase() shouldBe jvmVersionSample.type
    actual.major shouldBe jvmVersionSample.versionMajor
    actual.update shouldBe jvmVersionSample.versionUpdate
  }
}
