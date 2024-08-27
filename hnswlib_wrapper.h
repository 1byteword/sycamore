#ifndef HNSWLIB_WRAPPER_H
#define HNSWLIB_WRAPPER_H

#ifdef __cplusplus
extern "C" {
#endif

typedef struct HNSWIndex HNSWIndex;

HNSWIndex* hnswlib_index_create(int dim, long max_elements, int M, int ef_construction);
void hnswlib_index_destroy(HNSWIndex* index);
void hnswlib_index_add_point(HNSWIndex* index, const float* point, long label);
long hnswlib_index_search(HNSWIndex* index, const float* query, int k, long* labels, float* distances);

#ifdef __cplusplus
}
#endif

#endif // HNSWLIB_WRAPPER_H
