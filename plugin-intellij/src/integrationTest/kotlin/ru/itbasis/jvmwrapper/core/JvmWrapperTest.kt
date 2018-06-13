package ru.itbasis.jvmwrapper.core

import io.kotlintest.Description
import io.kotlintest.TestResult
import io.kotlintest.data.forall
import io.kotlintest.shouldBe
import io.kotlintest.specs.FunSpec
import io.kotlintest.tables.row
import org.junit.rules.TemporaryFolder
import java.io.File
import java.math.BigDecimal
import java.math.RoundingMode
import java.nio.charset.Charset
import java.util.concurrent.TimeUnit

internal class JvmWrapperTest : FunSpec() {
  private val stepListener: (String) -> Unit = { msg -> println(msg) }
  private val downloadProcessListener: (String, Long, Long) -> Boolean = { _, sizeCurrent, sizeTotal ->
    val percentage = BigDecimal(sizeCurrent.toDouble() / sizeTotal * 100).setScale(2, RoundingMode.HALF_UP)
    println("$sizeCurrent / $sizeTotal :: $percentage%")
    true
  }
  private var temporaryFolder = TemporaryFolder()

  override fun beforeTest(description: Description) {
    temporaryFolder.create()
  }

  override fun afterTest(description: Description, result: TestResult) {
    temporaryFolder.delete()
  }

  init {
    test("test default versions") {
      forall(
        rows = *JvmVersionLatestSamples.map { row(it) }.toTypedArray()
      ) { jvmVersionSample ->
        val propertiesFile = temporaryFolder.newFile("jvmw.properties").apply {
          appendText("JVM_VERSION=${jvmVersionSample.version}\n")
          appendText("JVM_VENDOR=${jvmVersionSample.vendor}")
        }
        val workingDir = propertiesFile.parentFile
        File(System.getProperty("user.dir")).parentFile.resolve(JvmWrapper.SCRIPT_FILE_NAME)
          .copyTo(File(workingDir, JvmWrapper.SCRIPT_FILE_NAME))

        val jvmWrapper = JvmWrapper(workingDir, stepListener = stepListener, downloadProcessListener = downloadProcessListener)
        val jvmHomeDir = jvmWrapper.jvmHomeDir
        println("jvmHomeDir: $jvmHomeDir")

        val jvmBinDir = jvmHomeDir.resolve("bin")
        jvmBinDir.exists() shouldBe true

        val process = ProcessBuilder(File(jvmBinDir, "java").absolutePath, "-fullversion").start()
        process.waitFor(5, TimeUnit.SECONDS)
        """java full version "${jvmVersionSample.fullVersion}"""" shouldBe process.errorStream.readBytes().toString(Charset.defaultCharset()).trim()
      }
    }
  }
}
