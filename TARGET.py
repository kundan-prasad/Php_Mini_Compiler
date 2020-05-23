#!/usr/bin/env python
# coding: utf-8

# In[2630]:


import re


# In[2652]:


x=open('ic1.txt','r')
x=x.read()


# In[2653]:


x


# In[2654]:


istemp = lambda s : bool(re.match(r"^T[0-9]*$", s)) 		#temporary variable
isid = lambda s : bool(re.match(r"^[$T][0-9A-Za-z][A-Za-z0-9_]*$", s)) #id + temporary variable
isnum=lambda s : bool(re.match(r"^[\-0-9]*([.][0-9]*)?$", s))
isloop = lambda s : bool(re.match(r"^L[0-9]*[:]$", s))


# In[2655]:


test=x.split('\n')
len(test)


# In[2656]:


arth={'+':'ADD','-':'SUB','*':'MUL','/':'DIV'}
arth


# In[2657]:


logical={"OR":'ORR',"AND":"AND"}


# In[2674]:


relational={'>':'MOVGT','<':'MOVLT','<=':'MOVLE','>=':'MOVGE','!=':'MOVE','==':'MOVNE'}
relational


# In[2675]:


busy=dict()
busyup=dict()


# In[2676]:


avail=0


# In[2677]:


asm=[]


# In[2678]:


word=[]


# In[2679]:


def assign():
    global avail
    global asm
    if(avail<16):
        temp=avail
        avail=avail+1
        return "r"+str(temp)
    temp=avail
#     print("popping"+busyup["r"+str(temp%16)])
    try:
        busy.pop(busyup["r"+str(temp%16)])
    except:
        pass
    busyup.pop("r"+str(temp%16))
    
    avail+=1
    return "r"+str(temp%16)


# In[2680]:


def loadv(vn):
    global asm
#     print("*********************** in load")
    reg=assign()
    reg2=assign()
    asm+=["LDR "+reg+",="+vn,"STR "+reg2+",["+reg+"]"]
    busy["add"+str(vn)]=reg
    busyup[reg]="add"+str(vn)
    busy[vn]=reg2
    busyup[reg2]=vn


# In[2681]:


def assignv(vn,val):
    global asm
    global word
    if(isnum(str(val))):
#         print(str(val))
        try:
            if(float(val)==int(val)):
                ty="i"
            else:
                ty="f"
        except:
            ty="f"
    else:
        ty="s"
    if(ty=="i"):
        val=int(val)
        reg=assign()
        if(val>=0):
            asm+=["MOV "+reg+",#"+str(val)]
        else:
#             print("anannananana")
            asm+=["MVN "+reg+",#"+str(-val)]
        busy[vn]=reg
        busyup[reg]=vn
        reg2=assign()
        asm+=["LDR "+reg2+",="+vn,"STR "+reg+","+reg2]
        busy["add"+str(vn)]=reg2
        busyup[reg2]="add"+str(vn)
        word+=[vn]
        
    elif(ty=="f"):
        val=float(val)
        reg=assign()
        if(val>=0):
           asm+=["VMOV.F32 "+reg+",#"+str(val)]
        else:
            asm+=["VMVN.F32 "+reg+",#"+str(-val)]
        busy[vn]=reg
        busyup[reg]=vn
        reg2=assign()
        asm+=["LDR "+reg2+",="+vn,"STR "+reg+","+reg2]
        busy["add"+str(vn)]=reg2
        busyup[reg2]="add"+str(vn)
        word+=[vn]
    elif(ty=="s"):
        if(istemp(val[0])):
            reg2=assign()
            asm+=["LDR "+reg2+",="+vn,"STR "+busy[val]+","+reg2]
            busy["add"+str(vn)]=reg2
            busyup[reg2]="add"+str(vn)
            word+=[vn]
        
    


# In[2682]:


def assignt(vn,val):
    global asm
    global word
    if(isnum(str(val))):
