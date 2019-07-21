#Using the Sieve of Eratosthenes Prime method
# This is Much faster than brute force.
#BigO(n^2)
def CreatePrimeList(Range):
  # list of our range, starting with 0's indicating primes
  # When we add a prime to our Prime List, we mark all multiples of that number larger than Prime*Prime  
  IntegerList = [0 for X in range(Range+1)]
  PrimeList = []
  Slide = 0
  for X in range(2,Range+1):
    if IntegerList == 0:
      FoundPrime = X
      PrimeList.append(FoundPrime)
      Slide = FoundPrime*FoundPrime
      while Slide <= Range:
        IntegerList[Slide] = 1
     else:
       #move on not a prime
       continue
    

class TTT():
  def __init__(self):
    # if Game index
    # 0 : Blank Square
    # 1 : X Square
    # 2 : O Square
    self.Game = [0 for X in range(9)]
    self.Player = 1   # Game Starts with X as the first player
    
  def Print(self):
    for Row in range(3):
      for Col in range(3):
        print("Row: ",Row,"\tCol: ",Col,"\tIndex:",Row*3+Col)
  def Move(self,)
  def FindHash(self):
     Primes = CreatePrimeList(100)
     Sum = 0
     for X in range(self.Game):
        Sum+=self.Game[X]*Primes[X]
     return Sum

class Test_TTT():
  def __init__(self):
    TestMoves():
  def TestMoves(self):
    self.Game = TTT()
    
Test_TTT()
