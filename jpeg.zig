const std = @import("std");
const Self = @This();

fn root() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

const root_path = root() ++ "/";
pub const include_dir = root_path ++ "jpeg";

pub const Library = struct {
    step: *std.build.LibExeObjStep,

    pub fn link(self: Library, other: *std.build.LibExeObjStep) void {
        other.addIncludeDir(include_dir);
        other.addIncludeDir(root_path ++ "config");
        other.linkLibrary(self.step);
    }
};

fn withPrefix(prefix: []const u8, a: anytype) [a.len][]const u8 {
    var ret: [a.len][]const u8 = undefined;
    inline for (a) |v, i| ret[i] = prefix ++ v;
    return ret;
}

pub fn create(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) Library {
    const ret = b.addStaticLibrary("jpeg", null);
    ret.setTarget(target);
    ret.setBuildMode(mode);
    ret.addCSourceFiles(&LibSources, &.{"-DHAVE_CONFIG_H"});
    ret.linkLibC();
    ret.addIncludeDir(include_dir);
    ret.addIncludeDir(root_path ++ "config");

    return Library{ .step = ret };
}

const LibSources = withPrefix(root_path ++ "jpeg/", .{
    "jaricom.c",  "jcapimin.c", "jcapistd.c", "jcarith.c",  "jccoefct.c", "jccolor.c",
    "jcdctmgr.c", "jchuff.c",   "jcinit.c",   "jcmainct.c", "jcmarker.c", "jcmaster.c",
    "jcomapi.c",  "jcparam.c",  "jcprepct.c", "jcsample.c", "jctrans.c",  "jdapimin.c",
    "jdapistd.c", "jdarith.c",  "jdatadst.c", "jdatasrc.c", "jdcoefct.c", "jdcolor.c",
    "jddctmgr.c", "jdhuff.c",   "jdinput.c",  "jdmainct.c", "jdmarker.c", "jdmaster.c",
    "jdmerge.c",  "jdpostct.c", "jdsample.c", "jdtrans.c",  "jerror.c",   "jfdctflt.c",
    "jfdctfst.c", "jfdctint.c", "jidctflt.c", "jidctfst.c", "jidctint.c", "jquant1.c",
    "jquant2.c",  "jutils.c",   "jmemmgr.c",  "jmemnobs.c",
});

// const LibInstallHeaders = withPrefix(jlibPath, .{ "jerror.h", "jmorecfg.h", "jpeglib.h" });