#         print(str(val))
        try:
            if(float(val)==int(val)):
                ty="i"
            else:
                ty="f"
        except:
            ty="f"
    else:
        ty="s"
    if(ty=="i"):
        val=int(val)
        reg=assign()
        if(val>=0):
           asm+=["MOV "+reg+",#"+str(val)]
        else:
            asm+=["MVN "+reg+",#"+str(-val)]
        busy[vn]=reg
        busyup[reg]=vn
    elif(ty=="f"):
        val=float(val)
        reg=assign()
        if(val>=0):
           asm+=["VMOV.F32 "+reg+",#"+str(val)]
        else:
            asm+=["VMVN.F32 "+reg+",#"+str(-val)]
        busy[vn]=reg
        busyup[reg]=vn
    elif(ty=="s"):
        if(istemp(val[0])):
            reg1=assign()
            asm+=["MOV "+reg1+","+busy[val]]
            busy[vn]=reg1
            busyup[reg1]=vn


# In[2683]:


asm=[]


# In[2684]:


word=[]


# In[2685]:


# 111
# ['T22', '=', '4', '*', 'T21']
# MUL
# ['T24', '=', '$r', '*', 'T22']
# MUL
t=10000
def calc(j):
    global t
    global asm
#         print(j)
    reg=assign()
    busy[j[0]]=reg
    busyup[reg]=j[0]
    if(not(istemp(j[2]))):
        if(not(istemp(j[2])) and not(isid(j[2]))):    
            assignt("T"+str(t),j[2])
            j[2]="T"+str(t)
            t+=1
        elif((isid(j[2]))):
            loadv(j[2])
#                 print("loaddddj2",j[2])
        else:
         pass
#                 print("Else j2")


    if(not(istemp(j[4]))):
        if(not(istemp(j[4])) and not(isid(j[4]))):
            assignt("T"+str(t),j[4])
            j[4]="T"+str(t)
            t+=1
        elif((isid(j[4]))):
            loadv(j[4])
#                 print("loaddddj4",j[4])
        else:
            pass
#                 print("Else j4")
    

    if(j[3] in arth):

        if(isid(j[2]) and isid(j[4])):
            asm+=[arth[j[3]]+" "+reg+","+busy[j[2]]+","+busy[j[4]]]

        else:
            print("ELSE",j)
    elif(j[3] in relational):
        if(isid(j[2]) and isid(j[4])):
            asm+=["CMP "+busy[j[2]]+","+busy[j[4]],relational[j[3]]+" "+reg+","+"#1"]#+","+busy[j[4]]]
#             print(["CMP "+busy[j[2]]+","+busy[j[4]],relational[j[3]]+" "+reg+","+"#1"])
        else:
            print("ELSE",j)
    elif(j[3] in ["AND"]):
        if(isid(j[2]) and isid(j[4])):
            asm+=["EOR "+reg+","+busy[j[2]]+","+busy[j[4]],"ORN "+reg+","+reg+","+reg] 
            
#             print(["CMP "+busy[j[2]]+","+busy[j[4]],relational[j[3]]+" "+reg+","+"#1"])
        else:
            print("ELSE",j)
    elif(j[3] in ["OR"]):
        if(isid(j[2]) and isid(j[4])):
            asm+=["ORR "+reg+","+busy[j[2]]+","+busy[j[4]]]         
#             print(["CMP "+busy[j[2]]+","+busy[j[4]],relational[j[3]]+" "+reg+","+"#1"])
        else:
            print("ELSE",j)
    else:        
        print(j)
        pass
def goto(val):
    global asm
    asm+=["B "+val]


# In[2686]:


# print(len(test))
no3=0
no5=0
no=0
n1=0
n2=0
n3=0
for i in test:
    j=i.split()
#    print(j)
    if(len(j)):
        if(len(j)==3):
            no3+=1
    #         pass
            if(not(istemp(j[0]))):
                assignv(j[0],j[2])
            elif(istemp(j[0])):
                assignt(j[0],j[2])
        elif(len(j)==5):
            no5+=1
            calc(j)
        elif(j[0]=="GOTO"):
            n1+=1
            goto(j[1])
        elif(isloop(j[0])):
            n2+=1
    #         print("loof")
            asm+=[j[0]]
        elif(len(j)==8):
            n3+=1
            asm+=["CMP "+busy[j[1]]+",#1","BEQ "+j[4],"BNE "+j[7]]
        else:
            pass
            no+=1
            print(j)
    #     print(busy)
    #     print(busyup)
# print(no3,no5,no,n1,n2,n3)


# In[2687]:


busy


# In[2688]:


busyup


# In[2689]:


for i in asm:
    print(i)



# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




