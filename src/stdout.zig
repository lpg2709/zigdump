const std = @import("std");

pub const Stdout = struct {
    bw: std.io.Writer,
    stdout: std.io.Writer,

    pub fn init() Stdout {
        const self: Stdout = .{};
        const stdout_file = std.io.getStdOut().writer();
        self.bw = std.io.bufferedWriter(stdout_file);
        self.stdout = self.bw.writer();
        return self;
    }

    pub fn print(self: Stdout, comptime fmt: []const u8, args: anytype) !void {
        try self.stdout.print(fmt, args);
        try self.bw.flush();
    }
};

pub const zd_stdout: Stdout = Stdout.init();
