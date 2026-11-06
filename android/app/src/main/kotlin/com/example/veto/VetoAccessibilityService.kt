package com.example.veto

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.content.Intent
import android.util.Log

class VetoAccessibilityService : AccessibilityService() {
    companion object {
        var isLocked: Boolean = true
        var lockedPackages: Set<String> = emptySet()
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (!isLocked || event == null) return

        val packageName = event.packageName?.toString() ?: return
        if (lockedPackages.contains(packageName) && event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            Log.d("VetoBlocker", "Blocking $packageName")
            // Bring user back to home or show overlay
            performGlobalAction(GLOBAL_ACTION_HOME)
            // Optional: start an overlay activity explaining the lock
        }
    }

    override fun onInterrupt() {}

    override fun onServiceConnected() {
        super.onServiceConnected()
        Log.d("VetoBlocker", "Accessibility service connected")
    }
}
