#%load_ext autoreload
#%autoreload 2
import pickle
from CwnGraph import CwnBase, CwnAnnotator
from CwnGraph import CwnRelationType
# 似乎可以不用 run 
cwn = CwnBase.install_cwn("data/cwn_graph.pyobj")
cwn = CwnBase()
from pprint import pprint

print("CwnGraph 資料查詢小幫手")
print("="*60)

switch = True
while switch == True:
    print("::: 小幫手功能說明 :::","--查詢詞義 >>>>>> 請輸入 a ","--查詢詞義與例句 >>>>>> 請輸入 b ", "--結束小幫手 >>>>>> 請輸入 1 ", sep="\n", end="\n\n\n")
    item = input('<功能選擇> 請輸入英文字母：')
    if item == "a":
        findsenses = True
        while findsenses == True:
            lookingsense = input('[a] 查詢詞義 >> 請輸入欲查詢的詞(跳出請輸入 2 )：')
            if lookingsense not in ["1", "2", "b"]:
                center = "^"+lookingsense+"$"
                lemmas = cwn.find_lemma(center)
                senses = cwn.find_senses(lemma=center)
                print("="*20,'\n','[[[查詢結果]]]','\n')
                print("所查詞彙:",lookingsense, "\n", "詞彙(lemma)數量:", len(lemmas), "\n", "詞義(sense)數量:",len(senses), "\n")
                for lemm in lemmas:
                    lemsense = lemm.senses
                    print(lemm)
                    if len(lemsense) > 0:
                        for i in range(len(lemsense)):
                            pos = lemsense[i].data()["pos"]
                        #examples = lemsense[i].examples[0]
                            print(" ", "[詞性]", pos, " ", lemsense[i])
                print("="*30)
                    
            elif lookingsense == "2":
                print("\n",'跳出詞義查詢～～～',end="\n\n")
                print("="*30)
                findsenses = False
            
            elif lookingsense == "1":
                print("\n", '再會～～～小幫手退場囉～～～',end="\n\n")
                findsenses = False
                switch = False
                
            elif lookingsense == "b":
                print("\n", '跳至查詢詞義與例句～～～',end="\n\n")
                print("="*30)
                findsenses = False 
                item = "b"
                
    if item == "b":    
        findall = True
        while findall == True:
            name = input('[b] 查詢詞義與例句 >> 請輸入欲查詢的詞(跳出請輸入 2 )：')
            seed = "^"+name+"$"
            lemman= len(cwn.find_senses(lemma=seed))
            result = {x: x.all_examples() for x in cwn.find_senses(seed)}
            
            if name not in ["1", "2", "a"]:
                print("="*20,'\n','[[[查詢結果]]]',"\n\n", "「", name, "」的詞義數量：",lemman,"\n------")
                for k, v in result.items():
                    spos = k.data()["pos"]
                    print("詞性:", spos,"  ", k,"\n", "\t::例句::", "\n\t", '\n\t'.join(v),"\n","------","\n")
                
                print("="*30)

            elif name == "2":
                print("\n", "跳出詞義與例句查詢～～～",end="\n\n")
                print("="*30)
                findall = False
                
            elif name == "1":
                print("\n", '再會～～～小幫手退場囉～～～',end="\n\n")
                findall = False
                switch = False
                
            elif name == "a":
                print("\n", '跳至查詢詞義～～～',end="\n\n")
                print("="*30)
                findall = False
                item = "a" #不知如何跳回去 [a] 查詢詞義＠＠
                findsenses = True
                
               
    if item == "1":
        print("\n", '再會～～～小幫手退場囉～～～')
        switch = False
    