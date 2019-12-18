#!/bin/bash

#Direccion del .jar de weka
CLASSPATH="./../../weka-3-8-3/weka.jar"

#Variables clasificacion
JRip="weka.classifiers.rules.JRip"
ZEROR="weka.classifiers.rules.ZeroR"

#Variables Seleccion Atributos
ATRIB="weka.filters.supervised.attribute.AttributeSelection"
METHOD="weka.attributeSelection.WrapperSubsetEval"
CLASSIFIER="weka.attributeSelection.GreedyStepwise"

echo "Got $# params"

while (( "$#" )); do

    #Creacion nombre archivo de salida
    FILE_OUT="../Resultados/JRip/Resultado_$(echo $1 | sed 's/\./\//g' | cut -d "/" -f 7 ).md"

    #Impresion de la informacion
    #cut = 1,2 Titulo; 14 Precision; 24 FMeasure
    get_acc_JRip() {
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Correctly Classified Instances" >> ./$FILE_OUT
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Number of Rules" >> ./$FILE_OUT
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Weighted Avg" | awk '{print $1, $2, $5, $7}' >> ./$FILE_OUT
        echo -e "---- \n" >> ./$FILE_OUT
    }

    show_atrib() {
        cat sel.arff | grep "@attribute" | cut -d " " -f 2 >> ./$FILE_OUT
    }
    #Ejecucion de los algoritmos

    mkdir -p ./../Resultados/JRip/

    #Seleccion de atributos
    java -classpath $CLASSPATH $ATRIB -E "$METHOD -B $JRip -F 5" -S "$CLASSIFIER" -i $1 > ./sel.arff
    echo -e "#Atributos seleccionados: \n" > ./$FILE_OUT
    $(show_atrib)
    echo -e "\n" >> ./$FILE_OUT

    echo "#JRip 2 Folds:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $JRip -t ./sel.arff -F 2 -x 5  > ./Prov.txt
    $(get_acc_JRip)

    #Default tras seleccion
    echo "#Default JRip:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $JRip -t ./sel.arff -F 3 -x 5  > ./Prov.txt
    $(get_acc_JRip)

    #Default tras seleccion
    echo "#JRip 4 Folds:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $JRip -t ./sel.arff -F 4 -x 5  > ./Prov.txt
    $(get_acc_JRip)

    #Default tras seleccion
    echo "#JRip 5 Folds:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $JRip -t ./sel.arff -F 5 -x 5  > ./Prov.txt
    $(get_acc_JRip)

    rm ./Prov.txt
    rm ./sel.arff

    cat ./$FILE_OUT
    shift
done