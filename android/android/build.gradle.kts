buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // уже должен быть класс-путь для Android Gradle Plugin
        classpath("com.android.tools.build:gradle:7.4.2")
        // вот он — класс-путь для google-services
        classpath("com.google.gms:google-services:4.3.15")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ... остальная часть build.gradle.kts без изменений

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
