/*
====================================================================================================
Description: HashTable

Custom implementation of hashtable for different DataTypes.
====================================================================================================
Date:           16 October 2021
Script Version: 1.0
Description: MCHS is a  modified version of MCTS to utilize a hash table in
conjunction with the standard MCTS search tree. This uses the game hash to
quickly find the duplicate game’s within different branches and prevents
identical branches from searching the same space.
==========================================================

*/


#ifndef HashTable_cu
#define HashTable_cu

#include <list>
#include <iostream>
#include <functional>

//reference:
//https://www.geeksforgeeks.org/c-program-hashing-chaining/
template <typename Data_Tp>
class HashTable_t
{
private:

public:
   //////////////////////////////////////////////////////////////////////////////
   // HashTable Values
   //////////////////////////////////////////////////////////////////////////////
   std::list<Data_Tp*> *Table;
   int TableSize;    // No. of buckets

   //////////////////////////////////////////////////////////////////////////////
   // Data_Tp Operations.
   //////////////////////////////////////////////////////////////////////////////
   //auto Compare = [](Data_Tp Node0,Data_Tp Node1);

   //bool (*Compare)(Data_Tp Node0,Data_Tp Node1);
   //bool (*Hash)(Data_Tp Node0);

   //////////////////////////////////////////////////////////////////////////////
   // Initialization method.
   //,std::function< int(int) >& lambda
   HashTable_t(int Size)
  {


      TableSize = Size;
      Table = new std::list<Data_Tp*>[TableSize];
  }



~HashTable_t(){
  //free(Table);
  for (int index=0;index<TableSize;index++){
    for (Data_Tp* Node : Table[index]){
      delete Node;
    }
  }
  delete [] Table;
  //realloc(Table) ;
  /*
  for (Data_Tp* Node : Table){
    delete Node;
  }*/
}

   //////////////////////////////////////////////////////////////////////////////
   // Method Declarations.
   //////////////////////////////////////////////////////////////////////////////

   // inserts a key into hash table
   std::tuple<Data_Tp*,bool> AddGetReference(Data_Tp* Node);
   void displayHashStats();
   // deletes a key from hash table
   void deleteItem(Data_Tp Node);

   // hash function to map values to key
   int FindBucket(int HashValue) {
       return (HashValue % TableSize);
   }
   int FindBucket(std::size_t HashValue) {
       return (HashValue % TableSize);
   }
   int UniqueNodes(){
     int count = 0;
     for (int index=0;index<TableSize;index++){
       for (Data_Tp* Node : Table[index]){
         count++;
       }
     }
     return count;
   }

   void displayHash();
};


//True: added node to HashTable
//False: returning existing value.
template <typename Data_Tp>
std::tuple<Data_Tp*,bool> HashTable_t<Data_Tp>::AddGetReference(Data_Tp* NewNode)
{
    int index = FindBucket(NewNode->GetHash());

    // Check each element of list.
    for (Data_Tp* Node : Table[index]){
      if(NewNode->equal(Node)){

        //std::cout << NewNode->GivenGame->Generate_StringRepresentation();
        //std::cout << Node->GivenGame->Generate_StringRepresentation();
        //std::cout << "Same Node\n";
//Parents.size()
        delete NewNode;
        return std::make_tuple(Node,false);
      }
    }
    //std::cout << "Insert ID\n";

    Table[index].push_back(NewNode);
    return std::make_tuple(NewNode,true);
}




template <typename Data_Tp>
void HashTable_t<Data_Tp>::deleteItem(Data_Tp key)
{
  // get the hash index of key
  int index = hashFunction(key);

  // find the key in (index)th list
/*
std::list<Data_Tp>::iterator i = Table[index].begin()
for (i ; i != Table[index].end(); i++) {
  if (*i == key)
    break;
}

// if key is found in hash table, remove it
if (i != table[index].end())
  table[index].erase(i);
  */
}



// function to display hash table
template <typename Data_Tp>
void HashTable_t<Data_Tp>::displayHash() {

  for (int i = 0; i < TableSize; i++) {
    std::cout << "[" << i << "]"  << Table[i].size() <<"\n";

    for (auto x : Table[i])
    std::cout << std::endl;
  }
}

template <typename Data_Tp>
void HashTable_t<Data_Tp>::displayHashStats() {

  for (int i = 0; i < TableSize; i++) {
    std::cout << i;
    for (auto x : Table[i])
      //std::cout << " --> " << x->age;
    std::cout << std::endl;
  }
}


#endif //HashTable_cu
