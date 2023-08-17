#include <iostream>
#include <Windows.h>
#include <string>
#include <thread>
#include <vector>
#include <signal.h>

int ASLR(uintptr_t address)
{
    return address - 0x400000 + reinterpret_cast<uintptr_t>(GetModuleHandleA(0));
}
int aslr_0(uintptr_t address)
{
    return address + reinterpret_cast<uintptr_t>(GetModuleHandleA(0));
}

uintptr_t exthread;

namespace Addresses
{
    // remember v30 = sub_979070(pServiceName, 0);
    using r_luavm_load_t = uintptr_t(__fastcall*)(uintptr_t rl, std::string* source, const char* chunk, int env);
    r_luavm_load_t r_luavm_load = (r_luavm_load_t)(ASLR(0x979070)); // oldResult / aslr_0(0x55D430)

    using r_taskdefer_t = uintptr_t(__cdecl*)(uintptr_t rl);// [Maximum re-entrancy depth (%i) exceeded calling task.defer] or [defer]
    r_taskdefer_t r_taskdefer = (r_taskdefer_t)(ASLR(0x8B4F40)); // push

    using r_getscheduler_t = uintptr_t(__cdecl*)(); // [Watchdog or LuauWatchdog]
    r_getscheduler_t r_getscheduler = (r_getscheduler_t)(ASLR(0xBC8020)); // after jnz get the call sub_xxxxxx dumper

    using r_print_t = uintptr_t(__cdecl*)(int type, const char* source);
    r_print_t r_lua_print = (r_print_t)(ASLR(0x114FC10));// Current identity is %d dumper

    using get_global_state = uintptr_t(__thiscall*)(int, int*, int*);
    get_global_state get_global_state_2 = (get_global_state)(ASLR(0x8774B0)); // Script Start or %s %s detected as malicious.  %s will not run. // most be in line 825 pseudocode
}

namespace Offsets
{
    // 'Argument 2 missing or nil' string
    const uintptr_t lua_state_top = 8;
    const uintptr_t lua_state_base = 24;
}

namespace Deobfuscation
{
    uintptr_t luastate(uintptr_t thi)
    {
        auto gay = 168 * 0 + thi + 276; // remeber to check + or -
        auto girl = gay ^ *reinterpret_cast<uintptr_t*>(gay);
        return girl;
    }
}
