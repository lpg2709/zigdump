const std = @import("std");
const arg = @import("args.zig");
const file = @import("file.zig");

fn hexview(allocator: std.mem.Allocator, col: usize, content: []u8) !void {
    const stdout = std.io.getStdOut();

    const col_f: f32 = @floatFromInt(col);
    const prefix_size = 7 + 2; // 7 digits, one `:` and a space
    const hex_view_size = (col * 2) + (@as(usize, @intFromFloat(@ceil(col_f / 2.0))) - 1); // Hex digits char, plus spaces
    const chars_view_size = 2 + col; // sapces, chars
    const line_size: usize = prefix_size + hex_view_size + chars_view_size;

    var i: usize = 0;
    while (i < content.len - 1) {
        const line = try allocator.alloc(u8, line_size);
        defer allocator.free(line);
        var line_offset: usize = 0;

        _ = try std.fmt.bufPrint(line[0..prefix_size], "{x:0>7}: ", .{i});
        line_offset = prefix_size;

        var ii: usize = i;
        while (ii < (i + col)) {
            if (ii < content.len - 1) {
                _ = try std.fmt.bufPrint(line[line_offset..], "{x:0>2}{x:0>2} ", .{ content[ii], content[ii + 1] });
            } else {
                _ = try std.fmt.bufPrint(line[line_offset..], "     ", .{});
            }
            ii += 2;
            line_offset += 5;
        }

        _ = try std.fmt.bufPrint(line[line_offset..], " ", .{});
        line_offset += 1;

        ii = i;
        while (ii < (i + col)) {
            if (ii < content.len) {
                if (std.ascii.isPrint(content[ii]) and content[ii] != ' ') {
                    _ = try std.fmt.bufPrint(line[line_offset..], "{c}", .{content[ii]});
                } else {
                    _ = try std.fmt.bufPrint(line[line_offset..], ".", .{});
                }
            }
            ii += 1;
            line_offset += 1;
        }

        try stdout.writer().print("{s}\n", .{line});
        i += 16;
    }
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var opt = arg.ZdOptions{};
    try opt.parse(allocator);
    defer opt.dealloc();

    var f = try file.readFile(opt.filePath(), allocator);
    defer f.dealloc();

    const col: usize = 16;

    try hexview(allocator, col, f.content);
}

test "simple test" {}
