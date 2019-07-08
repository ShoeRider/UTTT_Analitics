#File: srcManager/srcManager.py
#Author: Anthony Schroeder
#Date:
import ProgrammingLanguages

class _Source():
    def __init__(self,**kwargs):
        self.Location = ""
        if "Dependencies" in kwargs:
            for Dependency in kwargs["Dependencies"]:
                print (Dependency)
    def Create_Test(self):
        return 0
    def Create_src(self):
        return 0
    def Create_Test(self):

        return 0

    def WriteComment(self):
        return 0
        file1 = open("myfile.txt","w")
        file1.write(Test.Page.html)
        file1.close()



class Include():
    def __init__(self):
        self.Location = ""
