package com.example.pc_wake_trigger

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.GestureDescription
import android.graphics.Path
import android.view.accessibility.AccessibilityEvent

class AccessibilityService : AccessibilityService() {

    companion object {
        var instance: AccessibilityService? = null
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // Aqui você pode capturar o evento de notificação do Gmail (ou outro app)
        if (event?.eventType == AccessibilityEvent.TYPE_NOTIFICATION_STATE_CHANGED) {
            val text = event.text.toString()
            // Se o texto da notificação contiver a sua palavra-chave secreta:
            if (text.contains("LigarPC")) {
                // Dispara a rotina de clique ou aciona o Wake-on-LAN
            }
        }
    }

    override fun onInterrupt() {
        instance = null
    }

    fun click(x: Float, y: Float) {
        val path = Path().apply {
            moveTo(x, y)
        }
        val stroke = GestureDescription.StrokeDescription(path, 0, 100)
        val gestureBuilder = GestureDescription.Builder().addStroke(stroke)
        dispatchGesture(gestureBuilder.build(), null, null)
    }
}