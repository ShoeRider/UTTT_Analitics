#File:
#Author: Anthony Schroeder
#Date:





class C_Source(_Source):
    def __init__(self,**kwargs):
        self.Location = ""
        super(C_Source, self).__init__(**kwargs)
        self.Comment      = '////'
        self.BlockComment = ""


        #specialBlocks = "#ifndef HashTable_C"
        #"#define HashTable_C"
        #"#endif // HashTable_C"

    def Add(self):
        return 0

temp = C_Source()

class SourceFile():
    def __init__(self):
        #("Header","src","Test src")
        self.Type           = ""
        self.Files          = {}
        self.DependancyTree = {}



class Module():
    def __init__(self):
        #("Header","src","Test src")
        self.header   = ""
        self.src      = ""
        self.test_src = ""
        self.test_out = ""



class Client():
    def __init__(self):
        self.Location = ""
