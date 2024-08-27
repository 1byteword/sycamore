const c = @cImport({
    @cInclude("hnswlib_wrapper.h");
});

pub const HNSWIndex = opaque {};

pub const Index = struct {
    index: *HNSWIndex,

    pub fn create(dim: i32, max_elements: i64, M: i32, ef_construction: i32) !Index {
        const index = c.hnswlib_index_create(dim, max_elements, M, ef_construction);
        if (index == null) return error.IndexCreationFailed;
        return Index{ .index = index };
    }

    pub fn deinit(self: *Index) void {
        c.hnswlib_index_destroy(self.index);
    }

    pub fn addPoint(self: *Index, point: []const f32, label: i64) void {
        c.hnswlib_index_add_point(self.index, point.ptr, label);
    }

    pub fn search(self: *Index, query: []const f32, k: i32, labels: []i64, distances: []f32) i64 {
        return c.hnswlib_index_search(self.index, query.ptr, k, labels.ptr, distances.ptr);
    }
};
