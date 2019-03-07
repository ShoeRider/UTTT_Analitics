# -*- coding: utf-8 -*-
#v
import sys, json
import random
import math
import os
import time
import csv
from bitarray import bitarray
#BitMap
encodeBitDictionary = {'A': b'\x00' , 'G': b'\x01' , 'C': b'\x02' , 'T': b'\x03' }
encodeIntDictionary = {'A': 0 , 'G': 1 , 'C': 2 , 'T': 3 }
decodeList = ['A', 'G', 'C', 'T']



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


	

	
def Find_GenomeRatio_BS(BS_Fasta,RatioBases):
    TotalSequence = 0.0
    FoundCount = 0.0
    A = 0.0
    C = 0.0
    G = 0.0
    T = 0.0
    for element in BS_Fasta:
        for Count in range(0,BS_Fasta[element]["BitLength"],2):
            TotalSequence+=1
            #print(BS_Fasta[element]['BitString'][Count:Count+2])
            if (BS_Fasta[element]['BitString'][Count:Count+2] == bitarray('00')):
                A+=1
            elif (BS_Fasta[element]['BitString'][Count:Count+2] == bitarray('01')):
                G+=1
            elif (BS_Fasta[element]['BitString'][Count:Count+2] == bitarray('10')):
                C+=1
            elif (BS_Fasta[element]['BitString'][Count:Count+2] == bitarray('11')):
                T+=1
					
    if ("A" in RatioBases):
        FoundCount += A
    if ("C" in RatioBases):
        FoundCount += C
    if ("G" in RatioBases):
        FoundCount += G
    if ("T" in RatioBases):
        FoundCount += T
    print("A:" + str(A)+" Ratio:"+str(A/TotalSequence))
    print("C:" + str(C)+" Ratio:"+str(C/TotalSequence))
    print("G:" + str(G)+" Ratio:"+str(G/TotalSequence))
    print("T:" + str(T)+" Ratio:"+str(T/TotalSequence))
    print("Total: "+str(TotalSequence))
    return FoundCount/TotalSequence
	

def Find_GenomeRatio(Fasta,RatioBases,text=False):
    TotalSequence = 0.0
    FoundCount = 0.0
    A = 0.0
    C = 0.0
    G = 0.0
    T = 0.0
    if(text):
        for element in Fasta:
            for Count in range(0,Fasta[element]["BitLength"],2):
                TotalSequence+=1
                #print(BS_Fasta[element]['BitString'][Count:Count+2])
                if (Fasta[element]['BitString'][Count:Count+2] == bitarray('00')):
                    A+=1
                elif (Fasta[element]['BitString'][Count:Count+2] == bitarray('01')):
                    G+=1
                elif (Fasta[element]['BitString'][Count:Count+2] == bitarray('10')):
                    C+=1
                elif (Fasta[element]['BitString'][Count:Count+2] == bitarray('11')):
                    T+=1
    else:
        for element in Fasta:
            for string in Fasta[element]:
                for base in string:
                    TotalSequence+=1
                    if (base == 'A'):
                        A+=1
                    if (base == 'C'):
                        C+=1
                    if (base == 'G'):
                        G+=1
                    if (base == 'T'):
                        T+=1
    if ("A" in RatioBases):
        FoundCount += A
    if ("C" in RatioBases):
        FoundCount += C
    if ("G" in RatioBases):
        FoundCount += G
    if ("T" in RatioBases):
        FoundCount += T
    print("A:" + str(A)+" Ratio:"+str(A/TotalSequence))
    print("C:" + str(C)+" Ratio:"+str(C/TotalSequence))
    print("G:" + str(G)+" Ratio:"+str(G/TotalSequence))
    print("T:" + str(T)+" Ratio:"+str(T/TotalSequence))
    print("Total: "+str(TotalSequence))
    return FoundCount/TotalSequence

