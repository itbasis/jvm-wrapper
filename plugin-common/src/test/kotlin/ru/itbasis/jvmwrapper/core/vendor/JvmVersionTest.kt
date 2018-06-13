package ru.itbasis.jvmwrapper.core.vendor

import io.kotlintest.data.forall
import io.kotlintest.shouldBe
import io.kotlintest.specs.FunSpec
import io.kotlintest.tables.row
import ru.itbasis.jvmwrapper.core.JvmVersion
import ru.itbasis.jvmwrapper.core.JvmVersionLatestSamples

class JvmVersionTest : FunSpec({
  test("new instance") {
    forall(
      rows = *JvmVersionLatestSamples.map { row(it) }.toTypedArray()
    ) { (_, type, version, _, versionMajor, versionUpdate) ->
      val actual = JvmVersion(version = version)
      actual.type.name.toLowerCase() shouldBe type
      actual.major shouldBe versionMajor
      actual.update shouldBe versionUpdate
    }
  }
})
