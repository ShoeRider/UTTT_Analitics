HashTable_t* Create_HashTable_t(int ArraySize)
{
	HashTable_t* HashTable = (HashTable_t*) malloc(sizeof(HashTable_t));

	HashTable->ArraySize = ArraySize;
	HashTable->ElementsAdded = 0;

	HashTable->Table = (Hash_t*) malloc(ArraySize*sizeof(Hash_t));
	Hash_t* SetHash = HashTable->Table;


	for(int x=0;x<ArraySize;x++)
	{
			//printf("Looping through array %d\n",x );
		SetHash[x].Accessed  = false;
		SetHash[x].Structure = NULL;
		SetHash[x].UniqueTag = 0;
					//printf("end of loop through array %d\n",x );
	}
	return HashTable;
}
HashTable_t* Create_HashTable_t(int ArraySize)
{
	HashTable_t* HashTable = (HashTable_t*) malloc(sizeof(HashTable_t));

	HashTable->ArraySize = ArraySize;
	HashTable->ElementsAdded = 0;

	HashTable->Table = (Hash_t*) malloc(ArraySize*sizeof(Hash_t));
	Hash_t* SetHash = HashTable->Table;


	for(int x=0;x<ArraySize;x++)
	{
			//printf("Looping through array %d\n",x );
		SetHash[x].Structure = NULL;
		SetHash[x].UniqueTag = 0;
					//printf("end of loop through array %d\n",x );
	}
	return HashTable;
}
