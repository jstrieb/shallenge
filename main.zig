const std = @import("std");

fn count_zeroes(a: []u8) usize {
    var result: usize = 0;
    for (a) |b| {
        if (b == 0) {
            result += 2;
        } else if (b < 0x10) {
            result += 1;
            break;
        } else {
            break;
        }
    }
    return result;
}

pub fn main() !void {
    const base = "jstrieb/a";
    var in: [64]u8 = .{0} ** 64;
    @memcpy(in[0..base.len], base);
    var out: [32]u8 = undefined;
    var length: usize = 2;
    while (true) {
        for (1..length) |i| {
            for ('a'..'z' + 1) |c| {
                in[base.len + i] = @intCast(c);
                std.crypto.hash.sha2.Sha256.hash(in[0 .. base.len + length], &out, .{});
                std.debug.print("{s} {s}\n", .{ in[0 .. base.len + length], std.fmt.bytesToHex(out, std.fmt.Case.lower) });
                std.debug.print("{d}\n", .{count_zeroes(&out)});
            }
        }
        length += 1;
        break;
    }
}
