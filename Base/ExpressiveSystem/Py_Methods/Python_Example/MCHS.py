

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
     Primes = [1,2,3,5,7,11,13,17,19,23]
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
