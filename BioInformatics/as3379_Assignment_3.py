from bitarray import bitarray
import random
import math
import time

from string import ascii_lowercase

def Read_fasta(File_Path,text=False):
    Fasta = {}
    Line = 0
    Section = "Bad_Read"
    fasta_File = open(File_Path, "r")
    fasta_Line = fasta_File.readline()
    while fasta_Line:
        Line += 1
        if (fasta_Line[0] == ">"):
            Section = fasta_Line[:]
            #print("Section: " + Section)
            Fasta[Section] = ""
        else:
            Fasta[Section] = Fasta[Section] + fasta_Line.split("\n")[0]
        #print("Line: " + str(Line))

        fasta_Line = fasta_File.readline()

    #File_Name = File_Path.split(".")[0]
    #with open(File_Name + '.json', 'w') as fp:
    #    json.dump(Fasta, fp)


    #print("Text?:",text)
    if(text):
        return CreateBinaryString_BaseDictionary(Fasta)
    return Fasta

def String_To_BinaryArray(String):
    BinaryArray = bitarray(len(String)*2)
    Count =0;
    for Base in String:
        if(Base == "A"):
            BinaryArray[Count:Count+2] = bitarray('00')
        elif(Base == "G"):
            BinaryArray[Count:Count+2] = bitarray('01')
        elif(Base == "C"):
            BinaryArray[Count:Count+2] = bitarray('10')
        elif(Base == "T"):
            BinaryArray[Count:Count+2] = bitarray('11')
        Count+=2
    return BinaryArray

def CreateBinaryString_BaseDictionary(Fasta):
    BS_Fasta = {}
    for element in Fasta:
        BS_Fasta[element] = {}
        BS_Fasta[element]["StringLength"] = len(Fasta[element])
        BS_Fasta[element]["BitLength"]   = int((len(Fasta[element]))*2)
        BS_Fasta[element]["BitString"] = String_To_BinaryArray(Fasta[element])
        
    return BS_Fasta


#Implement UPGMA in python.
    #create phylogenetic tree: a diagram showing inferred evolutionary relationships, between a set of organisms


    #finds difference of each string to each other, and has the matrix's
    #use this difference matrix

    #use the table to find the sequences that have the least differences between them
#Geneomes is a dictionary of the different genomes to Compaire
#Should only be able to handle a grid of NxN where N < 23, and only supports a-z Characters 
class UPGMA:
    def __init__(self,DistanceMatrix):
        self.Col = len(DistanceMatrix)
        self.IgnoreCol = []
        self.Height    = [0]  *self.Col
        self.ColTitles = [" "]*self.Col
        for X in range(self.Col):
            self.ColTitles[X] = str(X)
        self.DistanceMatrix = DistanceMatrix

        #print(self.ColTitles)
        for Col in range(self.Col-1):
            From = -1
            To = -1
            SmallestGap = float("inf")
            for X in range(self.Col):
                if((X not in self.IgnoreCol)):
                    for Y in range(self.Col):
                        if((Y not in self.IgnoreCol)):
                            if(Y>X):
                                if(SmallestGap > self.DistanceMatrix[X][Y]):
                                    From = X
                                    To = Y
                                    SmallestGap = self.DistanceMatrix[X][Y]
            self.IgnoreCol.append(From)
            GapValue =SmallestGap/2

            self.ColTitles[To] = "("+self.ColTitles[From]+":"+str(GapValue)+","+self.ColTitles[To]+":"+str(GapValue)+")"
            #Take the 2 and merge into one row/Column,create string representing merge

            Average = [0] * self.Col
            self.Height[To] = SmallestGap

            for X in range(self.Col):
                Average[X] += (self.DistanceMatrix[From][X] + self.DistanceMatrix[To][X])/2
            for X in range(self.Col):
                if(X!=To):
                    self.DistanceMatrix[To][X] = Average[X]
                    self.DistanceMatrix[X][To] = Average[X]
            #print()
            #print("Step: ",(Col+1))
            #print("Join Columns :",self.ColTitles[To])
            #print("With a Distance of ",self.Height[To])
            #return self.ColTitles[To]
        print("Final Result:",self.ColTitles[To])
        #return self.ColTitles[To]

