const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Import dependencies
    const zigjr = b.dependency("zigjr", .{
        .target = target,
        .optimize = optimize,
    });
    const yaml = b.dependency("yaml", .{
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "rapid-mcp-server",
        .root_module = b.createModule(.{
            .root_source_file = .{ .cwd_relative = "src/main.zig" },
            .target = target,
            .optimize = optimize,
        }),
    });

    // Expose dependencies to the executable
    exe.root_module.addImport("zigjr", zigjr.module("zigjr"));
    exe.root_module.addImport("yaml", yaml.module("yaml"));

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_cmd.step);
}


