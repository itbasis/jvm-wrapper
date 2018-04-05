import org.gradle.internal.impldep.org.junit.experimental.categories.Categories.CategoryFilter.include
import org.gradle.jvm.tasks.Jar
import org.gradle.plugins.ide.idea.model.IdeaModel
import org.jetbrains.dokka.gradle.DokkaTask
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.junit.platform.console.options.Details
import org.junit.platform.gradle.plugin.JUnitPlatformExtension

tasks.withType<Wrapper> {
    distributionType = Wrapper.DistributionType.ALL
    gradleVersion = "4.6"
}

group = "ru.itbasis.jvm-wrapper"
version = "20180331_1212"

buildscript {
    repositories {
        mavenCentral()
        jcenter()
        gradlePluginPortal()
    }
    dependencies {
        classpath("org.jetbrains.dokka:dokka-gradle-plugin:latest.release")
        classpath("gradle.plugin.org.jlleitschuh.gradle:ktlint-gradle:latest.release")
        classpath("org.junit.platform:junit-platform-gradle-plugin:latest.release")
    }
}

repositories {
    jcenter()
}

plugins {
    `build-scan`
    idea
    kotlin("jvm") version embeddedKotlinVersion
    maven
    `maven-publish`
}
apply {
    plugin("org.jetbrains.dokka")
    plugin("org.jlleitschuh.gradle.ktlint")
    plugin("org.junit.platform.gradle.plugin")
}

configure<JavaPluginConvention> {
    sourceCompatibility = JavaVersion.VERSION_1_8
}

configure<IdeaModel> {
    module {
        isDownloadJavadoc = false
        isDownloadSources = false
    }
    project {
        vcs = "Git"
    }
}

tasks.withType(KotlinCompile::class.java).all {
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }
}

extensions.getByType(JUnitPlatformExtension::class.java).apply {
    filters {
        engines {
            include("junit-jupiter")
        }
    }
//    logManager = "org.apache.logging.log4j.jul.LogManager"
    details = Details.TREE
}

buildScan {
    setLicenseAgreementUrl("https://gradle.com/terms-of-service")
    setLicenseAgree("yes")

//    publishAlways()
}

val dokka by tasks.getting(DokkaTask::class) {
    outputFormat = "html"
    outputDirectory = "$buildDir/javadoc"
}

val dokkaJar by tasks.creating(Jar::class) {
    group = JavaBasePlugin.DOCUMENTATION_GROUP
    description = "Assembles Kotlin docs with Dokka"
    classifier = "javadoc"
    from(dokka)
}

publishing {
    publications {
        create("default", MavenPublication::class.java) {
            from(components["java"])
            artifact(dokkaJar)
        }
    }
    repositories {
        maven {
            url = uri("$buildDir/repository")
        }
    }
}

dependencies {
    implementation(kotlin("stdlib-jdk8"))
    implementation("org.apache.commons:commons-lang3:latest.release")

//    testImplementation("junit:junit:latest.release")
    testImplementation("org.junit.jupiter:junit-jupiter-api:latest.release")
    testImplementation("org.junit.jupiter:junit-jupiter-params:latest.release")
    testImplementation("org.junit.jupiter:junit-jupiter-engine:latest.release")
    testImplementation("io.github.glytching:junit-extensions:latest.release")
}