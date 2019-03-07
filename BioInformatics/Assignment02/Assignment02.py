# -*- coding: utf-8 -*-
"""
Created on Sun Feb 24 01:59:31 2019

@author: PC
"""
import time
import csv
from bitarray import bitarray
import random
import math



def ReadSubstitutionCSV(File_Path):
    SubstitutionMatrix = {}
    fasta_File = open(File_Path, "r")

    for RowIndex, RowChar in zip(range(4),"ACGT"):
        fasta_Line = fasta_File.readline()
        List = fasta_Line.split(" ")
        for ColIndex, ColChar in zip(range(4),"ACGT"):
            SubstitutionMatrix[Row+ColChar]= List[ColIndex]

    SubstitutionMatrix[""] =  List
    return SubstitutionMatrix



class Fasta:
    def __init__(self,File_Path,text=False):
        self.text = text
        self.StoredFasta = {}
        Section = "Bad_Read"
        fasta_File = open(File_Path, "r")
        fasta_Line = fasta_File.readline()
        while fasta_Line:
            if (fasta_Line[0] == ">"):
                Section = fasta_Line
                #print("Section: " + Section)
                self.StoredFasta[Section] = ""
            else:
                self.StoredFasta[Section] = self.StoredFasta[Section] + fasta_Line.split("\n")[0]

            fasta_Line = fasta_File.readline()
        if(self.text):
            self.CreateBinaryString_BaseDictionary()
    def getDictionary(self):
        if(self.text):
            return self.StoredFasta
        else:
            return self.BS_Fasta
    def CreateBinaryString_BaseDictionary(self):
        self.BS_Fasta = {}
        for element in self.StoredFasta:
            self.BS_Fasta[element] = {}
            self.BS_Fasta[element]["StringLength"] = len(self.StoredFasta[element])
            self.BS_Fasta[element]["BitLength"]    = int((len(self.StoredFasta[element]))*2)
            self.BS_Fasta[element]["BitString"]    = self.String_To_BinaryArray(self.StoredFasta[element])
    def String_To_BinaryArray(self,String):
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
    def k_mer(self, k):
        Dictionary = self.StoredFasta
        k = 2*k
        Kmer = {}
        if(self.text):
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

def Jaccard_Index_of2Fastas(Fasta_0,Fasta_1 ):
    Kmer_0 = Fasta_0.getDictionary()
    Kmer_1 = Fasta_1.getDictionary()
    OverLappingElements = 0
    UniqueElements = len(Kmer_0)

    for element_1 in Kmer_1:
        if element_1 in Kmer_0:
            OverLappingElements += 1
        else:
            UniqueElements += 1

    JaccardIndex = OverLappingElements/UniqueElements
    return JaccardIndex



def Create_BloomFilter_w_Fasta(File_Path,Length,text=False):
    Fasta = Fasta(File_Path,text)


def SuggestBloomFilterValues(self,n,p):
    #n - number of items we plan to put in the list
    #p - probability we will accept
    Size = (n*math.ln(p))/(math.ln(2)**2)
    HashFunctions = (Size/n)*math.ln(2)
    print("Suggested Array Size ",Size)
    print("Suggested # of Hashes:",HashFunctions)

#Implement a Bloom filter in python.
class BloomFilter:
    def __init__(self,ArrayLength,Hashes):
        #k = (m/n)*ln2
        #(ax+b) mod 17
        self.StoredStrings = {}
        self.HashMap = bitarray(ArrayLength)
        self.HashMap.setall(0)
        self.ArrayLength = ArrayLength
        self.Hashes = Hashes
        self.CharacterValues = {'A' : 101,'T' : 151,'C' : 191,'G' : 199}

        self.HashValues = {}
        for X in range(self.Hashes):
            A = random.randint(1,2*self.ArrayLength)
            B = random.randint(1,2*self.ArrayLength)
            self.HashValues[X] = {'A':A, 'B':B}

    def CountCharacters(self,String):
        CharacterCount = {'A' : 0,'T' : 0,'C' : 0,'G' : 0}
        for character in String:
            if character in CharacterCount:
                CharacterCount[character] += 1
            else:
                CharacterCount[character] = 0
        Sum = 0
        for X in "ATCG":
            Sum += self.CharacterValues[X]*CharacterCount[X]
        return Sum

    def FindArrayIndexes(self,String):
        ArrayIndexes = [0] * self.Hashes
        Sum = self.CountCharacters(String)
        #print(" self.HashValues:", len(self.HashValues),"ArrayIndexes:",len(ArrayIndexes),":",ArrayIndexes)
        for X in self.HashValues:
            #print("X",X,"* self.HashValues[X]['A']",self.HashValues[X]["A"],"= ",self.HashValues[X]["A"] * X)
            BitLocation = (self.HashValues[X]["A"] * Sum + self.HashValues[X]["B"])% self.ArrayLength
            ArrayIndexes[X] = BitLocation
        return ArrayIndexes

    def StringAdd(self,String):
        ArrayIndexes = self.FindArrayIndexes(String)
        for Index in ArrayIndexes:
            #print("Index",Index," Bitarray",bitarray('1'))
            #print()
            self.HashMap[Index] = bitarray('1')
    def AddDictionary(self,Dictionary):
        for element in Dictionary:
            self.StringAdd(Dictionary[element])
    #returns 0 if any hash missing in bitmap
    #returns 1 if all Hashes were present
    def StringCheck(self,String):
        ArrayIndexes = self.FindArrayIndexes(String)
        for Index in ArrayIndexes:
            if(self.HashMap[Index] == False):
                return 0
        return 1