#1.Reimplement the UPGMA algorithm in python. This version will return a Newick string with the
#computed edge lengths that maintain the ultrametric property.
def CreateNEWICKTree_with_UPGMA(String):
    return 0



#2. Implement a prefix trie in python that mimics the functionality of “k_mer(sequence, k)” function
#from homework 


class KMer_TrieNode:
    def __init__(self,ID="",K=4):
        self.ID = ID
        self.K = K
        self.Elements = 0
        self.List = []
        self.Trie =  {}
        
    def Add_Index(self,String,Index):
        #len(String)
        if (len(String) == 0):
            self.List.append(Index)
            return 1
        Character = String[0]
        if Character in self.Trie:
            #Transverse
            self.Trie[Character].Add_Index(String[1:],Index)
            self.Elements += 1
            return 1
        # No itterative Child node has been found, Create Child Node, and transverse
        self.Trie[Character] = KMer_TrieNode(Character)
        self.Trie[Character].Add_Index(String[1:],Index)
        self.Elements += 1
        
    def Check_Entry(self,String):
        if (len(String) == 0):
            return self.List
        Character = String[0]
        if Character in self.Trie:
            #Transverse
            return self.Trie[Character].Check_Entry(String[1:])
        # No itterative Child node has been found, Create Child Node, and transverse
        return 0
    def AddKmer_String(self,String):
        k = 2*self.K
        for OffSet in range(len(String) - (k-1)):
            SubSequence = String[OffSet:OffSet + k]
            self.Add_Index(SubSequence,OffSet)
    def AddKmer_FASTADictionary(self,Dictionary):
        k = 2*self.K
        for element in Dictionary:
            for OffSet in range(len(Dictionary[element]) - (k-1)):
                SubSequence = Dictionary[element][OffSet:OffSet + k]
                self.Add_Index(SubSequence,OffSet)





def k_mer(Dictionary, k,text=False):
    k = 2*k
    Kmer = {}
    if(text):
        for element in Dictionary:
            for OffSet in range(0,Dictionary[element]["BitLength"]-(k),2):
                SubSequence = str(Dictionary[element]["BitString"][OffSet:OffSet + k])
                if (SubSequence in Kmer):
                    Kmer[SubSequence].append(OffSet)
                else:
                    Kmer[SubSequence] = []
                    Kmer[SubSequence].append(OffSet)
        #print("Done")
        return Kmer
    else:    
        for element in Dictionary:
            for OffSet in range(len(Dictionary[element]) - (k-1)):
                SubSequence = Dictionary[element][OffSet:OffSet + k]
                if (SubSequence in Kmer):
                    Kmer[SubSequence].append(OffSet)
                else:
                    Kmer[SubSequence] = []
                    Kmer[SubSequence].append(OffSet)
        #print("Done")
        return Kmer
    #print(Kmer)



#~ Generate a set of benchmarks comparable to those of homework 
#~ Discuss your results.

def Create_Random_DistanceMatrix(NxN):
    DistanceMatrix = [ [ 0 for y in range( NxN ) ] for x in range( NxN ) ]
    for X in range(NxN):
        for Y in range(NxN):
            if Y > X:
                Random = random.randint(1,10)
                DistanceMatrix[X][Y] = Random
                DistanceMatrix[Y][X] = Random
    return DistanceMatrix

def Question_1():
    DistanceMatrix = Create_Random_DistanceMatrix(3)
    print(DistanceMatrix)
    UPGMA_object = UPGMA(DistanceMatrix)
    return 0

#Question_2()
def Question_2(Itterations=3,K=4):
    print("Starting Tests")
    KMer_TrieTime=[]
    KMer_DictTime=[]
    FastaDic = Read_fasta("GCF_000007825.fna")
    
    for X in range(Itterations):
        t0 = time.time()
        KMer_Trie = KMer_TrieNode(K=K)
        KMer_Trie.AddKmer_FASTADictionary(FastaDic)
        t1 = time.time()
        KMer_TrieTime.append(t1-t0)
        print("KMer_Tri Itteration: ",X," Took",t1-t0)
        
    for X in range(Itterations):
        t0 = time.time()
        k_mer(FastaDic,K)
        t1 = time.time()
        KMer_DictTime.append(t1-t0)
        print("KMer_Dict Itteration: ",X," Took",t1-t0)
    return 0
