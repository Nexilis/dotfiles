// iss — Instant Space Switcher
// https://github.com/joshuarli/iss
// MIT License
//
// Eliminates the macOS sliding animation when 3-finger swiping between spaces.
// Intercepts trackpad dock-swipe gesture events and replaces them with
// synthetic high-velocity swipes that cause instant space switching.

#include <ApplicationServices/ApplicationServices.h>
#include <CoreFoundation/CoreFoundation.h>
#include <float.h>
#include <signal.h>
#include <string.h>
#include <stdbool.h>
#include <stdio.h>

static const CGEventField kCGSEventTypeField            = 55;
static const CGEventField kCGEventGestureHIDType        = 110;
static const CGEventField kCGEventGestureScrollY        = 119;
static const CGEventField kCGEventGestureSwipeMotion    = 123;
static const CGEventField kCGEventGestureSwipeProgress  = 124;
static const CGEventField kCGEventGestureSwipeVelocityX = 129;
static const CGEventField kCGEventGestureSwipeVelocityY = 130;
static const CGEventField kCGEventGesturePhase          = 132;
static const CGEventField kCGEventScrollGestureFlagBits = 135;
static const CGEventField kCGEventGestureZoomDeltaX     = 139;

enum { kCGSEventGesture = 29, kCGSEventDockControl = 30 };
enum { kIOHIDEventTypeDockSwipe = 23 };
enum { kCGGestureMotionHorizontal = 1 };
enum { kGestureBegan = 1, kGestureChanged = 2, kGestureEnded = 4, kGestureCancelled = 8 };

extern int CGSMainConnectionID(void);
extern uint64_t CGSGetActiveSpace(int cid);
extern CFArrayRef CGSCopyManagedDisplaySpaces(int cid);

static CFMachPortRef tap;
static bool swipeTracking, swipeFired;
static int  passthrough;

static CGEventRef make_dock_event(int phase, bool right) {
    CGEventRef ev = CGEventCreate(NULL);
    if (!ev) return NULL;
    CGEventSetIntegerValueField(ev, kCGSEventTypeField, kCGSEventDockControl);
    CGEventSetIntegerValueField(ev, kCGEventGestureHIDType, kIOHIDEventTypeDockSwipe);
    CGEventSetIntegerValueField(ev, kCGEventGesturePhase, phase);
    const float flagsProgress = right ? FLT_TRUE_MIN : -FLT_TRUE_MIN;
    int32_t scrollGestureFlagDirection;
    memcpy(&scrollGestureFlagDirection, &flagsProgress, sizeof(scrollGestureFlagDirection));
    CGEventSetIntegerValueField(ev, kCGEventScrollGestureFlagBits, scrollGestureFlagDirection);
    CGEventSetIntegerValueField(ev, kCGEventGestureSwipeMotion, kCGGestureMotionHorizontal);
    CGEventSetDoubleValueField(ev, kCGEventGestureScrollY, 0);
    CGEventSetDoubleValueField(ev, kCGEventGestureZoomDeltaX, FLT_TRUE_MIN);
    return ev;
}

static bool post_pair(CGEventRef dock) {
    CGEventRef companion = CGEventCreate(NULL);
    if (!companion) { CFRelease(dock); return false; }
    CGEventSetIntegerValueField(companion, kCGSEventTypeField, kCGSEventGesture);
    CGEventPost(kCGSessionEventTap, dock);
    CGEventPost(kCGSessionEventTap, companion);
    CFRelease(dock); CFRelease(companion);
    return true;
}

static bool can_switch(bool right) {
    int cid = CGSMainConnectionID();
    uint64_t active = CGSGetActiveSpace(cid);
    CFArrayRef displays = CGSCopyManagedDisplaySpaces(cid);
    if (!displays) return true;

    bool can = true;
    for (CFIndex i = 0; i < CFArrayGetCount(displays); i++) {
        CFDictionaryRef display = CFArrayGetValueAtIndex(displays, i);
        CFArrayRef spaces = CFDictionaryGetValue(display, CFSTR("Spaces"));
        if (!spaces) continue;
        CFIndex count = CFArrayGetCount(spaces);
        for (CFIndex j = 0; j < count; j++) {
            CFDictionaryRef space = CFArrayGetValueAtIndex(spaces, j);
            CFNumberRef sid = CFDictionaryGetValue(space, CFSTR("ManagedSpaceID"));
            if (!sid) continue;
            int64_t val;
            CFNumberGetValue(sid, kCFNumberSInt64Type, &val);
            if ((uint64_t)val == active) {
                if (right && j == count - 1) can = false;
                if (!right && j == 0) can = false;
                goto done;
            }
        }
    }
done:
    CFRelease(displays);
    return can;
}

