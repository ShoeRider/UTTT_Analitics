


typedef struct Array_t
{
  Mutex_t Mutex;
  int ArraySize;
  int ElementsAdded;

  int CollisionMode;
} Array_t;
