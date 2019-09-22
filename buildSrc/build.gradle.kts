@file:Suppress("UnstableApiUsage")

plugins {
	`kotlin-dsl`
}

kotlinDslPluginOptions {
	experimentalWarning.set(false)
}

repositories {
	gradlePluginPortal()
	mavenCentral()
	jcenter()
}

val kotlinVersion = embeddedKotlinVersion

dependencies {
	implementation("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")

	implementation("io.gitlab.arturbosch.detekt:detekt-gradle-plugin:+")
	implementation("io.kotlintest:kotlintest-gradle-plugin:+")

//	implementation("org.jetbrains.intellij.plugins:gradle-intellij-plugin:+")
}

gradlePlugin {
	plugins {
		register("travis-ci-plugin") {
			id = "travis-ci"
			implementationClass = "ru.itbasis.gradle.plugins.travis_ci.TravisCIPlugin"
		}
	}
}
