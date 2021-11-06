#ifndef HashTable_Tests_CU
#define HashTable_Tests_CU


#include "../SRC/HashTable.cu"

struct Example_t
{
     // member declarations.
     char name[20];
      int id;
      int age;
    int GetHash()
    {
      return id;
    }
    bool equal(Example_t * Node0)
    {
      std::cout << "Compare:" << id << "-" << Node0->id <<"\n";
      return (id == Node0->id);
    }
};

int main() {
 Example_t* Example01 = new Example_t();
 Example01->id = 01;
 Example01->age = 01;
 Example_t* Example02 = new Example_t();
 Example02->id = 01;
 Example02->age = 02;


 //std::list<Example_t*> *Table = new std::list<Example_t*>[100];
 //delete [] Table;

 HashTable_t<Example_t>* HashTable = new HashTable_t<Example_t>(1);

 /*
 HashTable->Compare = [](Example_t Node0,Example_t Node1)->bool {
   return true;
 };
 */


 HashTable->AddGetReference(Example01);
 HashTable->AddGetReference(Example02);
  HashTable->displayHash();

 //delete Example01;
 //delete Example02;
 delete HashTable;
 return 0;
}

#endif //HashTable_Tests_CU
