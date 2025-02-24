const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "hello-world",
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "hello-world",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(exe);

    // This *creates* a Run step in the build graph, to be executed when another
    // step is evaluated that depends on it. The next line below will establish
    // such a dependency.
    const run_cmd = b.addRunArtifact(exe);

    // By making the run step depend on the install step, it will be run from the
    // installation directory rather than directly from within the cache directory.
    // This is not necessary, however, if the application depends on other installed
    // files, this ensures they will be present and in the expected location.
    run_cmd.step.dependOn(b.getInstallStep());

    const line_exe = b.addExecutable(.{
        .name = "hello-line",
        .root_source_file = b.path("src/readLineByLine.zig"),
        .target = target,
        .optimize = optimize,
    });

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(line_exe);

    const exe_1_2 = b.addExecutable(.{
        .name = "mmap_1_2",
        .root_source_file = b.path("src/mmap_1_2.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe_1_2);

    const exe_1_3 = b.addExecutable(.{
        .name = "exe_1_3",
        .root_source_file = b.path("src/file_1_3.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe_1_3);

    const exe_1_4 = b.addExecutable(.{
        .name = "exe_1_4",
        .root_source_file = b.path("src/file_1_4.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe_1_4);

    const exe_1_5 = b.addExecutable(.{
        .name = "exe_1_5",
        .root_source_file = b.path("src/file_1_5.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe_1_5);

    const exe_3_1 = b.addExecutable(.{
        .name = "exe_3_1",
        .root_source_file = b.path("src/time_3_1.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe_3_1);

    const exe_4_1 = b.addExecutable(.{
        .name = "exe_4_1",
        .root_source_file = b.path("src/net_4_1.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe_4_1);

    const exe_7_1 = b.addExecutable(.{
        .name = "exe_7_1",
        .root_source_file = b.path("src/concurrency_7_1.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe_7_1);

    const exe_7_2 = b.addExecutable(.{
        .name = "exe_7_2",
        .root_source_file = b.path("src/concurrency_7_2.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe_7_2);

    const exe_7_3 = b.addExecutable(.{
        .name = "exe_7_3",
        .root_source_file = b.path("src/concurrency_7_3.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe_7_3);

    const os_1 = b.addExecutable(.{
        .name = "os_1",
        .root_source_file = b.path("src/os_1.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(os_1);

    const json_1 = b.addExecutable(.{
        .name = "json_1",
        .root_source_file = b.path("src/json_1.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(json_1);

    // By making the run step depend on the install step, it will be run from the
    // installation directory rather than directly from within the cache directory.
    // This is not necessary, however, if the application depends on other installed
    // files, this ensures they will be present and in the expected location.
    run_cmd.step.dependOn(b.getInstallStep());
    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build run`
    // This will evaluate the `run` step rather than the default, which is "install".
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
