package ru.itbasis.plugins.intellij.jvmwrapper

import com.intellij.testFramework.fixtures.LightPlatformCodeInsightFixtureTestCase
import io.github.glytching.junit.extension.folder.TemporaryFolderExtension
import org.junit.jupiter.api.extension.ExtendWith

@ExtendWith(TemporaryFolderExtension::class)
internal class WrapperProjectComponentTest : LightPlatformCodeInsightFixtureTestCase()
