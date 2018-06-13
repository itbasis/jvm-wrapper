import org.jetbrains.kotlin.gradle.plugin.KotlinPlatformJvmPlugin

apply {
  plugin<KotlinPlatformJvmPlugin>()
}

dependencies {
  "compile"(group = "microutils", name = "KotlinMicroUtils", version = "latest.release")
  "compile"(group = "org.apache.commons", name = "commons-compress")
  "compileOnly"(group = "org.apache.httpcomponents", name = "httpclient")
  "compileOnly"(group = "com.google.code.gson", name = "gson")
}
