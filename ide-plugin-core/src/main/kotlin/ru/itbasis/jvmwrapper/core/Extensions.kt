package ru.itbasis.jvmwrapper.core

import java.io.File

// https://www.samclarke.com/kotlin-hash-strings/
fun File.matchChecksum256(checksum: String?) = !checksum.isNullOrBlank()
