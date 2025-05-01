package br.dev.kidgbzin.midlet_store

import android.graphics.drawable.Drawable
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class NativeAdvertisement(private val layoutInflater: LayoutInflater) : NativeAdFactory {
    override fun createNativeAd(nativeAd: NativeAd, customOptions: MutableMap<String, Any>?): NativeAdView {
        val adView = layoutInflater.inflate(R.layout.native_advertisement, null) as NativeAdView

        adView.headlineView = adView.findViewById(R.id.ad_headline)
        (adView.headlineView as TextView).text = nativeAd.headline

        nativeAd.body?.let {
            adView.bodyView = adView.findViewById(R.id.ad_body)
            (adView.bodyView as TextView).text = it
            adView.bodyView?.visibility = View.VISIBLE
        }

        nativeAd.icon?.let {
            adView.iconView = adView.findViewById(R.id.ad_app_icon)
            (adView.iconView as ImageView).setImageDrawable(it.drawable)
            adView.iconView?.visibility = View.VISIBLE
        }

        nativeAd.callToAction?.let {
            adView.callToActionView = adView.findViewById(R.id.ad_call_to_action)
            (adView.callToActionView as Button).text = it
            adView.callToActionView?.visibility = View.VISIBLE
        }

        adView.setNativeAd(nativeAd)
        return adView
    }
}