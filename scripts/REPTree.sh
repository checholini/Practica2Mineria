#!/bin/bash

#Direccion del .jar de weka
CLASSPATH="./../../weka-3-8-3/weka.jar"

#Variables clasificacion
REPTree="weka.classifiers.trees.REPTree"

#Variables Seleccion Atributos
ATRIB="weka.filters.supervised.attribute.AttributeSelection"
METHOD="weka.attributeSelection.WrapperSubsetEval"
CLASSIFIER="weka.attributeSelection.GreedyStepwise"

echo "Got $# params"

while (( "$#" )); do
    #Creacion nombre archivo de salida
    FILE_OUT="../Resultados/REPTree/Resultado_$(echo $1 | sed 's/\./\//g' | cut -d "/" -f 7 ).md"

    #Impresion de la informacion
    #cut = 1,2 Titulo; 14 Precision; 24 FMeasure
    get_acc_REPTree() {
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Correctly Classified Instances" >> ./$FILE_OUT
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Size of the tree" >> ./$FILE_OUT
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Weighted Avg" | cut -d " " -f 1,2,14,24 >> ./$FILE_OUT
        echo -e "---- \n" >> ./$FILE_OUT
    }

    show_atrib() {
        cat sel.arff | grep "@attribute" | cut -d " " -f 2 >> ./$FILE_OUT
    }
    #Ejecucion de los algoritmos

    mkdir -p ./../Resultados/REPTree/

    #Seleccion de atributos
    java -classpath $CLASSPATH $ATRIB -E "$METHOD -B $REPTree -F 5 -T 0.01 -R 1" -S "$CLASSIFIER" -i $1 > ./sel.arff
    echo -e "Atributos seleccionados: \n" > ./$FILE_OUT
    $(show_atrib)
    echo -e "\n" >> ./$FILE_OUT

    #Default tras seleccion
    echo "#Default RepTree:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $REPTree -t ./sel.arff -x 5 -M 2 > ./Prov.txt
    $(get_acc_REPTree)


    #Numero minimo de atributos por hoja = 3
    echo "#Min num Obj = 3 RepTree:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $REPTree -t ./sel.arff -x 5 -M 3 > ./Prov.txt
    $(get_acc_REPTree)

    #Numero minimo de atributos por hoja = 4
    echo "#Min num Obj = 4 RepTree:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $REPTree -t ./sel.arff -x 5 -M 4 > ./Prov.txt
    $(get_acc_REPTree)

    #Numero minimo de atributos por hoja = 5
    echo "#Min num Obj = 5 RepTree:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $REPTree -t ./sel.arff -x 5 -M 5 > ./Prov.txt
    $(get_acc_REPTree)

    rm ./Prov.txt
    rm ./sel.arff

    cat ./$FILE_OUT
    shift
done