def k_mer_String(sequence, k):
    Kmer = {}
    print("number of K-mer elements : " + len(sequence)-(k-1))
    for OffSet in range(len(sequence) - (k-1)):
        SubSequence = sequence[OffSet:OffSet + k]
        if (SubSequence in Kmer):
            Kmer[SubSequence].append(OffSet)
        else:
            Kmer[SubSequence] = []
            Kmer[SubSequence].append(OffSet)
    #print(Kmer)
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
    


def Jaccard_Index_ofK_mers(Kmer_0, Kmer_1):
    OverLappingElements = 0
    UniqueElements = len(Kmer_0)

    for element_1 in Kmer_1:
        if element_1 in Kmer_0:
            OverLappingElements += 1
        else:
            UniqueElements += 1

    JaccardIndex = OverLappingElements/UniqueElements
    return JaccardIndex


#returns a dictionary of randomly selected sequences from a genome's dictionary.
def read_samples(Dictionary, mer_length, read_count,text=False):
    Samples = {}
    if(text):
        for X in range(read_count):
            element = random.choice(list(Dictionary))
            Position = random.randint(0,(Dictionary[element]["StringLength"]-mer_length))
            Samples[str(X)+"|"+str(Position)] = Dictionary[element]["BitString"][Position*2:Position*2+mer_length*2]
    else:
        for X in range(read_count):
            element = random.choice(list(Dictionary))
            Position = random.randint(0,len(Dictionary[element])-mer_length)
            Samples[str(X)+"|"+str(Position)] = Dictionary[element][Position:Position+mer_length]
    return Samples

#"GC" content of FASTA File
def Q2(File_0,File_1):
    print("GC content of FASTA File")
    print(File_0)
    Fasta = Read_fasta(File_0)
    Find_GenomeRatio(Fasta,"GC")
    print("\n")
    print("GC content of FASTA File")
    print(File_1)
    Fasta = Read_fasta(File_1)
    Find_GenomeRatio(Fasta,"GC")
    return 0 

def Q3(File_0,File_1):
    print("kmers of FASTA File")
    print(File_0)
    Fasta = Read_fasta(File_0)
    Fasta_Kmer = k_mer(Fasta,10)
    print("Fasta_Kmer's length: ",len( Fasta_Kmer))

    print("\n")
    print("kmers of FASTA File")
    print(File_1)
    Fasta = Read_fasta(File_1)
    Fasta_Kmer = k_mer(Fasta,10)
    print("Fasta_Kmer's length: ",len( Fasta_Kmer))
    return 0 

def Q4(File_0,File_1):
    Fasta_0 = Read_fasta(File_0)
    Fasta_1 = Read_fasta(File_1)
    
    print("The Jaccard's index between these two files: with [4,8,12] KMer values:")
    print(File_0)
    print(File_1)
    for X in [4,8,12]:
        Fasta_Kmer_0 = k_mer(Fasta_0,X)
        Fasta_Kmer_1 = k_mer(Fasta_1,X)
        
        print(X,"_mer between these files is:",Jaccard_Index_ofK_mers(Fasta_Kmer_0,Fasta_Kmer_1))
    return 0 


def Q5(File_0):

    Fasta_0 = Read_fasta(File_0) 
    print("The Jaccard's index between these two files: with [4,8,12] KMer values:")
    print(File_0)
    Samples = read_samples(Fasta_0, 10, 100,text=False)
    print(Samples)
    return 0 

