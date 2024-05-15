const std = @import("std");
const testing = std.testing;

pub const ZdOptions = struct {
    file_path: []u8 = undefined,
    allocator: std.mem.Allocator = undefined,

    pub fn filePath(self: ZdOptions) []const u8 {
        return self.file_path;
    }

    pub fn parse(self: *ZdOptions, alloc: std.mem.Allocator) !void {
        self.allocator = alloc;
        const args = try std.process.argsAlloc(alloc);
        defer std.process.argsFree(alloc, args);
        if (args.len < 2) {
            std.debug.print("Need some file!\n", .{});
            return;
        }

        for (args, 0..args.len) |arg, index| {
            if (index != 0) {
                self.file_path = try std.fmt.allocPrint(alloc, "{s}", .{arg});
            }
        }
    }

    pub fn dealloc(self: *ZdOptions) void {
        self.allocator.free(self.file_path);
    }
};
