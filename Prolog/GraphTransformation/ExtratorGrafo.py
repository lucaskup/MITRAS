#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 25 16:23:30 2017

@author: lucas
"""
idGeral = 0
dicInd = {}
idsProibidos = set()

def traduzId(id):
    if isinstance(id, str):    

        #legal = False
        #if id == '1o0h-63ce4c49d336ff87e0b334542dd0f64b' or id == '2iaj-63ce4c49d336ff87e0b334542dd0f64b' or id == '2g8c-63ce4c49d336ff87e0b334542dd0f64b':
        #    legal = True
        #    print('achou')
        global dicInd
        if id in dicInd:
            id = dicInd[id]
        else:
            global idGeral
            idGeral += 1
            dicInd[id] = idGeral
            id = idGeral
        #if legal:
        #    print(str(id))
    return id
class Vertice():
    def __init__(self,id, nome,rotulo):
        id = traduzId(id)
        self.id = id
        self.nome = nome
        self.rotulo = rotulo
    def __str__(self):
        return "nodo(" + str(self.id)+",'"+self.nome+"','"+self.rotulo+"')"
    def __repr__(self):
        return self.__str__()
    def csv_tulip(self):
        return str(self.id) + ';'+self.nome+';'+self.rotulo
    

    

class Aresta():
    def __init__(self,id, idInicio, idFim, rotulo):
        id = traduzId(id)
        idInicio = traduzId(idInicio)
        idFim = traduzId(idFim)
        self.id = id
        self.idInicio = idInicio
        self.idFim = idFim
        self.rotulo = rotulo
        
    def __str__(self):
        return "arco(" + str(self.idInicio)+","+str(self.idFim)+",'"+self.rotulo+"')"
    def __repr__(self):
        return self.__str__()
    def csv_tulip(self):
        return str(self.idInicio) + ';'+str(self.idFim)+';'+self.rotulo
    
def criaJSPPersonName():
    # 1 - PersonForm
    v1 = Vertice('JSP-01','PersonForm','form')
    v2 = Vertice('JSP-02','NamePanel','panel')
    v3 = Vertice('JSP-03','AddressPanel','panel')
    v4 = Vertice('JSP-04','InformationPanel','panel')
    
    listaUINodes.append(v1)
    listaUINodes.append(v2)
    listaUINodes.append(v3)
    listaUINodes.append(v4)
    
    idPerson = [nodoNome for nodoNome in listaClasses if nodoNome.nome == 'Person'][0].id
    idName = [nodoNome for nodoNome in listaClasses if nodoNome.nome == 'PersonName'][0].id
    idAddress = [nodoNome for nodoNome in listaClasses if nodoNome.nome == 'PersonAddress'][0].id
    idAttribute = [nodoNome for nodoNome in listaClasses if nodoNome.nome == 'PersonAttribute'][0].id
    
    a1 = Aresta('ARCO-01',v1.id,idPerson,'show')
    a2 = Aresta('ARCO-02',v2.id,idName,'show')
    a3 = Aresta('ARCO-03',v3.id,idAddress,'show')
    a4 = Aresta('ARCO-04',v4.id,idAttribute,'show')
    
    a5 = Aresta('ARCO-05',v1.id,v2.id,'has')
    a6 = Aresta('ARCO-06',v2.id,v3.id,'next')
    a7 = Aresta('ARCO-07',v3.id,v4.id,'next')
            
    listaUIEdges.append(a1)
    listaUIEdges.append(a2)
    listaUIEdges.append(a3)
    listaUIEdges.append(a4)
    listaUIEdges.append(a5)
    listaUIEdges.append(a6)
    listaUIEdges.append(a7)
    
def criaJSPEncounter():
    # 1 - PersonForm
    v1 = Vertice('JSP1-01','EncounterForm','form')
    v2 = Vertice('JSP1-02','EncounterSummaryPanel','panel')
    v3 = Vertice('JSP1-03','ProviderPanel','panel')
    v4 = Vertice('JSP1-04','ObservationPanel','panel')
    
    listaUINodes.append(v1)
    listaUINodes.append(v2)
    listaUINodes.append(v3)
    listaUINodes.append(v4)
    
    idEncounter = [nodoNome for nodoNome in listaClasses if nodoNome.nome == 'Encounter'][0].id
    idProvider = [nodoNome for nodoNome in listaClasses if nodoNome.nome == 'EncounterProvider'][0].id
    idObs = [nodoNome for nodoNome in listaClasses if nodoNome.nome == 'Obs'][0].id
    
    
    a1 = Aresta('ARCO-01',v1.id,idEncounter,'show')
    a2 = Aresta('ARCO-02',v2.id,idEncounter,'show')
    a3 = Aresta('ARCO-03',v3.id,idProvider,'show')
    a4 = Aresta('ARCO-04',v4.id,idObs,'show')
    
    a5 = Aresta('ARCO-05',v1.id,v2.id,'has')
    a6 = Aresta('ARCO-06',v2.id,v3.id,'next')
    a7 = Aresta('ARCO-07',v3.id,v4.id,'next')
            
    listaUIEdges.append(a1)
    listaUIEdges.append(a2)
    listaUIEdges.append(a3)
    listaUIEdges.append(a4)
    listaUIEdges.append(a5)
    listaUIEdges.append(a6)
    listaUIEdges.append(a7)


import xml.etree.ElementTree as etree
tree = etree.parse("diagrama2OpenMRS.xml")
root = tree.getroot()
content = root[1]
#Remove as tags JUDE pois elas tem referencia para as 
#classes e acaba lendo as classes em dobro
content.remove(content[4])
classes = tree.findall('.//{org.omg.xmi.namespace.UML}Class')
listaClasses = []
listaInterfaces = []
listaAtributos = []
listaMetodos = []
listaArestasAttMet = []

listaUINodes = []
listaUIEdges = []

idInternoAresta = 0

listaDebug = []
for c in classes:
    if len(c)> 0 and c.attrib['name'].strip() != '':
        verticeClasse = Vertice(c.attrib['xmi.id'],c.attrib['name'],'class')
        listaClasses.append(verticeClasse)
        features = c.find('{org.omg.xmi.namespace.UML}Classifier.feature')
        if features is not None:
            for f in features:
                isAttr = f.tag == '{org.omg.xmi.namespace.UML}Attribute'
                if f.attrib['name'].strip() != '':
                    listaDebug.append(f.attrib['name'])
                    v = Vertice(f.attrib['xmi.id'],f.attrib['name'],'attribute' if isAttr else 'method')
                    idInternoAresta += 1
                    listaArestasAttMet.append(Aresta(idInternoAresta,verticeClasse.id,v.id,'attribute' if isAttr else 'method'))
                    if isAttr:
                        listaAtributos.append(v)
                    else:
                        listaMetodos.append(v)
    elif len(c)> 0 and c.attrib['name'].strip() == '':
        idsProibidos.add(c.attrib['xmi.id'])
                    

interfaces = tree.findall('.//{org.omg.xmi.namespace.UML}Interface')
for i in interfaces:
    if len(i)> 0 and i.attrib['name'].strip() != '':
        verticeInterface = Vertice(i.attrib['xmi.id'],i.attrib['name'],'interface')
        listaInterfaces.append(verticeInterface)
        features = i.find('{org.omg.xmi.namespace.UML}Classifier.feature')
        if features is not None:
            for f in features:
                isAttr = f.tag == '{org.omg.xmi.namespace.UML}Attribute'
                if f.attrib['name'].strip() != '':
                    v = Vertice(f.attrib['xmi.id'],f.attrib['name'],'attribute' if isAttr else 'method')
                    idInternoAresta += 1
                    listaArestasAttMet.append(Aresta(idInternoAresta,verticeClasse.id,v.id,'attribute' if isAttr else 'method'))
                    if isAttr:
                        listaAtributos.append(v)
                    else:
                        listaMetodos.append(v)
    elif  len(i)> 0 and i.attrib['name'].strip() == '':
        idsProibidos.add(i.attrib['xmi.id'])


    
herancas = tree.findall('.//{org.omg.xmi.namespace.UML}Generalization')
listaHerancas = []
for h in herancas:
    if len(h) > 0: 
        try:
            id = h.attrib['xmi.id']
            idFilho = h.find('{org.omg.xmi.namespace.UML}Generalization.child')[0].attrib['xmi.idref']
            idPai = h.find('{org.omg.xmi.namespace.UML}Generalization.parent')[0].attrib['xmi.idref']
            if idPai not in idsProibidos and idFilho not in idsProibidos:
                listaHerancas.append(Aresta(id,idFilho,idPai,'inheritance'))
        except:
            print("Exception Heranças")
            pass

usos = tree.findall('.//{org.omg.xmi.namespace.UML}Usage')
listaUsos = []
for u in usos:
    if len(u) > 0: 
        try:
            id = u.attrib['xmi.id']
            idFilho = u.find('{org.omg.xmi.namespace.UML}Dependency.client')[0].attrib['xmi.idref']
            idPai = u.find('{org.omg.xmi.namespace.UML}Dependency.supplier')[0].attrib['xmi.idref']
            if idPai not in idsProibidos and idFilho not in idsProibidos:
                listaUsos.append(Aresta(id,idFilho,idPai,'use'))
        except:
            print("Exception Heranças")
            pass


associacoes = tree.findall('.//{org.omg.xmi.namespace.UML}Association')
listaAssociacoes = []
for a in associacoes:
    if len(a) > 0:
        id = a.attrib['xmi.id']
        a = a.find('.//{org.omg.xmi.namespace.UML}Association.connection')
        associationEnd = a.find('{org.omg.xmi.namespace.UML}AssociationEnd')
        if not (associationEnd is None):
            try:
                
                idPai = associationEnd.find('{org.omg.xmi.namespace.UML}Feature.owner')[0].attrib['xmi.idref']
                idFilho = associationEnd.find('{org.omg.xmi.namespace.UML}AssociationEnd.participant')[0].attrib['xmi.idref']
                if idPai not in idsProibidos and idFilho not in idsProibidos:
                    listaAssociacoes.append(Aresta(id,idFilho,idPai,'association'))
            except:
                #print("Excessão de Associação")
                pass

#for c in listaClasses:
#    print(c)
#for h in listaHerancas:
#    print(h)
#for h in listaUsos:
#    print(h)
#for a in listaAtributos:
#    print(a)
#for m in listaMetodos:
#    print(m)
#for a in listaArestasAttMet:
#    print(a)

#Relacionamentos com a interface, garimpados na mão 

criaJSPPersonName()
criaJSPEncounter()


print('Classes: ',str(len(listaClasses)))
print('Interfaces: ',str(len(listaInterfaces)))
print('Atributos: ',str(len(listaAtributos)))
print('Métodos: ',str(len(listaMetodos)))
print('UINodes: ',str(len(listaUINodes)))

print('Heranças: ',str(len(listaHerancas)))
print('Usos: ',str(len(listaUsos)))
print('AtribOuMetodo: ',str(len(listaArestasAttMet)))
print('Associacoes: ',str(len(listaAssociacoes)))
print('UIEdges: ',str(len(listaUIEdges)))


with open('tulipNodes.csv','w') as file:
    for c in listaClasses:
        file.write(c.csv_tulip()+'\n')
    for i in listaInterfaces:
        file.write(i.csv_tulip()+'\n')
    for a in listaAtributos:
        file.write(a.csv_tulip()+'\n')
    for m in listaMetodos:
        file.write(m.csv_tulip()+'\n')
    for ui in listaUINodes:
        file.write(ui.csv_tulip()+'\n')
        
with open('tulipEdges.csv','w') as file:
    for h in listaHerancas:
        file.write(h.csv_tulip()+'\n')
    for u in listaUsos:
        file.write(u.csv_tulip()+'\n')
    for a in listaArestasAttMet:
        file.write(a.csv_tulip()+'\n')
    for ass in listaAssociacoes:
        file.write(ass.csv_tulip()+'\n')
    for uie in listaUIEdges:
        file.write(uie.csv_tulip()+'\n')

def outroMetodo():
    with open('basefatosprolog.pl','w') as file:
        file.write(':- dynamic arco/3.\n')
        for c in listaClasses:
            file.write(str(c)+'.\n')
        for i in listaInterfaces:
            file.write(str(i)+'.\n')
        for a in listaAtributos:
            file.write(str(a)+'.\n')
        for m in listaMetodos:
            file.write(str(m)+'.\n')
        for ui in listaUINodes:
            file.write(str(ui)+'.\n')
        for h in listaHerancas:
            file.write(str(h)+'.\n')
        for u in listaUsos:
            file.write(str(u)+'.\n')
        for a in listaArestasAttMet:
            file.write(str(a)+'.\n')
        for ass in listaAssociacoes:
            file.write(str(ass)+'.\n')
        for uie in listaUIEdges:
            file.write(str(uie)+'.\n')
outroMetodo()



#for key, value in dicInd.items():
#    if value == 6090:
#        print(key)