def Test_BloomFilter():
    return 0

def Calculate_CondensedSize(X):
    return (1/2)*((X-1)*X)

#n*n Matrix
#index: i,j
def Calculate_ind(n,i,j):
    return ((n*(n-1))/2) -(((n-i)*(n-i-1))/2) +j-i-1
def Calculate_i(n,ind):
    return math.floor(-(((1-2*n)+(((1-2*n)**2)-8*ind)**(1/2))/2))
def Caclulate_j(ind,n,i):
    return ind+((i(1-2*n+i))/2)+1



def CreateDistanceMatrix_WithKmer(FileList):
    FastaDic = {}
    Fasta_kmerDic = {}
    Kmer = 10

    for Genome, FilePath in zip(range(len(FileList)),FileList):
        FastaDic[Genome] = Fasta(FilePath)
        Fasta_kmerDic[Genome] = Fasta_kmerDic[Genome].k_mer(Kmer)
    DifferenceMatrix = [len(FileList)][len(FileList)]

    for X in range(len(FileList)):
        for Y in range(len(FileList)):
            if(Y>X):
                #calculateFoundDifference = CalculateDifference(X,Y)
                FoundDifference =  1 - Jaccard_Index_of2Fastas(Fasta_kmerDic[X], Fasta_kmerDic[Y])
            DifferenceMatrix[X][Y] = FoundDifference
            DifferenceMatrix[X][Y] = FoundDifference
    return DifferenceMatrix

def Mean(Vector_0):
    Sum=0
    dimensions =len(Vector_0)
    for X in range(dimensions):
        Sum += Vector_0[X]
    return (Sum/dimensions)



def find_UPGMA_fromFileList(self,FileList):
    Col = len(FileList)
    for X in range(Col):
        ColTitles[X] = str(X)
    DistanceMatrix = CreateDistanceMatrix_WithKmer(FileList)


#Implement UPGMA in python.
    #create phylogenetic tree: a diagram showing inferred evolutionary relationships, between a set of organisms


    #finds difference of each string to each other, and has the matrix's
    #use this difference matrix

    #use the table to find the sequences that have the least differences between them
#Geneomes is a dictionary of the different genomes to Compaire
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
            self.ColTitles[To] = "("+self.ColTitles[From]+","+self.ColTitles[To]+")"
            #Take the 2 and merge into one row/Column,create string representing merge

            Average = [0] * self.Col
            self.Height[To] = SmallestGap

            for X in range(self.Col):
                Average[X] += (self.DistanceMatrix[From][X] + self.DistanceMatrix[To][X])/2
            for X in range(self.Col):
                if(X!=To):
                    self.DistanceMatrix[To][X] = Average[X]
                    self.DistanceMatrix[X][To] = Average[X]
            print()
            print("Step: ",(Col+1))
            print("Join Columns :",self.ColTitles[To])
            print("With a Distance of ",self.Height[To])


import numpy as np

a = np.array([0,1,2,3,4,5,5,6,7,8,9])
a_new = np.delete(a, 3, 0)






