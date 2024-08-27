#include "hnswlib_wrapper.h"
#include "hnswlib/hnswlib.h"

extern "C" {

struct HNSWIndex {
    hnswlib::L2Space* space;
    hnswlib::HierarchicalNSW<float>* index;
};

HNSWIndex* hnswlib_index_create(int dim, long max_elements, int M, int ef_construction) {
    HNSWIndex* index = new HNSWIndex;
    index->space = new hnswlib::L2Space(dim);
    index->index = new hnswlib::HierarchicalNSW<float>(index->space, max_elements, M, ef_construction);
    return index;
}

void hnswlib_index_destroy(HNSWIndex* index) {
    delete index->index;
    delete index->space;
    delete index;
}

void hnswlib_index_add_point(HNSWIndex* index, const float* point, long label) {
    index->index->addPoint(point, label);
}

long hnswlib_index_search(HNSWIndex* index, const float* query, int k, long* labels, float* distances) {
    std::priority_queue<std::pair<float, hnswlib::labeltype>> result = index->index->searchKnn(query, k);
    int i = 0;
    while (!result.empty()) {
        auto& element = result.top();
        distances[i] = element.first;
        labels[i] = element.second;
        result.pop();
        i++;
    }
    return i;
}

}
