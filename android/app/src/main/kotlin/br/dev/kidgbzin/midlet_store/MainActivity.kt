package br.dev.kidgbzin.midlet_store;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import androidx.core.content.FileProvider;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.io.File;

class MainActivity : FlutterActivity() {

    private val CHANNEL: String = "br.dev.kidgbzin.midlet_store"

    /**
     * Configures the Flutter engine and sets up method channel handlers.
     *
     * This method is overridden from [FlutterActivity] to set up a method channel for communication between Flutter and native Android code.
     * It listens for method calls from Flutter and handles them accordingly.
     **/
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result -> when (call.method) {
                "Install" -> {
                    val arguments: Map<String, String> = call.arguments as Map<String, String>;

                    val activity: String? = arguments?.get("Activity");
                    val className: String? = arguments?.get("Package");
                    val filePath: String? = arguments?.get("File-Path");

                    val isValid: Boolean = !activity.isNullOrBlank() &&
                                           !className.isNullOrBlank() &&
                                           !filePath.isNullOrBlank();

                    if (isValid) {
                        installMIDlet(activity!!, className!!, filePath!!, result);
                    }

                    else {
                        result.error(
                            "INVALID_ARGUMENT",
                            "All arguments must be provided!",
                            null,
                        );
                    }
                }
                "Launch URL" -> {
                    val arguments: Map<String, String> = call.arguments as Map<String, String>;

                    val url: String? = arguments?.get("URL");

                    val isValid: Boolean = !url.isNullOrBlank();

                    if (isValid) {
                        launchUrl(url!!, result);
                    }

                    else {
                        result.error(
                            "INVALID_ARGUMENT",
                            "A URL must be provided!",
                            null,
                        );
                    }
                }
                else -> {
                    result.notImplemented();
                }
            }
        }
    }

    /**
     * Installs a MIDlet file using a proper application.
     *
     * This method takes the file path of a MIDlet and creates an intent to view the file.
     * The intent opens the MIDlet file on the activity given.
     *
     * If the given activity cannot be found, an [ActivityNotFoundException] is thrown.
     */
    private fun installMIDlet(
        activity: String,
        className: String,
        filePath: String,
        result: MethodChannel.Result,
    ) {
        val file: File = File(filePath);
        val intent: Intent = Intent(Intent.ACTION_VIEW);
        val uri: Uri = FileProvider.getUriForFile(this, "${CHANNEL}.fileprovider", file);

        try {
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            intent.setClassName(className, activity);
            intent.setDataAndType(uri, "application/java-archive");
            startActivity(intent);

            result.success(null);
        }
        catch (error: ActivityNotFoundException) {
            result.error(
                "ACTIVITY_NOT_FOUND",
                "The system was unable to find the \"$className\" activity!",
                error.message,
            );
        }
        catch (error: Exception) {
            result.error(
                "UNEXPECTED_ERROR",
                "An unexpected error occurred while opening the the \"$className\" activity!",
                error.message,
            );
        }
    }

    /**
     * Opens the given URL in a web browser.
     *
     * This method creates an intent to view the specified [URL] and starts the activity associated with this intent.
     * It adds the [Intent.FLAG_ACTIVITY_NEW_TASK] flag to the intent to ensure the browser opens in a new task.
     *
     * If the activity cannot be found, an [ActivityNotFoundException] is thrown.
     */
    private fun launchUrl(
        url: String,
        result: MethodChannel.Result,
    ) {
        val intent: Intent = Intent(Intent.ACTION_VIEW, Uri.parse(url));

        try {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);

            result.success(null);
        }
        catch (error: ActivityNotFoundException) {
            result.error(
                "ACTIVITY_NOT_FOUND",
                "The system was unable to find the browser activity!",
                error.message,
            );
        }
        catch (error: Exception) {
            result.error(
                "UNEXPECTED_ERROR",
                "An unexpected error occurred while opening the browser activity!",
                error.message,
            );
        }
    }
}