def Time_Q1(Iterations,File):
    Records = {}
    for X in range(Iterations):
        Records[X] = {}
        
        t0 = time.time()
        Fasta = Read_fasta(File)
        t1 = time.time()
        
        Records[X]["Read_Fasta"] = {}
        Records[X]["Read_Fasta"]["String"] = {}
        Records[X]["Read_Fasta"]["String"]["Time"] = t1-t0
        
        
        t0 = time.time()
        Fasta_BS = Read_fasta(File, text=True)
        t1 = time.time()

        
        Records[X]["Read_Fasta"]["BiteString"] = {}
        Records[X]["Read_Fasta"]["BiteString"]["Time"] = t1-t0
        
        
        
        t0 = time.time()
        Find_GenomeRatio(Fasta,"GC")
        t1 = time.time()
        
        Records[X]["Find_GenomeRatio"] = {}
        Records[X]["Find_GenomeRatio"]["String"] = {}
        Records[X]["Find_GenomeRatio"]["String"]["Time"] = t1-t0
        
        
        t0 = time.time()
        Find_GenomeRatio(Fasta_BS,"GC",text=True)
        t1 = time.time()
        
        Records[X]["Find_GenomeRatio"]
        Records[X]["Find_GenomeRatio"]["BiteString"] = {}
        Records[X]["Find_GenomeRatio"]["BiteString"]["Time"] = t1-t0
    ##Save Records into CSVFile 
    with open(File+'.Q1_Stats.csv', mode='w') as employee_file:
        employee_writer = csv.writer(employee_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        employee_writer.writerow(['Run', 'Function', 'String/BiteString','Time'])
        for Run in Records:
            for Function in Records[Run]:
                for S_BS in Records[Run][Function]:
                    List = []
                    List.append(Run)
                    List.append(Function)
                    List.append(S_BS)
                    List.append(Records[Run][Function][S_BS])
                    print(List)
                    employee_writer.writerow(List)
    return 0

def Time_Q3(Iterations,File):
    Records = {}
    for X in range(Iterations):
        Records[X] = {}
        
        t0 = time.time()
        Fasta = Read_fasta(File)
        t1 = time.time()
        
        Records[X]["Read_Fasta"] = {}
        Records[X]["Read_Fasta"]["String"] = {}
        Records[X]["Read_Fasta"]["String"]["Time"] = t1-t0
        
        
        t0 = time.time()
        Fasta_BS = Read_fasta(File, text=True)
        t1 = time.time()

        
        Records[X]["Read_Fasta"]["BiteString"] = {}
        Records[X]["Read_Fasta"]["BiteString"]["Time"] = t1-t0
        
        
        for Y in [4,8,12]:
            
            t0 = time.time()
            k_mer(Fasta,Y)
            t1 = time.time()
            
            Records[X][str(Y)+"_mer"] = {}
            Records[X][str(Y)+"_mer"]["String"] = {}
            Records[X][str(Y)+"_mer"]["String"]["Time"] = t1-t0
            
            
            t0 = time.time()
            k_mer(Fasta_BS,Y,text=True)
            t1 = time.time()
            
            Records[X][str(Y)+"_mer"]["BiteString"] = {}
            Records[X][str(Y)+"_mer"]["BiteString"]["Time"] = t1-t0
    ##Save Records into CSVFile 
    with open(File+'.Q3_Stats.csv', mode='w') as employee_file:
        employee_writer = csv.writer(employee_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        employee_writer.writerow(['Run', 'Function', 'String/BiteString','Time'])
        for Run in Records:
            for Function in Records[Run]:
                for S_BS in Records[Run][Function]:
                    List = []
                    List.append(Run)
                    List.append(Function)
                    List.append(S_BS)
                    List.append(Records[Run][Function][S_BS])
                    print(List)
                    employee_writer.writerow(List)
    return 0



def Time_Q5(Iterations,File):
    Records = {}
    for X in range(Iterations):
        Records[X] = {}
        
        t0 = time.time()
        Fasta = Read_fasta(File)
        t1 = time.time()
        
        Records[X]["Read_Fasta"] = {}
        Records[X]["Read_Fasta"]["String"] = {}
        Records[X]["Read_Fasta"]["String"]["Time"] = t1-t0
        Records[X]["Read_Fasta"]["String"]["File"] = File
        
        t0 = time.time()
        Fasta_BS = Read_fasta(File, text=True)
        t1 = time.time()

        
        Records[X]["Read_Fasta"]["BiteString"] = {}
        Records[X]["Read_Fasta"]["BiteString"]["Time"] = t1-t0
        Records[X]["Read_Fasta"]["BiteString"]["File"] = File
        
        for Y in [100000,500000,1000000]:
            
            t0 = time.time()
            read_samples(Fasta,50,Y)
            t1 = time.time()
            
            Records[X]["50_Mer "+str(Y)+"_Read_Samples"] = {}
            Records[X]["50_Mer "+str(Y)+"_Read_Samples"]["String"] = {}
            Records[X]["50_Mer "+str(Y)+"_Read_Samples"]["String"]["Time"] = t1-t0
            Records[X]["50_Mer "+str(Y)+"_Read_Samples"]["String"]["File"] = File
            
            t0 = time.time()
            read_samples(Fasta_BS,50,Y,text=True)
            t1 = time.time()
            
            print(X,":",Y)
            Records[X]["50_Mer "+str(Y)+"_Read_Samples"]["BiteString"] = {}
            Records[X]["50_Mer "+str(Y)+"_Read_Samples"]["BiteString"]["Time"] = t1-t0
            Records[X]["50_Mer "+str(Y)+"_Read_Samples"]["BiteString"]["File"] = File          
            
            
            #Jaccard_Index_ofK_mers(Kmer_0, Kmer_1):
    ##Save Records into CSVFile 
    with open(File+'.Q5_Stats.csv', mode='w') as employee_file:
        employee_writer = csv.writer(employee_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        employee_writer.writerow(['Run', 'Function', 'String/BiteString','Time','File'])
        for Run in Records:
            for Function in Records[Run]:
                for S_BS in Records[Run][Function]:
                    List = []
                    List.append(Run)
                    List.append(Function)
                    List.append(S_BS)
                    List.append(Records[Run][Function][S_BS]['Time'])
                    List.append(Records[Run][Function][S_BS]['File'])
                    print(List)
                    employee_writer.writerow(List)
    return 0




def Time_EC(Iterations,File):
    Records = {}
    for X in range(Iterations):
        Records[X] = {}
        
        t0 = time.time()
        Fasta = Read_fasta(File)
        t1 = time.time()
        
        Records[X]["Read_Fasta"] = {}
        Records[X]["Read_Fasta"]["String"] = {}
        Records[X]["Read_Fasta"]["String"]["Time"] = t1-t0
        
        
        t0 = time.time()
        Fasta_BS = Read_fasta(File, text=True)
        t1 = time.time()

        
        Records[X]["Read_Fasta"]["BiteString"] = {}
        Records[X]["Read_Fasta"]["BiteString"]["Time"] = t1-t0
        
        
        for Y in [100000,500000,1000000]:
            
            t0 = time.time()
            read_samples(Fasta,50,Y)
            t1 = time.time()
            
            Records[X]["50_Mer "+str(Y)+"_Read_Samples"] = {}
            Records[X]["50_Mer "+str(Y)+"_Read_Samples"]["String"] = {}
            Records[X]["50_Mer "+str(Y)+"_Read_Samples"]["String"]["Time"] = t1-t0
            
            
            t0 = time.time()
            read_samples(Fasta_BS,50,Y,text=True)
            t1 = time.time()
            
            print(X,":",Y)
            Records[X]["50_Mer "+str(Y)+"_Read_Samples"]["BiteString"] = {}
            Records[X]["50_Mer "+str(Y)+"_Read_Samples"]["BiteString"]["Time"] = t1-t0
                       
            
            
            #Jaccard_Index_ofK_mers(Kmer_0, Kmer_1):
    ##Save Records into CSVFile 
    with open(File+'.Q1_Stats.csv', mode='w') as employee_file:
        employee_writer = csv.writer(employee_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        employee_writer.writerow(['Run', 'Function', 'String/BiteString','Time'])
        for Run in Records:
            for Function in Records[Run]:
                for S_BS in Records[Run][Function]:
                    List = []
                    List.append(Run)
                    List.append(Function)
                    List.append(S_BS)
                    List.append(Records[Run][Function][S_BS]['Time'])
                    print(List)
                    employee_writer.writerow(List)
    return 0














