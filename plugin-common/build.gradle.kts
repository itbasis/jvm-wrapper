import org.jetbrains.kotlin.gradle.plugin.KotlinPlatformJvmPlugin

apply {
  plugin<KotlinPlatformJvmPlugin>()
}

dependencies {
  "compile"(group = "microutils", name = "KotlinMicroUtils", version = "latest.release")
  "compile"(group = "org.apache.commons", name = "commons-compress")
  "compile"(group = "org.apache.commons", name = "commons-lang3")
  "implementation"(group = "org.apache.httpcomponents", name = "httpclient")
  "implementation"(group = "com.google.code.gson", name = "gson")
}
