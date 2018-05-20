package ru.itbasis.jvmwrapper.core.vendor

import org.junit.jupiter.api.extension.ExtensionContext
import org.junit.jupiter.params.provider.Arguments
import org.junit.jupiter.params.provider.ArgumentsProvider
import java.util.stream.Stream

data class JvmVersionSample(
  val vendor: String,
  val type: String,
  val version: String,
  val fullVersion: String,
  val versionMajor: String,
  val versionUpdate: String?,
  val downloadPageUrl: String,
  val downloadArchiveUrlPart: String
)

val JvmVersionLatestSamples = listOf(
  JvmVersionSample(
    vendor = "oracle",
    type = "jdk",
    version = "10.0.1",
    fullVersion = "10.0.1+10",
    versionMajor = "10",
    versionUpdate = null,
    downloadPageUrl = "/technetwork/java/javase/downloads/jdk10-downloads-4416644.html",
    downloadArchiveUrlPart = "http://download.oracle.com/otn-pub/java/jdk/10.0.1+10/fb4372174a714e6b8c52526dc134031e/jdk-10.0.1_"
  ),
  JvmVersionSample(
    vendor = "oracle",
    type = "jdk",
    version = "8u171",
    fullVersion = "1.8.0_171-b11",
    versionMajor = "8",
    versionUpdate = "171",
    downloadPageUrl = "/technetwork/java/javase/downloads/jdk8-downloads-2133151.html",
    downloadArchiveUrlPart = "http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-"
  ),
  JvmVersionSample(
    vendor = "oracle",
    type = "jdk",
    version = "8u172",
    fullVersion = "1.8.0_172-b11",
    versionMajor = "8",
    versionUpdate = "172",
    downloadPageUrl = "/technetwork/java/javase/downloads/jdk8-downloads-2133151.html",
    downloadArchiveUrlPart = "http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-"
  )
)

val JvmVersionArchiveSamples = listOf(
  JvmVersionSample(
    vendor = "oracle",
    type = "jdk",
    version = "8u144",
    fullVersion = "1.8.0_144-b01",
    versionMajor = "8",
    versionUpdate = "144",
    downloadPageUrl = "/technetwork/java/javase/downloads/java-archive-javase8-2177648.html",
    downloadArchiveUrlPart = "http://download.oracle.com/otn/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-"
  )
)

val JvmVersionSamples = listOf(
  JvmVersionLatestSamples
//  ,
//  JvmVersionArchiveSamples
).flatten()
//  JvmVersionSample(
//    vendor = "oracle",
//    type = "jdk",
//    version = "10",
//    fullVersion = "10+46",
//    versionMajor = "10",
//    versionUpdate = null
//  )
//  JvmVersionSample(vendor = "oracle", version = "9.0.4", fullVersion = "9.0.4", versionMajor = "9"),
//  JvmVersionSample(vendor = "oracle", version = "9.0.1", fullVersion = "9.0.1", versionMajor = "9"),
//  JvmVersionSample(vendor = "oracle", version = "9", fullVersion = "9+181", versionMajor = "9"),
//  JvmVersionSample(
//    vendor = "oracle",
//    type = "jdk",
//    version = "8u172",
//    fullVersion = "1.8.0_172-b11",
//    versionMajor = "8",
//    versionUpdate = "172"
//  ),
//  JvmVersionSample(
//    vendor = "oracle",
//    type = "jdk",
//    version = "8u171",
//    fullVersion = "1.8.0_171-b11",
//    versionMajor = "8",
//    versionUpdate = "171"
//  ),
//  JvmVersionSample(
//    vendor = "oracle",
//    type = "jdk",
//    version = "1.8.0_171-b11",
//    fullVersion = "1.8.0_171-b11",
//    versionMajor = "8",
//    versionUpdate = "171",
//    urlPart = "http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-"
//  ),
//  JvmVersionSample(
//    vendor = "oracle",
//    type = "jdk",
//    version = "1.8.0_172-b11",
//    fullVersion = "1.8.0_172-b11",
//    versionMajor = "8",
//    versionUpdate = "172",
//    urlPart = "http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-"
//  ),
//  JvmVersionSample(
//    vendor = "oracle",
//    type = "jdk",
//    version = "8u144",
//    fullVersion = "1.8.0_144-b01",
//    versionMajor = "8",
//    versionUpdate = "144",
//    urlPart = "http://download.oracle.com/otn/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-"
//  ),
//  JvmVersionSample(
//    vendor = "oracle",
//    type = "jdk",
//    version = "8",
//    fullVersion = "1.8.0-b132",
//    versionMajor = "8",
//    versionUpdate = null,
//    urlPart = "http://download.oracle.com/otn/java/jdk/8-b132/jdk-8-"
//  )

class JvmVersionLatestSampleArgumentsProvider : ArgumentsProvider {
  override fun provideArguments(context: ExtensionContext?): Stream<out Arguments> {
    return JvmVersionLatestSamples.map { Arguments.of(it) }.stream()
  }
}

class JvmVersionArchiveSampleArgumentsProvider : ArgumentsProvider {
  override fun provideArguments(context: ExtensionContext?): Stream<out Arguments> {
    return JvmVersionArchiveSamples.map { Arguments.of(it) }.stream()
  }
}

class JvmVersionSampleArgumentsProvider : ArgumentsProvider {
  override fun provideArguments(context: ExtensionContext?): Stream<out Arguments> {
    return JvmVersionSamples.map { Arguments.of(it) }.stream()
  }
}
