package ru.itbasis.jvmwrapper.core

import io.kotlintest.matchers.file.exist
import io.kotlintest.shouldBe
import io.kotlintest.specs.FunSpec
import java.io.File

class ExtensionsTest : FunSpec( {
    test("suppress file match checksum SHA-256") {
//      forall(
//        *arrayOf("openjdk-7.env" to "20230405526c28f2ca0aa389f87afd17126436a09d804a24e95a827646c01bfc").map { (fileName, checksum) ->
//          row(File("", fileName), checksum)
//        }.toTypedArray()
//            ) { file, checksum ->
      val file = File("openjdk-7.env")
      val checksum = "20230405526c28f2ca0aa389f87afd17126436a09d804a24e95a827646c01bfc"

        println("test file: $file")
        file shouldBe exist()
        file.matchChecksum256(checksum) shouldBe true
//      }
    }
})
