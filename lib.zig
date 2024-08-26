const std = @import("std");

pub const Vector = struct {
    dimensions: u32,
    data: []f32,

    // init Vector in row-wise
    // (i.e. [1 2 3
    //        4 5 6
    //        7 8 9]
    //  would be read in left to right 1 2 3, then wrap around to 4 5 6, and so on.)
    pub fn init(allocator: std.mem.Allocator, dimensions: u32) !Vector {
        const data = try allocator.alloc(f32, dimensions);
        return Vector{
            .dimensions = dimensions,
            .data = data,
        };
    }

    // free up space from heap
    pub fn deinit(self: *Vector, allocator: std.mem.Allocator) void {
        allocator.free(self.data);
    }

    // dot product
    pub fn dot(self: Vector, other: Vector) f32 {
        std.debug.assert(self.dimensions == other.dimensions);
        var result: f32 = 0;
        for (self.data, other.data) |a, b| {
            result += (a * b);
        }
        return result;
    }

    // return scalar magnitude
    pub fn magnitude(self: Vector) f32 {
        var result: f32 = 0;
        for (self.data) |a| {
            result += (a * a);
        }
        return @sqrt(result);
    }

    // normalize the vector in-place, do not return a value
    pub fn normalize(self: Vector) void {
        const mag = self.magnitude();
        std.debug.assert(mag != 0);
        for (self.data) |*value| {
            value.* /= mag;
        }
    }

    pub fn euclideanDistance(self: Vector, other: Vector) f32 {
        var distance: f32 = 0;
        for (self.data, other.data) |a, b| {
            distance += (a - b) * (a - b);
        }
        return @sqrt(distance);
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var a = try Vector.init(allocator, 3);
    defer a.deinit(allocator);

    for (a.data) |*value| {
        value.* = 1;
    }

    std.debug.print("Vector a: ", .{});
    for (a.data) |value| {
        std.debug.print("{d} ", .{value});
    }
    std.debug.print("\n", .{});
}
