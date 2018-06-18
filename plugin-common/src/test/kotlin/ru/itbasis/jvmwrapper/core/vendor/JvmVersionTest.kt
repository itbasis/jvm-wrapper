package ru.itbasis.jvmwrapper.core.vendor

import io.kotlintest.data.forall
import io.kotlintest.shouldBe
import io.kotlintest.specs.FunSpec
import io.kotlintest.tables.row
import ru.itbasis.jvmwrapper.core.JvmVersion
import ru.itbasis.jvmwrapper.core.JvmVersionLatestSamples
import ru.itbasis.jvmwrapper.core.jvmVersionSample__oracle_jdk_8u171

class JvmVersionTest : FunSpec({
  test("version") {
    forall(
      rows = *JvmVersionLatestSamples.map { row(it) }.toTypedArray()
    ) { (_, type, version, _, cleanVersion, versionMajor, versionUpdate) ->
      val actual = JvmVersion(version = version)
      actual.type.name.toLowerCase() shouldBe type
      actual.major shouldBe versionMajor
      actual.update shouldBe versionUpdate
      actual.cleanVersion shouldBe cleanVersion
    }
  }

  test("full version") {
    forall(
      rows = *JvmVersionLatestSamples.map { row(it) }.toTypedArray()
    ) { (_, type, _, fullVersion, cleanVersion, versionMajor, versionUpdate) ->
      val actual = JvmVersion(version = fullVersion)
      actual.type.name.toLowerCase() shouldBe type
      actual.major shouldBe versionMajor
      actual.update shouldBe versionUpdate
      actual.cleanVersion shouldBe cleanVersion
    }
  }

  test("runtime version"){
    val expected = jvmVersionSample__oracle_jdk_8u171
    val actual = JvmVersion(version = System.getProperty("java.version"))
    actual.major shouldBe expected.versionMajor
    actual.update shouldBe expected.versionUpdate
    actual.cleanVersion shouldBe expected.cleanVersion
  }
})
