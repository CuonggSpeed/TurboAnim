#import <Foundation/Foundation.h>
#import <dlfcn.h>
#import <substrate.h>

static BOOL enabled = YES;
static float speed = 1.5f;

static void loadPrefs(void) {
    CFStringRef app = CFSTR("com.local.turboanim");
    CFPreferencesAppSynchronize(app);
    NSNumber *e = (__bridge_transfer NSNumber *)CFPreferencesCopyAppValue(CFSTR("enabled"), app);
    NSNumber *s = (__bridge_transfer NSNumber *)CFPreferencesCopyAppValue(CFSTR("speed"), app);
    enabled = e ? [e boolValue] : YES;
    speed = s ? [s floatValue] : 1.5f;
    if (speed < 0.5f) speed = 0.5f;
}

static void prefsChanged(CFNotificationCenterRef c, void *o, CFNotificationName n, const void *obj, CFDictionaryRef u) {
    loadPrefs();
}

static float (*orig_drag)(void);
static float new_drag(void) {
    float v = orig_drag();
    return enabled ? v / speed : v;
}

%ctor {
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, prefsChanged, CFSTR("com.local.turboanim/prefschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    void *sym = dlsym(RTLD_DEFAULT, "UIAnimationDragCoefficient");
    if (sym) MSHookFunction(sym, (void *)new_drag, (void **)&orig_drag);
}