static void post_switch(bool right) {
    if (!can_switch(right)) return;
    double sign = right ? 1.0 : -1.0;

    CGEventRef begin = make_dock_event(kGestureBegan, right);
    if (!begin) return;

    CGEventRef changed = make_dock_event(kGestureChanged, right);
    if (!changed) { CFRelease(begin); return; }

    CGEventRef end = make_dock_event(kGestureEnded, right);
    if (!end) { CFRelease(begin); CFRelease(changed); return; }
    CGEventSetDoubleValueField(end, kCGEventGestureSwipeVelocityX, sign * 400.0);
    CGEventSetDoubleValueField(end, kCGEventGestureSwipeVelocityY, 0);

    passthrough += 6;
    post_pair(begin);
    post_pair(changed);
    post_pair(end);
}

static CGEventRef cb(CGEventTapProxy proxy, CGEventType type, CGEventRef ev, void *ctx) {
    (void)proxy; (void)ctx;

    if (type == kCGEventTapDisabledByTimeout || type == kCGEventTapDisabledByUserInput) {
        CGEventTapEnable(tap, true);
        return ev;
    }

    int et = (int)CGEventGetIntegerValueField(ev, kCGSEventTypeField);

    if (passthrough > 0 && (et == kCGSEventDockControl || et == kCGSEventGesture)) {
        passthrough--;
        return ev;
    }

    if (et == kCGSEventDockControl
        && (int)CGEventGetIntegerValueField(ev, kCGEventGestureHIDType) == kIOHIDEventTypeDockSwipe
        && (int)CGEventGetIntegerValueField(ev, kCGEventGestureSwipeMotion) == kCGGestureMotionHorizontal) {

        int phase = (int)CGEventGetIntegerValueField(ev, kCGEventGesturePhase);

        if (phase == kGestureBegan) {
            swipeTracking = true; swipeFired = false; return NULL;
        }
        if (phase == kGestureChanged && swipeTracking) {
            if (!swipeFired) {
                double p = CGEventGetDoubleValueField(ev, kCGEventGestureSwipeProgress);
                if (p != 0.0) { swipeFired = true; post_switch(p > 0); }
            }
            return NULL;
        }
        if (phase == kGestureEnded && swipeTracking) {
            if (!swipeFired) {
                double v = CGEventGetDoubleValueField(ev, kCGEventGestureSwipeVelocityX);
                if (v != 0.0) post_switch(v > 0);
            }
            swipeTracking = swipeFired = false; return NULL;
        }
        if (phase == kGestureCancelled) {
            swipeTracking = swipeFired = false; return NULL;
        }
        return swipeTracking ? NULL : ev;
    }

    if (et == kCGSEventGesture && swipeTracking) return NULL;

    // Hyper (cmd+ctrl+alt+shift) + Left/Right arrow: instant space switch
    if (type == kCGEventKeyDown) {
        CGEventFlags flags = CGEventGetFlags(ev);
        static const CGEventFlags hyper =
            kCGEventFlagMaskCommand | kCGEventFlagMaskControl |
            kCGEventFlagMaskAlternate | kCGEventFlagMaskShift;
        static const CGEventFlags mask = hyper | kCGEventFlagMaskSecondaryFn;
        if ((flags & mask) == (hyper | kCGEventFlagMaskSecondaryFn)) {
            int64_t keycode = CGEventGetIntegerValueField(ev, kCGKeyboardEventKeycode);
            if (keycode == 123) { post_switch(false); return NULL; } // left
            if (keycode == 124) { post_switch(true);  return NULL; } // right
        }
    }

    return ev;
}

static volatile sig_atomic_t running = 1;
static void stop(int s) { (void)s; running = 0; }

int main(void) {
    const void *k[] = { kAXTrustedCheckOptionPrompt }, *v[] = { kCFBooleanTrue };
    CFDictionaryRef opts = CFDictionaryCreate(NULL, k, v, 1,
        &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    bool ok = AXIsProcessTrustedWithOptions(opts);
    CFRelease(opts);
    if (!ok) { fprintf(stderr, "Grant Accessibility permission, then re-run.\n"); return 1; }

    tap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap,
        kCGEventTapOptionDefault,
        (1ULL << kCGSEventGesture) | (1ULL << kCGSEventDockControl) |
        (1ULL << kCGEventKeyDown), cb, NULL);
    if (!tap) { fprintf(stderr, "Failed to create event tap.\n"); return 1; }

    CFRunLoopSourceRef src = CFMachPortCreateRunLoopSource(NULL, tap, 0);
    CFRunLoopAddSource(CFRunLoopGetMain(), src, kCFRunLoopCommonModes);
    CGEventTapEnable(tap, true);
    signal(SIGINT, stop); signal(SIGTERM, stop);

    fprintf(stderr, "iss: instant swipe active\n");
    while (running) CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0, true);

    CGEventTapEnable(tap, false);
    CFRunLoopRemoveSource(CFRunLoopGetMain(), src, kCFRunLoopCommonModes);
    CFRelease(src); CFRelease(tap);
    return 0;
}
