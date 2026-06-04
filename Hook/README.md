# Functions and what they do.

**MainHooker:InitializeHooks()** : Places all hooks in the game. Call this first. Returns success, message.

**MainHooker:RemoveHooks()** : De-initializes all hooks. You can re-init after.

**MainHooker:Hook(Object, Property)** : Starts hooking the property of an object. Keeps reads and game-writes coherent (game can set it and read it back consistently while the real value is spoofed).

**MainHooker:ChangeObjectValue(Object, Property, Value)** : Changes the REAL value to what you set, while reads keep returning the hooked value. Property must be hooked first.

**MainHooker:SpoofRead(Object, Property, Value)** : Fakes only the read. Doesn't touch writes. Use when you just need reads to lie.

**MainHooker:UnspoofRead(Object, Property)** : Removes a read spoof set by SpoofRead.

**MainHooker:IsReadSpoofed(Object, Property)** : Returns true if the property has a read spoof.

**MainHooker:RealValue(Object, Property)** : Returns the real stored value of a hooked property, or false if not hooked.

**MainHooker:RemoveSingular(Object, Property)** : Removes hooks for that one property of that object.

**MainHooker:IsHooked(Object, Property)** : Returns true if the property is hooked.

# Hook vs SpoofRead

Hook = reads and writes stay matched. Game writes land and read back consistently, real value is spoofed. Use this for most stuff.

SpoofRead = read-only lie, real property untouched.

Don't mix them up. Returning a read the game never wrote, or losing a write, = desync = you get caught. That's the #1 mistake people make, which is why these are separate.

# Disclaimers

- Works against anticheats that use debug.info + metamethod probing (Adonis-typa and similar). Does NOT beat server-side checks, signal-based detection, or env scanning. It's a hook lib, not a magic anticheat killer.
- Needs an executor with setstackhidden, getrawmetatable, setreadonly, newcclosure, iscclosure. Made/tested on Volt. Other executors or executor updates might break it.
- Anticheats update. Works as of now, no promises forever. Test it yourself.

iunnu the rest bruh, figure it out, its open source.
