#define DefaultHashSize 16



typedef struct AssociativeArray_t
{
  Mutex_t Mutex;
  int ArraySize;
  int ElementsAdded;

  int CollisionMode;
} AssociativeArray_t;


typedef struct Element_t
{
  float UniqueTag;
  void* Item;
}Element_t;
