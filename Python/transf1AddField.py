#!/usr/bin/python

import sys
# Recebe path, nome da classe, nome do atributo, getter e setter para efetuar a injecao 1
print('Number of arguments:', len(sys.argv), 'arguments.')
parametros = sys.argv

if len(parametros) < 2:
    parametros = ['','D:\\Users\\Lucas\\TesteDissertacao', 'PersonName', 'secretName', 'getSecretName', 'setSecretName']

sourcePath = parametros[1]
className = parametros[2]
attributeName = parametros[3]
getterName = parametros[4]
setterName = parametros[5]


import os, os.path

for root, dirs, files in os.walk(sourcePath):
    for f in files:
        fullpath = os.path.join(root, f)
        #print(fullpath.split('\\')[-1])
        if fullpath.split('\\')[-1] == className + '.java':
            print(fullpath)
            with open(fullpath) as f:
                content = f.readlines()
            with open(fullpath+'.temp', 'w') as sourceFile:
                for line in content:
                    sourceFile.write(line+'\n')
                    if 'class ' + className in line :
                        #attribute
                        sourceFile.write('private String '+attributeName+';\n')
                        #getter method
                        sourceFile.write('public String '+getterName+'() {\n')
                        sourceFile.write('    return '+attributeName+';\n}\n')
                        #setter method
                        sourceFile.write('public void '+ setterName+ '(String '+attributeName+') {'+'\n')
                        sourceFile.write('    this.'+ attributeName +' = '+ attributeName+';\n}\n')

        if fullpath.split('\\')[-1] == className + '.hbm.xml':
            print('configuracao: ' + fullpath)
            with open(fullpath) as f:
                content = f.readlines()
            with open(fullpath+'.temp', 'w') as sourceFile:
                for line in content:
                    
                    if '</class>' in line :
                        #attribute
                        sourceFile.write('<property name="'+attributeName+'" type="java.lang.String"'+'\n')
                        sourceFile.write('access="field" column="'+attributeName+'" length="50" />'+'\n')
                    sourceFile.write(line+'\n')

        if fullpath.split('\\')[-1] == 'webModuleApplicationContext.xml':
            print('Tela: ' + fullpath)
            with open(fullpath) as f:
                content = f.readlines()
            with open(fullpath+'.temp', 'w') as sourceFile:
                flagClasse1 = False
                flagClasse11 = False
                
                flagClasse2 = False
                flagClasse21 = False
                flagClasse22 = False
                flagClasse23 = False
                
                flagClasse3 = False
                flagClasse31 = False
                flagClasse32 = False
                flagClasse33 = False
                
                
                for line in content:
                    sourceFile.write(line+'\n')
                    #Primeiro Grupo
                    if '<bean id="nameSupport" class="org.openmrs.layout.name.NameSupport">' in line :
                        flagClasse1 = True
                    if flagClasse1 and '<property name="specialTokens">' in line :
                        flagClasse11 = True
                    if flagClasse1 and flagClasse11 and '<list>' in line :
                        sourceFile.write('<value>'+attributeName+'</value>'+'\n')
                        flagClasse1 = False
                        flagClasse11 = False

                    #Segundo Grupo
                    if '<bean id="nameTemplateSpain" class="org.openmrs.layout.name.NameTemplate">' in line :
                        flagClasse2 = True
                    if '<bean id="nameTemplateShort" class="org.openmrs.layout.name.NameTemplate">' in line :
                        flagClasse2 = True
                    if '<bean id="nameTemplateLatinAmerica" class="org.openmrs.layout.name.NameTemplate">' in line :
                        flagClasse2 = True
                    if '<bean id="nameTemplateShort" class="org.openmrs.layout.name.NameTemplate">' in line :
                        flagClasse2 = True
                    if '<bean id="nameTemplateLong" class="org.openmrs.layout.name.NameTemplate">' in line :
                        flagClasse2 = True
                        
                        
                    if flagClasse2 and '<property name="nameMappings">' in line :
                        flagClasse21 = True
                    if flagClasse2 and flagClasse21 and '<props>' in line :
                        sourceFile.write('<prop key="'+attributeName+'">'+className+'.'+attributeName+'</prop>'+'\n')
                        flagClasse21 = False

                    if flagClasse2 and '<property name="sizeMappings">' in line :
                        flagClasse22 = True
                    if flagClasse2 and flagClasse22 and '<props>' in line :
                        sourceFile.write('<prop key="' + attributeName + '">30</prop>'+'\n')
                        flagClasse22 = False

                    if flagClasse2 and '<property name="lineByLineFormat">' in line :
                        flagClasse23 = True
                    if flagClasse2 and flagClasse23 and '<list>' in line :
                        sourceFile.write('<value>'+attributeName+'</value>'+'\n')
                        flagClasse2 = False
                        flagClasse23 = False
                    


        if fullpath.split('\\')[-1] == 'PersonFormController.java':
            print('Controller: ' + fullpath)
            with open(fullpath) as f:
                content = f.readlines()
            with open(fullpath+'.temp', 'w') as sourceFile:
                flagClasse1 = False
                flagClasse11 = False
                
                for line in content:
                    sourceFile.write(line+'\n')

                    if 'String[] gNames = ServletRequestUtils.getStringParameters(request, "givenName");' in line :
                        sourceFile.write('String[] v'+attributeName+' = ServletRequestUtils.getStringParameters(request, "'+attributeName+'");'+'\n')
                    
                    
                    if 'if (gNames.length >= i + 1) {' in line :
                        flagClasse1 = True
                    if flagClasse1 and 'pn.setGivenName(gNames[i]);' in line :
                        flagClasse11 = True
                    if flagClasse11 and '}' in line :
                        sourceFile.write('if (v'+attributeName+'.length >= i + 1) {'+'\n')
                        sourceFile.write('pn.setSecretName(v'+attributeName+'[i]);'+'\n')
                        sourceFile.write('}'+'\n')
                        flagClasse1 = False
                        flagClasse11 = False
                
