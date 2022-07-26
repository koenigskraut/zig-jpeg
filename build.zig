const std = @import("std");
const jpeg = @import("jpeg.zig");

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const lib = try jpeg.create(b, target, mode);
    lib.step.install;
}
