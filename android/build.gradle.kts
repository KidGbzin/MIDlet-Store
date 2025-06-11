import com.android.build.gradle.BaseExtension
import org.gradle.api.Project

allprojects {
    repositories {
        google()
        mavenCentral()
        maven(url = "https://unity-mediation.s3.amazonaws.com/release")
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // ========================================================================================================================================================================= //
    // Workaround for Isar build on Android 35 (https://github.com/isar/isar/issues/1681).
    afterEvaluate {
        if (project.hasProperty("android")) {
            val androidExtension = project.extensions.findByName("android")
            if (androidExtension is BaseExtension) {
                androidExtension.compileSdkVersion("android-35")
                androidExtension.buildToolsVersion = "35.0.0"
                androidExtension.ndkVersion = "27.0.12077973"

                try {
                    val namespaceField = androidExtension::class.java.getDeclaredField("namespace")
                    namespaceField.isAccessible = true
                    val currentNamespace = namespaceField.get(androidExtension) as? String
                    if (currentNamespace.isNullOrBlank()) {
                        namespaceField.set(androidExtension, project.group.toString())
                    }
                }
                catch (_: NoSuchFieldException) {} // Some AGP versions may not expose the namespace property.
            }
        }
    }
    // ========================================================================================================================================================================= //
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}