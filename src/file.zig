const std = @import("std");

const File = struct {
    fs: u64 = 0,
    content: []u8 = undefined,
    bytesRead: usize = 0,
    allocator: std.mem.Allocator = undefined,

    pub fn dealloc(self: *File) void {
        self.allocator.free(self.content);
    }
};

pub fn readFile(filepath: []const u8, alloc: std.mem.Allocator) !File {
    const file = try std.fs.cwd().openFile(filepath, .{});
    defer file.close();

    var f = File{};
    f.allocator = alloc;
    f.fs = try file.getEndPos();

    f.content = try f.allocator.alloc(u8, f.fs);
    f.bytesRead = try file.read(f.content);

    return f;
}