#Implement k-means in python.
#O(Iterations * Clusters * Instances * Dimensions)
#DataSet: set of feature vectors
#convergence threshold
class k_means:
    def __init__(self,DataSet,K):
        self.K = K
        self.DataElements = len(DataSet)
        self.DataDimensions = len(DataSet[0])
        self.Centroids = [ [ 0 for y in range( self.DataDimensions ) ] for x in range( self.K ) ]
        self.DataSet = DataSet
        self.PointsAssignedtoCentroids = [ [] for x in range( self.K ) ]

        self.AverageAssignedPoints = [0] * self.K
        for Y in range(self.DataDimensions):
            #find Min and Max of the Distribution of Dimension Y for all data points
            MinValue = 1
            MaxValue = 10

            for X in range(K):
                self.Centroids[X][Y] = random.randint(MinValue,MaxValue)
        print("Initial Points,",self.Centroids)
        print("Points associated with Centroids: ")


        self.NewCentroids = self.Centroids[X][Y]
        Changed = True
        while(Changed):
        #for Iterate in range(self.Iterations):
            ShortestCentroid = -1
            ShortestCentroidDistance = float("inf")
            self.PointsAssignedtoCentroids = [ [] for x in range( self.K ) ]
            self.AverageAssignedPoints = [0] * self.K
            for DataPointIndex in range(self.DataElements):
                for CentroidIndex in range(self.K):
                    #find Distance from Data point to all Centroids
                    Distance = self.Distance(self.DataSet[DataPointIndex],self.Centroids[CentroidIndex])
                    if(Distance < ShortestCentroidDistance):
                        ShortestCentroidDistance = Distance
                        ShortestCentroid = CentroidIndex
                #assign the DataPoint to the closest Centroids
                self.PointsAssignedtoCentroids[ShortestCentroid].append(DataPointIndex)

            for X in range(len(self.Centroids)):
                print("For ",X,":",self.PointsAssignedtoCentroids[X])

            # calculate the Mean DataValues of each Centroid
            #for DataPoint in DataSet:
            AllCentroidsChanged = True
            for CentroidDataPointIndex in range(len(self.PointsAssignedtoCentroids)):

                NewAveragePoint = [0]*self.DataDimensions
                Sum = [0]*self.DataDimensions

                points = len(self.PointsAssignedtoCentroids[CentroidDataPointIndex])

                if(points != 0):
                    for X in self.PointsAssignedtoCentroids[CentroidDataPointIndex]:
                        for dimension in range(self.DataDimensions):
                            Sum[dimension] += self.DataSet[X][dimension]


                    for dimension in range(self.DataDimensions):
                        NewAveragePoint[dimension] = Sum[dimension]/points

                        if(NewAveragePoint[dimension] == self.Centroids[CentroidDataPointIndex][dimension]):
                            AllCentroidsChanged = False
                        self.Centroids[CentroidDataPointIndex][dimension] = NewAveragePoint[dimension]

            #see if matrix changed
            if (AllCentroidsChanged):
                Changed = False

            # set the new value for each Centroid as the Mean found

        print("Final Points,",self.Centroids)
        print("Points associated with Centroids: ")
        for X in range(len(self.Centroids)):
            print("For ",X,":",self.Centroids[X])
            #for Y in range(len(self.PointsAssignedtoCentroids[X])):
            #    print(self.DataSet[self.PointsAssignedtoCentroids[X][Y]])
    def GetAssociationList(self):
        return self.PointsAssignedtoCentroids


    def Distance(self,Vector_0,Vector_1):
        Sum=0
        for X in range(self.DataDimensions):
            Sum += (Vector_0[X]-Vector_1[X])**2
        return (Sum)**(1/2)
    def Mean(self,Vector_0):
        Sum=0
        for X in range(self.DataDimensions):
            Sum += Vector_0[X]
        return (Sum/self.DataDimensions)






#Benchmark the python and C++ implementation
def Q3(X):
    return 0

def Time_Q3(X):
    return 0



#Test the bloom filter
def Q4():
    #Fasta_Object = Fasta(File_Path)
    #BloomFilter()
    BloomFilter_Object = BloomFilter(100,5)
    BloomFilter_Object.StringAdd("A")
    print(BloomFilter_Object.HashMap)
    print(BloomFilter_Object.StringCheck("A"))
    print(BloomFilter_Object.StringCheck("TAT"))
    return 0
Q4()

def Time_Q4(X):
    return 0


def Create_Random_DistanceMatrix(NxN):
    DistanceMatrix = [ [ 0 for y in range( NxN ) ] for x in range( NxN ) ]
    for X in range(NxN):
        for Y in range(NxN):
            if Y > X:
                Random = random.randint(1,10)
                DistanceMatrix[X][Y] = Random
                DistanceMatrix[Y][X] = Random
    return DistanceMatrix
#
def Q5():
    DistanceMatrix = Create_Random_DistanceMatrix(3)
    print(DistanceMatrix)
    UPGMA_object = UPGMA(DistanceMatrix)
    return 0
Q5()



def Time_Q5(X):
    return 0



import matplotlib.pyplot as plt



def Create_Random_DataSet(DataPoints,DataDimensions):
    DistanceMatrix = [ [ 0 for y in range( DataDimensions ) ] for x in range( DataPoints ) ]
    for X in range(DataPoints):
        for Y in range(DataDimensions):
            DistanceMatrix[X][Y] = random.randint(1,10)

    return DistanceMatrix

def Q6():
    DataSet = Create_Random_DataSet(10,1)
    for X in range(len(DataSet)):
        plt.scatter(0,DataSet[X])
        #plt.scatter(DataSet[X][0],DataSet[X][1])
    plt.show()
    print(DataSet)

    k_means_object = k_means(DataSet,3)
    AssociationList = k_means_object.GetAssociationList()
    print(AssociationList)
    for X in range(3):
        print("------",X)
        for Y in range(len(AssociationList[X])):
            print("->",DataSet[AssociationList[X][Y]])
            plt.scatter(0,DataSet[AssociationList[X][Y]])
            #plt.scatter(DataSet[Y][0],DataSet[Y][1])
        plt.show()
    #return 0
Q6()


def Time_Q6(X):
    return 0
