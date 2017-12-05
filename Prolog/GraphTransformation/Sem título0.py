#!/usr/bin/python

import sys
# Recebe path, nome da classe, nome do atributo, getter e setter para efetuar a injecao 1
print('Number of arguments:', len(sys.argv), 'arguments.')
parametros = sys.argv

if len(parametros) < 2:
    parametros = ['','D:\\Users\\Lucas\\TesteDissertacao', 'PersonName', 'secretName']

sourcePath = parametros[1]
className = parametros[2]
attributeName = parametros[3]

import os, os.path

for root, dirs, files in os.walk(sourcePath):
    for f in files:
        fullpath = os.path.join(root, f)
        #print(fullpath.split('\\')[-1])
        if fullpath.split('\\')[-1] == 'webModuleApplicationContext.xml':
            print(fullpath)
            with open(fullpath) as f:
                content = f.readlines()
            with open(fullpath+'.temp', 'w') as sourceFile:
                for line in content:
                    
                    if '<value>'+attributeName+'</value>' in line :
                        #attribute
                        sourceFile.write(line.strip()[4:-4] +'\n')
                    elif '<prop key="' + attributeName + '">'+ className + '.' + attributeName + '</prop>' in line :
                        #attribute
                        sourceFile.write(line.strip()[4:-4] +'\n')
                    elif '<prop key="'+attributeName+'">' in line :
                        #attribute
                        sourceFile.write(line.strip()[4:-4] +'\n')
                    else:
                        sourceFile.write(line+'\n')    

