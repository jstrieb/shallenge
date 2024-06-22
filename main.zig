const std = @import("std");

const base = "jstrieb/";
const size = 64;
var most_zeroes: usize = 0;

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

fn try_all(in: []u8, out: *[32]u8, length: usize) void {
    if (length <= 0) {
        std.crypto.hash.sha2.Sha256.hash(in, out, .{});
        const zeroes = count_zeroes(out);
        if (zeroes > most_zeroes) {
            std.debug.print("{d} {s} {s}\n", .{ zeroes, in, std.fmt.bytesToHex(out, std.fmt.Case.lower) });
            most_zeroes = zeroes;
        }
        return;
    }
    for ('a'..'z' + 1) |c| {
        in[base.len + length - 1] = @intCast(c);
        try_all(in, out, length - 1);
    }
}

pub fn main() !void {
    var in: [size]u8 = .{0} ** size;
    @memcpy(in[0..base.len], base);
    var out: [32]u8 = undefined;
    var length: usize = 1;
    while (length < size - base.len) {
        try_all(in[0 .. base.len + length], &out, length);
        length += 1;
    }
}
