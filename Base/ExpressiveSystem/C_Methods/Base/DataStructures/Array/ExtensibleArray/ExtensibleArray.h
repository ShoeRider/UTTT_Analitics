#ifndef ExtensibleArray_H
#define ExtensibleArray_H



//EArray_t: ExtensibleArray_t
typedef struct EArray_t
{
  //TODO add Mutex Lock
    int* Array;
    //Pointer to block of memory
    //Size Holds the External representation of the array
    int Size;
    //_Size stores the real size of the array
    int _Size;

    int Elements;
} EArray_t;




#endif // ExtensibleArray_H
